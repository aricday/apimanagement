return {
  examples: [
       {
               name: "Registering with an external service",
               code: "<div id='ExampleDiv'><h3>Calling an external registration</h3>A common use of a startup listener is to register the newly-up server with a service discovery platform, such as Consul. This example demonstrates how to register the Live API Creator server with an external registry.<p/>\n<pre>// This is only a very generic example\nvar json = listenerUtil.restPost(\n  'https://consul.rocks/v1/agent/members',\n  {},\n  {headers:\n    {\"X-Consul-Token\": \"abcd1234\"}\n  },\n  {name: listenerUtil.getHostName()}\n);</pre></div>"
       }
 ]
};
