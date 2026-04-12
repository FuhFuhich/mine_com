import 'package:flutter_test/flutter_test.dart';
import 'package:mine_com_mobile/model/server_log_model.dart';

void main() {
  test('parses console lines into typed log entries', () {
    final errorEntry = ServerLogEntry.fromConsoleLine(
      line: '[ERROR] Exception while starting the server',
    );
    final warnEntry = ServerLogEntry.fromConsoleLine(
      line: '[WARN] Server is overloaded',
    );

    expect(errorEntry.level, LogLevel.error);
    expect(warnEntry.level, LogLevel.warn);
    expect(errorEntry.message, contains('Exception'));
  });
}
