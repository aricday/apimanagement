log.info("Begin MongoDB invoke");
var logMessage = "";

// Invoke a Mongo function
var procCall = procedure_name + "(";
var firstParam = true;

if (log.isFinestEnabled()) {
	logMessage = "MongoDB - Procedure " + procedure_name;
	log.finest(logMessage);
}

for (var argNum in procArgs) {
	if (!firstParam) {
		procCall += ",";
	}
	procCall += args.get(procArgs.get(argNum).name);
	firstParam = false;
}

if (log.isFinestEnabled()) {
	logMessage = "MongoDB - Procedure call " + procCall;
	log.finest(logMessage);
}

var result = connection.db.runCommand(new env.Document("$eval", procCall + ")")).toJson();

if (log.isDebugEnabled()) {
	logMessage = "MongoDB - invoke with result " + result;
	log.debug(logMessage);
}

log.info("End MongoDB invoke");
return result;
