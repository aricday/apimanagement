log.info('DSP:JDBCExample - open begin');

// the config_info_code.js defined the variable names below:
var databaseName = settings && settings.database || 'Northwind';
var schema = settings && settings.schema || 'NORTHWIND';
var username = settings && settings.username || 'NORTHWIND';
var password = settings && settings.password;

var url = env.jdbcInfo + databaseName;

//var url = uri + hostname + ":" + port +"/" + databaseName; // use this for most JDBC database connections
if (log.isFinestEnabled()) {
	log.finest('JDBCExample -  URL ' + url);
}

var connection = env.DriverManager.getConnection(url, username, password);
connection.setAutoCommit(false); //required by LAC

log.info('DSP:JDBCExample - open end');
return connection;
