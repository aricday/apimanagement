return {
examples: [
{
name: "Update backend upon Kafka record reception",
code: "<div id='ExampleDiv'>"+
"   <h3>Update backend upon record reception</h3>"+
"   In this example, we use an Kafka Listener to log the incoming messages into a table in the database. The database could be your own or managed"+
"   by Layer7 Live API Creator. "+
"   <p/>"+
"   <pre>"+
"// Getting the string equivalent of the record message.\n"+
"var messageContent = record.value();\n"+
"// Create the payload\n"+
"var messageAudit = {};\n"+
"var date  = new Date();\n"+
"messageAudit.date = date.getFullYear() + '-' + (date.getMonth() + 1) + '-' + date.getDate() + ' ' +  date.getHours() + ':' + date.getMinutes() + ':' + date.getSeconds();\n"+
"messageAudit.message = messageContent;\n"+
"// Insert the payload into the audit table\n"+
"var resourceURL = 'http://localhost:8080/APIServer/rest/default/demo_mysql/v1/demo:message_audit';\n"+
"var parms = {};\n"+
"var settings = { 'headers': {'Authorization' : 'CALiveAPICreator demo_full:1'}};\n"+
"var postResponse = listenerUtil.restPost(resourceURL, parms, settings, messageAudit);\n"+
"log.debug(postResponse);\n"+
"log.debug('Logged '+messageAudit+' into message_audit table.');\n"+
"</pre>"+
"</div>"
}
]
};
