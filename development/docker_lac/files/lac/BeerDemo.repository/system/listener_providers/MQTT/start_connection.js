/*
* Method that determines where each parameter defined for this provider should fit in the
* underlying Paho API.
*/
var resolveParameters = function resolveParameters(parameters,client,connOpts){
 var sslProperties = null;
 try{
  if(typeof parameters != 'undefined' && null !== parameters){
   for(var key in parameters){
    var parameterValue = parameters[key];
    switch(key){
     default:
      print("Unknown parameter : "+key);
      break;
     case 'broker':
     case 'clientId':
      // Do nothing
      break;
     case 'manualAcks':
      // Convert to boolean
      parameterValue = (parameterValue == 'true');
      client.setManualAcks(parameterValue);
      break;
     case 'automaticReconnect':
      // Convert to boolean
      parameterValue = (parameterValue == 'true');
      connOpts.setAutomaticReconnect(parameterValue);
      break;
     case 'cleanSession':
      // Convert to boolean
      parameterValue = (parameterValue == 'true');
      connOpts.setCleanSession(parameterValue);
      break;
      case 'connectionTimeout':
      // Convert to integer
      parameterValue = parseInt(parameterValue,10);
      connOpts.setConnectionTimeout(parameterValue);
      break;
      case 'keepAliveInterval':
      // Convert to integer
      parameterValue = parseInt(parameterValue,10);
      connOpts.setKeepAliveInterval(parameterValue);
      break;
      case 'maxInflight':
      // Convert to integer
      parameterValue = parseInt(parameterValue,10);
      connOpts.setMaxInflight(parameterValue);
      break;
      /* Credentials */
      case 'userName':
      connOpts.setUserName(parameterValue);
      break;
      case 'password':
      connOpts.setPassword(parameterValue.toCharArray());
      break;
      /* Credential end */
      case 'serverURIs':
       var serverURIArray = parameterValue.split(",");
       /* This overrides the broker URI */
      connOpts.setServerURIs(serverURIArray);
      break;
      case 'com.ibm.ssl.protocol':
      case 'com.ibm.ssl.contextProvider':
      case 'com.ibm.ssl.keyStore':
      case 'com.ibm.ssl.protocol':
      case 'com.ibm.ssl.keyStorePassword':
      case 'com.ibm.ssl.keyStoreType':
      case 'com.ibm.ssl.protocol':
      case 'com.ibm.ssl.keyStoreProvider':
      case 'com.ibm.ssl.trustStore':
      case 'com.ibm.ssl.trustStorePassword':
      case 'com.ibm.ssl.trustStoreProvider':
      case 'com.ibm.ssl.enabledCipherSuites':
      case 'com.ibm.ssl.keyManager':
      case 'com.ibm.ssl.trustManager':
      if(sslProperties === null){
       sslProperties = new env.Properties();
      }
      sslProperties.setProperty(key,parameterValue);
      break;
    }
   }
   if(sslProperties !== null){
    // Setting the SSL configuration to Connect Options.
    connOpts.setSSLProperties(sslProperties);
   }
  }
 }catch(e){
  print("Parameter resolution encountered an exception inside Start Connection. \n Parameters being resolved :\n"+JSON.stringify(parameters));
  print("\nException :\n"+e+"\n Line number : "+e.lineNumber+"\n Stack  : \n"+e.stack);
  throw e;
 }
}

out.println("Starting an MQTT connection: " + connection.name);
// ClientId resolution.
var clientId = parameters.clientId;
if(clientId === "RANDOM"){
 clientId = env.MqttClient.generateClientId();
 log.info("Randomized client name: "+clientId);
}

var memPers = new env.MemoryPersistence();
var client = new env.MqttClient(parameters.broker, clientId, memPers);
var connOpts = new env.MqttConnectOptions();
log.debug("Resolving parameters...");
resolveParameters(parameters,client,connOpts);
// Connecting...
client.connect(connOpts);
out.println("MQTT Client "+clientId+" has been created and connected.");
// And remember to register the connection object (wrapped into an object in case
// we want to save more stuff later on)
return {
    mqttClient: client,
    persistence: memPers,
    startupEnv: env
};
