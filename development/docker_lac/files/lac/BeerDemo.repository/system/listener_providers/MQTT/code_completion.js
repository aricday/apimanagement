return {
     message:[{
      caption: "int getMessageId()",
      value: "getMessageId()",
      meta: "method",
      tooltip: "html:<h3>getMessageId()</h3><p/>Get the identifier of instance <code>MQTTReceivedMessage</code>"
   }, {
      caption: "String toString()",
      value: "toString()",
      meta: "method",
      tooltip: "html:<h3>toString()</h3><p/>Returns a string representation of this message's payload. Makes an attempt to return the payload as a string. As the MQTT client has no control over the content of the payload it may fail."
   }, {
      caption: "byte[] getPayload()",
      value: "getPayload()",
      meta: "method",
      tooltip: "html:<h3>getPayload()</h3><p/>Returns the payload as a byte array."
   }],
   message_docs:{
      type:"object",
      tooltip:"html:<h3>Message</h3><p/>Object containing the received MQTT Message. An instance of <code>MQTTReceivedMessage</code>.<p/>Additional method definitions can be found <a href='http://www.eclipse.org/paho/files/javadoc/index.html?org/eclipse/paho/client/mqttv3/internal/wire/MqttReceivedMessage.html'>here</a>."
   }
};
