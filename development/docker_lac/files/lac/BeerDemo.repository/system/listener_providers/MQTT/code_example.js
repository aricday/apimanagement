return {
examples: [
{
name: "Update backend upon Message reception",
code: "<div id='ExampleDiv'>"+
"   <h3>Update backend upon Message reception</h3>"+
"<h4>Background</h4>" +
"You can write JavaScript code that is executed whenever the " +
"<strong>MQTT listener</strong></a> receives any messages for the defined topic." +
"<p/>" +
"<h4>Example</h4>" +
"As shown in this example, " +
"we use an MQTT Listener to log the incoming messages into a table in the database. The database could be your own or managed by Layer7 Live API Creator."+
"<br/><br/>"+
"   <p/>"+
"   <pre>"+
"// Getting the string equivalent of the message.\n"+
"var messageContent = message.toString();\n"+
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
