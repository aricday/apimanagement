return {
examples: [
{
          name: "Publish a message to KafkaProducer",
          code: "<div id='ExampleDiv'>"+
                <h3>Publish a KafkaProducer Message</h3>"+
                In this example, we want to send a message"+
                to a broker endpoint using a named KafkaProducer connection. "+
               <p/>"+
              <pre>"+
              var connectionName = 'KafkaProducerConnection';
"+
              var topic = 'myTopic';
"+
              var msg = 'my kafka message';
"+
              var options = {key: 'myKey',partition: 0};
"+
              var response = SysUtility.publishMessage(connectionName,topic,msg,options);
"+
              if(response.isSuccess) {
"+
                  log.debug(JSON.stringify(response));
"+
              }
"+
          </pre>"+
          </div>"
       }
    ]
};
