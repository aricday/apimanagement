CA Live API Creator  /with Pivotal Cloud Foundry
================================

This project structure will allow 'cf push' to create the application "ca-live-api-creator"



Missing Dependencies
-------------------------
* CALiveAPICreator.war 
* /WEB-INF
	  ⋅*/lib
	  	⋅⋅⋅* ## additional DB driver jar files ##

To add additional drivers to the .war file, add jar to directory and execute:
```
jar uf CALiveAPICreator.war WEB-INF/lib/derby.jar
```

Use CLI to set the external admin DB connection:
```
cf set-env ca-live-api-creator JDBC_CONNECTION_STRING jdbc:mysql://us-cdbr-iron-east-05.cleardb.net:3306
cf set-env ca-live-api-creator JDBC_CONNECTION_USERNAME b80c5bccf256fc
cf set-env ca-live-api-creator JDBC_CONNECTION_PASSWORD 4d513e3c
cf set-env ca-live-api-creator JDBC_CONNECTION_DB_NAME ad_832479345bf8d0d
```

Or set the Environment Variables using PCF console
```
JDBC_CONNECTION_STRING = jdbc:mysql://us-cdbr-iron-east-05.cleardb.net:3306
JDBC_CONNECTION_USERNAME = b80c5bccf256fc
JDBC_CONNECTION_PASSWORD = 4d513e3c
JDBC_CONNECTION_DB_NAME = ad_832479345bf8d0d
```

If you're feeling lucky, you could even define in-memory database, e.g.:
```
JDBC_CONNECTION_STRING=jdbc:derby:memory:admindb;create=true
```
