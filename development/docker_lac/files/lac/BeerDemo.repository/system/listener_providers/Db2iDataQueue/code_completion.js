return {
    message:[],
    message_docs:{
        type:"object",
        tooltip:"html:<h3>Message</h3><p/>An implementation of <code>org.apache.camel.Message</code>. <p/>The implementation class is based on the type of the listener and consequently the Camel component."
    },
    payloadAsString:[],
    payloadAsString_docs:{
        type:"object",
        tooltip:"html:<h3>payloadAsString</h3><p/>The payload of the message converted into <p/><code>java.lang.String</code>. This is done automatically by Camel during bean binding."
    },
    exchangeException:[],
    exchangeException_docs:{
        type:"object",
        tooltip:"html:<h3>exchangeException</h3><p/>The <code>exchangeException</code> object is the Java representation of the exception that is thrown during an exchange. "
    },
    headers:[],
    headers_docs:{
        type:"object",
        tooltip:"html:<h3>headers</h3><p/>This is a Java object containing the inbound Message headers."
    },
    outHeaders:[],
    outHeaders_docs:{
        type:"object",
        tooltip:"html:<h3>outHeaders</h3><p/>This is a Java object containing the outbound Message headers."
    },
    properties:[],
    properties_docs:{
        type:"object",
        tooltip:"html:<h3>properties</h3><p/>This is a Java object containing the properties of an Exchange."
    },
    exchange:[],
    exchange_docs:{
        type:"object",
        tooltip:"html:<h3>exchange</h3><p/>This is a Java object that encapsulates a Camel Message during routing."+
        "<p/>For more information, <a href='https://camel.apache.org/maven/current/camel-core/apidocs/org/apache/camel/Exchange.html'>see here</a>."
    },
    typeConverter:[],
    typeConverter_docs:{
        type:"object",
        tooltip:"html:<h3>typeConverter</h3><p/>This is a Java object that represents the TypeConverter that was part of the Message routing."+
        "<p/>For more information, <a href='https://camel.apache.org/maven/current/camel-core/apidocs/org/apache/camel/Exchange.html'>see here</a>."
    },
    camelContext:[],
    camelContext_docs:{
        type:"object",
        tooltip:"html:<h3>camelContext</h3><p/>This is a Java object that represents the <code>Camel-Context</code>.The implementation <br/> of this context is dependent on the listener type."+
        "<p/>For more information, <a href='http://camel.apache.org/maven/current/camel-core/apidocs/org/apache/camel/CamelContext.html'>see here</a>."
    }
};
