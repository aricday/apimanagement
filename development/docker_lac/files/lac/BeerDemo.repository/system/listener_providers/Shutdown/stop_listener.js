out.println("Executing shutdown listener: " + listener.name);

try {
    listener.executor.execute({});
}
catch (e) {
    print("Error "+e.message);
    throw e;
}
