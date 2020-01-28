(function () {
	'use strict';
	log.info("DSP:JDBCExample - configInfo begin");

	var configInfo = {
		ui_config: [{
			display: "Database",
			type: "string",
			length: 90,
			required: true,
			parameterName: "database",
			placeholder: "Enter the database name",
			description: "Name of your Database"
		}, {
			display: "Username",
			type: "string",
			length: 90,
			required: false,
			parameterName: "username",
			placeholder: "Enter the authentication username",
			description: "Authorized Username for your Database"
		}, {
			display: "Schema",
			type: "string",
			length: 90,
			required: false,
			parameterName: "schema",
			placeholder: "Enter the authentication username",
			description: "Authorized Username for your Database"
		}, {
			display: "Password",
			type: "secret",
			length: 90,
			required: false,
			parameterName: "password",
			placeholder: "Enter the password for the database user",
			description: "The password for the database user. Once saved, it is encrypted and can therefore appear longer than expected."
		}],
		// Environment variables used in all JS code (e.g., env.jdbcInfo)
		env: {
			System: Java.type("java.lang.System"),
			DriverManager: Java.type("java.sql.DriverManager"),
			jdbcInfo: "jdbc:derby:",
			sqlSelectTest: "select * from \"SYS\".\"SYSTABLES\" FETCH FIRST 1 ROWS ONLY",
			leftQuote: "\"",
			rightQuote: "\""
		}
	};

	if (log.isDebugEnabled()) {
		log.debug("JDBCExample - configInfo return" + JSON.stringify(configInfo));
	}

	log.info("DSP:JDBCExample - configInfo end");

	return configInfo;
})();
