return {
    record:[{
      caption: "int partition()",
      value: "partition()",
      meta: "method",
      tooltip: "html:<h3>partition()</h3><p/>The partition to which the record will be sent (or null if no partition was specified)"
   }, {
      caption: "String toString()",
      value: "toString()",
      meta: "method",
      tooltip: "html:<h3>toString()</h3><p/>Returns a string representation of this record."
   }, {
      caption: "String topic()",
      value: "topic()",
      meta: "method",
      tooltip: "html:<h3>toString()</h3><p/>This is the topic for this received message."
   }, {
      caption: "String value()",
      value: "value()",
      meta: "method",
      tooltip: "html:<h3>value()</h3><p/>Returns the value or message content."
   }, {
      caption: "String offset()",
      value: "offset()",
      meta: "method",
      tooltip: "html:<h3>toString()</h3><p/>Returns record offset number."
   }, {
      caption: "String key()",
      value: "key()",
      meta: "method",
      tooltip: "html:<h3>key()</h3><p/>The key (or null if no key is specified)."
   }, {
      caption: "long timestamp()",
      value: "timestamp()",
      meta: "method",
      tooltip: "html:<h3>timestamp()</h3><p/>The timestamp of this record."
   }],
   record_docs:{
      type:"object",
      tooltip:"html:<h3>Record</h3><p/>Record is an object containing the received Kafka Message. An instance of <code>ProducerRecord</code>.<p/>Additional method definitions can be found <a href='https://kafka.apache.org/0101/javadoc/index.html?org/apache/kafka/clients/consumer/KafkaConsumer.html' target='_blank'>here</a>."
   }
};
