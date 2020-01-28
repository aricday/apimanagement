var context = new env.DefaultCamelContext();
context.setName("Context_" + connection.name);

var Jt400Component =  Java.type("org.apache.camel.component.jt400.Jt400Component");
var jt400Component = new Jt400Component();

// Set component properties
var componentProperties = parameters["componentProperties"];

env.props = new env.Properties();
for (var paramName in parameters) {
    if (null !== parameters[paramName]) {
        env.props.put(paramName, parameters[paramName]);
    }
}

for (var key in componentProperties) {
    var methodName = "set" + key.charAt(0).toUpperCase() + key.substring(1);
    if (null !== componentProperties[key]) {
        jt400Component[methodName](componentProperties[key]);
    }
}

// Add the component to the context.
context.addComponent("jt400", jt400Component);

context.start();

if (typeof connectionInfo != 'undefined' && null !== connectionInfo) {
    var serviceStatus = connectionInfo.camelContext.getStatus();
    if (serviceStatus.isStarted()) {
        return {
           status: "OK"
        };
    }
    else {
        return {
            status: "NOT OK"
        };
    }
}
else {
    return {
        status: "OK"
    };
}
