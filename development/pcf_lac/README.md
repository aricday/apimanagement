CA Live API Creator  /with Pivotal Cloud Foundry
================================

This project structure will allow 'cf push' to create the application "ca-live-api-creator"



Missing Dependencies
-------------------------
* CALiveAPICreator.war 
* /WEB-INF
	  * /lib
	  	  * additional DB driver jar files

To add additional drivers to the .war file, add jar to directory and execute:
```
jar uf CALiveAPICreator.war WEB-INF/lib/derby.jar
```

Use CLI to set the external admin DB connection:
```
cf set-env ca-live-api-creator JDBC_CONNECTION_STRING jdbc:mysql://us-iron-east-05.cleardb.net:3306
cf set-env ca-live-api-creator JDBC_CONNECTION_USERNAME your _username
cf set-env ca-live-api-creator JDBC_CONNECTION_PASSWORD your _password
cf set-env ca-live-api-creator JDBC_CONNECTION_DB_NAME name_of_db
cf set-env ca-live-api-creator TZ 'UTC' (required for Oracle 12c)
```

Or set the Environment Variables using PCF console
```
JDBC_CONNECTION_STRING = jdbc:mysql://us-iron-east-05.cleardb.net:3306
JDBC_CONNECTION_USERNAME = your _username
JDBC_CONNECTION_PASSWORD = your _password
JDBC_CONNECTION_DB_NAME = name_of_db
```

If you're feeling lucky, you could even define in-memory database, e.g.:
```
JDBC_CONNECTION_STRING=jdbc:derby:memory:admindb;create=true
```

Once running, use the following command to deploy a JWT testing project to the instance
``` 
./licenseLAC.sh 
```

