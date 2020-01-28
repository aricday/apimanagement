return {
  examples: [
       {
               name: "Notifying an external service",
               code: "<div id='ExampleDiv'><h3>Notifying an external service</h3>A shutdown listener can be used for a variety of purposes, but a common one is to notify some sort of external registry that this server is coming down, perhaps something like Consul.<p/>Note that a shutdown listener is not <i>absolutely</i> guaranteed to be called when a server comes down, depending on how the server gets stopped.<p/>\n<pre>// This is only a very generic example\nvar json = listenerUtil.restPost(\n  'https://consul.rocks/v1/agent/members',\n  {},\n  {headers:\n    {\"X-Consul-Token\": \"abcd1234\"}\n  },\n  {name: listenerUtil.getHostName()}\n);</pre></div>"
       },
 ]
};
