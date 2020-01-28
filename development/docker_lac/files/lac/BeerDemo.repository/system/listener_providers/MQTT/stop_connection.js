out.println("Connection "+connection.mqttClient.getClientId()+" is getting disconnected and closed.");
if(connection && connection.mqttClient && connection.mqttClient.isConnected()){
   connection.mqttClient.disconnect();
   log.debug("Connection "+connection.mqttClient.getClientId()+" has been successfully closed.");
}
connection.mqttClient && connection.mqttClient.close();
var clientId = (connection.mqttClient !== null)?connection.mqttClient.getClientId():null;
out.println("Connection "+ clientId +" has been successfully closed.");
