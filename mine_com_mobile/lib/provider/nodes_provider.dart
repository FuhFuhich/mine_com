import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/minecraft_server_model.dart';
import '../model/node_model.dart';
import 'app_dependencies.dart';
import 'minecraft_server_provider.dart';

class NodeDetailData {
  const NodeDetailData({
    required this.node,
    required this.usage,
    required this.hardware,
    required this.servers,
  });

  final NodeModel node;
  final NodeUsageModel? usage;
  final NodeHardwareModel? hardware;
  final List<MinecraftServerModel> servers;
}

final nodesProvider = Provider<AsyncValue<List<NodeModel>>>((ref) {
  return ref.watch(serverListPageProvider).whenData((value) => value.nodes);
});

final nodeDetailProvider =
    FutureProvider.family<NodeDetailData, String>((ref, nodeId) async {
  final nodesRepository = ref.watch(nodesRepositoryProvider);
  final serverRepository = ref.watch(minecraftServerRepositoryProvider);

  final node = await nodesRepository.fetchNode(nodeId);
  final usageFuture = _safe(() => nodesRepository.fetchNodeUsage(nodeId));
  final hardwareFuture = _safe(() => nodesRepository.fetchNodeHardware(nodeId));
  final serversFuture = serverRepository.fetchServersByNode(nodeId);

  final results = await Future.wait<Object?>([
    usageFuture,
    hardwareFuture,
    serversFuture,
  ]);

  return NodeDetailData(
    node: node,
    usage: results[0] as NodeUsageModel?,
    hardware: results[1] as NodeHardwareModel?,
    servers: results[2] as List<MinecraftServerModel>,
  );
});

Future<T?> _safe<T>(Future<T> Function() action) async {
  try {
    return await action();
  } catch (_) {
    return null;
  }
}
