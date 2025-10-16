import 'package:flutter/material.dart';
import '../../model/server_model.dart';

class ServerListWrapper extends StatefulWidget {
  const ServerListWrapper({super.key});

  @override
  State<ServerListWrapper> createState() => _ServerListWrapperState();
}

class _ServerListWrapperState extends State<ServerListWrapper> {
  final List<ServerModel> _servers = [
    ServerModel(name: 'Minecraft Server 1', status: 'Онлайн', players: 12),
    ServerModel(name: 'Minecraft Server 2', status: 'Оффлайн', players: 0),
  ];

  void _addServer() {
    setState(() {
      _servers.add(ServerModel(
        name: 'Новый сервер ${_servers.length + 1}',
        status: 'Онлайн',
        players: 0,
      ));
    });
  }

  void _removeServer() {
    setState(() {
      if (_servers.isNotEmpty) _servers.removeLast();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      appBar: AppBar(
        backgroundColor: const Color(0xFF222222),
        title: const Text('Список серверов'),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _addServer,
            icon: const Icon(Icons.add, color: Color(0xFF00E676)),
            tooltip: 'Добавить сервер',
          ),
          IconButton(
            onPressed: _removeServer,
            icon: const Icon(Icons.remove, color: Colors.redAccent),
            tooltip: 'Удалить последний',
          ),
        ],
      ),
      body: _servers.isEmpty
          ? const Center(
              child: Text(
                'Нет серверов',
                style: TextStyle(color: Color(0xFFBBBBBB)),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _servers.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final server = _servers[index];
                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF222222),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF404040)),
                  ),
                  child: ListTile(
                    leading: Icon(
                      server.status == 'Онлайн'
                          ? Icons.cloud_done
                          : Icons.cloud_off,
                      color: server.status == 'Онлайн'
                          ? const Color(0xFF00E676)
                          : Colors.redAccent,
                    ),
                    title: Text(
                      server.name,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      'Игроков: ${server.players}',
                      style: const TextStyle(color: Color(0xFFBBBBBB)),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
