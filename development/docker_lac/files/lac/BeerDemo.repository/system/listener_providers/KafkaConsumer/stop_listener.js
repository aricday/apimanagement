out.println("Stopping KafkaConsumer listener: " + listener.name);
var thread = env.ThreadMap.get(listener.name);
try { thread && thread.interrupt(); } catch (e) { }
env.ThreadMap.remove(listener.name);
