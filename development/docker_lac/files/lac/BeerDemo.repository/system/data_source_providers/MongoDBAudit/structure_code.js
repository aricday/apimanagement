(function () {
	'use strict';

	// This will only define 1 object schema type used by the LAC Audit service.

	log.info("DSP:MongoDBAudit - structure begin");
	var isFinestLoggingEnabled = log.isFinestEnabled();

	var structure = parameters.structure;
	dspFactory.createString("string", -1);
	dspFactory.createInteger("number", 4);
	dspFactory.createJSON("json_coll");

	var entity = {
		name: settings && settings.audit_collection || 'audit',
		columns: [],
		keys: [],
		parents: []
	};
	var column = {};

	column = {
		name: '_id',
		attrTypeName: dspFactory.createString("_id", -1),
		isNullable: false,
		isAutoIncrement: true,
		isDefaulted: false
	};
	entity.columns.push(column);

	column = {
		name: 'accountName',
		attrTypeName: "string",
		isNullable: true,
		isAutoIncrement: false,
		isDefaulted: false
	};
	entity.columns.push(column);


	column = {
		name: 'projectName',
		attrTypeName: "string",
		isNullable: false,
		isAutoIncrement: false,
		isDefaulted: false
	};
	entity.columns.push(column);

	column = {
		name: 'resourceName',
		attrTypeName: "string",
		isNullable: false,
		isAutoIncrement: false,
		isDefaulted: false
	};
	entity.columns.push(column);

	column = {
		name: 'requestSequenceId',
		attrTypeName: "number",
		isNullable: true,
		isAutoIncrement: false,
		isDefaulted: false
	};
	entity.columns.push(column);

	column = {
		name: 'userName',
		attrTypeName: "string",
		isNullable: true,
		isAutoIncrement: false,
		isDefaulted: false
	};
	entity.columns.push(column);


	column = {
		name: 'userIP',
		attrTypeName: "string",
		isNullable: true,
		isAutoIncrement: false,
		isDefaulted: false
	};
	entity.columns.push(column);

	column = {
		name: 'entityName',
		attrTypeName: "string",
		isNullable: false,
		isAutoIncrement: false,
		isDefaulted: false
	};
	entity.columns.push(column);


	column = {
		name: 'datasource',
		attrTypeName: "string",
		isNullable: true,
		isAutoIncrement: false,
		isDefaulted: false
	};
	entity.columns.push(column);


	column = {
		name: 'oldValue',
		attrTypeName: "json_coll",
		isNullable: true,
		isAutoIncrement: false,
		isDefaulted: false
	};
	entity.columns.push(column);


	column = {
		name: 'newValue',
		attrTypeName: "json_coll",
		isNullable: true,
		isAutoIncrement: false,
		isDefaulted: false
	};
	entity.columns.push(column);


	column = {
		name: 'actionType',
		attrTypeName: "string",
		isNullable: false,
		isAutoIncrement: false,
		isDefaulted: false
	};
	entity.columns.push(column);


	column = {
		name: 'ts',
		attrTypeName: "string",
		isNullable: true,
		isAutoIncrement: false,
		isDefaulted: false
	};
	entity.columns.push(column);


	column = {
		name: 'pk',
		attrTypeName: "string",
		isNullable: true,
		isAutoIncrement: false,
		isDefaulted: false
	};
	entity.columns.push(column);


	column = {
		name: 'nestLevel',
		attrTypeName: "number",
		isNullable: true,
		isAutoIncrement: false,
		isDefaulted: false
	};
	entity.columns.push(column);

	column = {
		name: 'apiKey',
		attrTypeName: "string",
		isNullable: true,
		isAutoIncrement: false,
		isDefaulted: false
	};
	entity.columns.push(column);

	column = {
		name: 'apiVersion',
		attrTypeName: "number",
		isNullable: true,
		isAutoIncrement: false,
		isDefaulted: false
	};
	entity.columns.push(column);

	column = {
		name: 'projectId',
		attrTypeName: "number",
		isNullable: true,
		isAutoIncrement: false,
		isDefaulted: false
	};
	entity.columns.push(column);


	column = {
		name: 'prefix',
		attrTypeName: "string",
		isNullable: true,
		isAutoIncrement: false,
		isDefaulted: false
	};
	entity.columns.push(column);

	column = {
		name: 'txSummary',
		attrTypeName: dspFactory.createCollection("txSummary_coll", "string", "string"),
		isNullable: true,
		isAutoIncrement: false,
		isDefaulted: false
	};
	entity.columns.push(column);

	var key = {
		name: "_id",
		seq: 1,
		isDatabasePrimary: true,
		columns: [
			"_id"
		]
	};
	entity.keys.push(key);

	if (log.isDebugEnabled()) {
		log.debug("DSP:MongoDBAudit - structure result: " + JSON.stringify(structure));
	}

	structure.tables.add(entity);
	log.info("DSP:MongoDBAudit - structure end");
})();
