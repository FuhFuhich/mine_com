import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/minecraft_server_model.dart';
import '../model/node_model.dart';
import 'app_dependencies.dart';

class ServerListPageData {
  const ServerListPageData({
    required this.nodes,
    required this.servers,
  });

  final List<NodeModel> nodes;
  final List<MinecraftServerModel> servers;

  Map<String, NodeModel> get nodesById {
    return <String, NodeModel>{
      for (final node in nodes) node.id: node,
    };
  }

  NodeRole? roleForServer(MinecraftServerModel server) {
    return nodesById[server.nodeId]?.role;
  }
}

final searchQueryProvider = StateProvider<String>((ref) => '');

final serverListPageProvider = FutureProvider<ServerListPageData>((ref) async {
  final nodesRepository = ref.watch(nodesRepositoryProvider);
  final serverRepository = ref.watch(minecraftServerRepositoryProvider);

  final results = await Future.wait<Object>([
    nodesRepository.fetchNodes(),
    serverRepository.fetchServers(),
  ]);

  return ServerListPageData(
    nodes: results[0] as List<NodeModel>,
    servers: results[1] as List<MinecraftServerModel>,
  );
});

final filteredServerListProvider =
    Provider<AsyncValue<List<MinecraftServerModel>>>((ref) {
  final page = ref.watch(serverListPageProvider);
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();

  return page.whenData((data) {
    if (query.isEmpty) {
      return data.servers;
    }

    return data.servers.where((server) {
      final nodeName = data.nodesById[server.nodeId]?.name.toLowerCase() ?? '';
      return server.name.toLowerCase().contains(query) ||
          server.nodeName.toLowerCase().contains(query) ||
          nodeName.contains(query);
    }).toList(growable: false);
  });
});

final serverByIdProvider = Provider.family<MinecraftServerModel?, String>((ref, id) {
  final page = ref.watch(serverListPageProvider).valueOrNull;
  if (page == null) {
    return null;
  }

  for (final server in page.servers) {
    if (server.id == id) {
      return server;
    }
  }
  return null;
});

final nodeRoleByServerIdProvider = Provider.family<NodeRole?, String>((ref, id) {
  final page = ref.watch(serverListPageProvider).valueOrNull;
  final server = ref.watch(serverByIdProvider(id));
  if (page == null || server == null) {
    return null;
  }

  return page.nodesById[server.nodeId]?.role;
});
