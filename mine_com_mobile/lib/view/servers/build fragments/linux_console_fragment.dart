import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:xterm/xterm.dart';
import '../../../model/linux_server_model.dart';
import 'package:mine_com_mobile/l10n/app_localizations.dart';

class LinuxConsoleFragment extends StatefulWidget {
  final LinuxServerModel server;
  
  const LinuxConsoleFragment({super.key, required this.server});

  @override
  State<LinuxConsoleFragment> createState() => _LinuxConsoleFragmentState();
}

class _LinuxConsoleFragmentState extends State<LinuxConsoleFragment> {
  bool _isConnecting = false;
  bool _isConnected = false;
  String? _errorMessage;
  
  SSHClient? _sshClient;
  SSHSession? _shell;
  Terminal? _terminal;
  
  StreamSubscription<Uint8List>? _stdoutSubscription;
  StreamSubscription<Uint8List>? _stderrSubscription;

  @override
  void initState() {
    super.initState();
    _initializeTerminal();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _connectToServer();
    });
  }

  void _initializeTerminal() {
    _terminal = Terminal(
      maxLines: 10000,
    );
    
    _terminal!.onOutput = (data) {
      if (_shell != null) {
        _shell!.write(Uint8List.fromList(data.codeUnits));
      }
    };
  }

  Future<void> _connectToServer() async {
    if (_isConnecting) return;

    final l10n = AppLocalizations.of(context)!;

    setState(() {
      _isConnecting = true;
      _errorMessage = null;
    });

    try {
      final socket = await SSHSocket.connect(
        widget.server.host,
        widget.server.port,
      );
      
      final client = SSHClient(
        socket,
        username: widget.server.username,
        onPasswordRequest: () => widget.server.password,
      );

      await client.run('whoami');
      
      setState(() {
        _sshClient = client;
        _isConnected = true;
        _isConnecting = false;
      });

      _showSnackBar('${l10n.connectedToLinuxConsole} ${widget.server.name}', isSuccess: true);
      
      await _startInteractiveSession(client);
      
    } catch (e) {
      setState(() {
        _isConnecting = false;
        _errorMessage = '${l10n.connectionErrorLinuxConsole} $e';
      });
      _showSnackBar('${l10n.failedToConnect1LinuxConsole} $e');
    }
  }

  Future<void> _startInteractiveSession(SSHClient client) async {
    final l10n = AppLocalizations.of(context)!;
    
    try {
      _shell = await client.shell(
        pty: SSHPtyConfig(
          width: _terminal!.viewWidth,
          height: _terminal!.viewHeight,
        ),
      );
      
      _stdoutSubscription = _shell!.stdout.listen((data) {
        _terminal?.write(String.fromCharCodes(data));
      });

      _stderrSubscription = _shell!.stderr.listen((data) {
        _terminal?.write(String.fromCharCodes(data));
      });

      _shell!.done.then((_) {
        if (mounted) {
          _showSnackBar(l10n.sshSessionEndedLinuxConsole);
          _disconnect();
        }
      });
      
    } catch (e) {
      setState(() {
        _errorMessage = '${l10n.shellStartupErrorLinuxConsole} $e';
      });
      _showSnackBar('${l10n.shellStartupErrorLinuxConsole} $e');
    }
  }

  Future<void> _disconnect() async {
    await _stdoutSubscription?.cancel();
    await _stderrSubscription?.cancel();
    _shell?.close();
    _sshClient?.close();
    
    setState(() {
      _isConnected = false;
      _sshClient = null;
      _shell = null;
      _stdoutSubscription = null;
      _stderrSubscription = null;
    });
    
    _terminal?.eraseDisplay();
    
    final l10n = AppLocalizations.of(context)!;
    _showSnackBar(l10n.disconnectedFromServerLinuxConsole);
  }

  void _showSnackBar(String message, {bool isSuccess = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isSuccess ? Icons.check_circle : Icons.error,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    _stdoutSubscription?.cancel();
    _stderrSubscription?.cancel();
    _shell?.close();
    _sshClient?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.server.name} - ${l10n.consoleLinuxConsole}'),
        actions: [
          if (_isConnected)
            IconButton(
              icon: const Icon(Icons.power_settings_new),
              onPressed: _disconnect,
              tooltip: l10n.disconnectLinuxConsole,
            ),
          if (!_isConnected && !_isConnecting)
            IconButton(
              icon: const Icon(Icons.link),
              onPressed: _connectToServer,
              tooltip: l10n.reconnectLinuxConsole,
            ),
        ],
      ),
      body: _buildBody(theme),
    );
  }

  Widget _buildBody(ThemeData theme) {
    if (_isConnecting) {
      return _buildConnectingView();
    }

    if (!_isConnected && _errorMessage != null) {
      return _buildErrorView(theme);
    }

    if (_isConnected) {
      return _buildTerminalView();
    }

    return _buildConnectingView();
  }

  Widget _buildConnectingView() {
    final l10n = AppLocalizations.of(context)!;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          Text(
            '${l10n.connectedToLinuxConsole} ${widget.server.name}...',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${widget.server.host}:${widget.server.port}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 24),
            Text(
              l10n.failedToConnect2LinuxConsole,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _errorMessage ?? l10n.unknownErrorLinuxConsole,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _connectToServer,
              icon: const Icon(Icons.link),
              label: Text(l10n.tryAgainLinuxConsole),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTerminalView() {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade700),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: TerminalView(_terminal!),
      ),
    );
  }
}
