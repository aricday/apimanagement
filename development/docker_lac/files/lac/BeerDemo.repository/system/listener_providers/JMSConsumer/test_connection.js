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
