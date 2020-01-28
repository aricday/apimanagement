var ClusterSyncManager = Java.type("com.kahuna.server.cluster.ClusterSyncManager");
var clusterSync = ClusterSyncManager.getClusterSync();
if (ClusterSyncManager.isCluster && listener.num_servers === 1) {
    var myMap = clusterSync.getMap("StartupListeners");
    var PlatformInfo = Java.type("com.kahuna.server.platform.PlatformInfo");
    var previousValue = myMap.putIfAbsent(listenerUniqueId, PlatformInfo.getServerUUID());
    if (null == previousValue) {
        listener.executor.execute({});
        out.println("Executing startup listener (cluster mode): " + listener.name);
    }
    else {
        out.println("Startup listener has already been executed in this cluster: " + listener.name);
    }
}
else {
    out.println("Executing startup listener (single-node mode): " + listener.name);
    listener.executor.execute({});
}
return {};
