log.debug("Publish KakfkaProducer Message ["+ message + "] topic [" + topic +"]");
var KafkaProducer = new env.KafkaProducer(env.props);

// Resolve options
var partition = null;
var key1 = null;
if (typeof options != 'undefined' && null !== options) {
    for (var key in options) {
        if (options.hasOwnProperty(key)) {
            if (key === 'partition') {
                partition = parseInt(options[key],10);
            }
            else if (key === 'key') {
                key1 = options[key];
            }
            else {
                log.debug("Unrecognized option : " + key);
            }
        }
    }
}

var ProducerRecord;
if (partition) {
    ProducerRecord = new env.ProducerRecord(topic, key1, partition, message);
}
else {
    ProducerRecord = new env.ProducerRecord(topic, message);
}
var future = KafkaProducer.send(ProducerRecord);
var recordMetadata = future.get();
out.println("recordMetadata " + recordMetadata);
KafkaProducer.flush();
KafkaProducer.close();
