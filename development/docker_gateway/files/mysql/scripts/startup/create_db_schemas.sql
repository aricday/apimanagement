#
#  Copyright (c) 2016 CA. All rights reserved.
#
#  This software may be modified and distributed under the terms
#  of the MIT license. See the LICENSE file for details.
#
# This creates the user in mysql and grant it permissions

-- create gateway databases
CREATE DATABASE IF NOT EXISTS `ssg`;
CREATE USER 'gateway'@'localhost' IDENTIFIED BY '7layer';
GRANT ALL PRIVILEGES ON ssg.* TO 'gateway'@'%' WITH GRANT OPTION;

-- create OTK databases
CREATE DATABASE IF NOT EXISTS `otk_db`;
CREATE USER 'otk_user'@'%' IDENTIFIED BY '7layer';
GRANT ALL ON otk_db.* TO 'otk_user'@'%';

-- create MAG databases
CREATE DATABASE IF NOT EXISTS `mag_db`;
CREATE USER 'mag_user'@'%' IDENTIFIED BY '7layer';
GRANT ALL ON mag_db.* TO 'mag_user'@'%';

FLUSH PRIVILEGES;

USE otk_db;
-- CA Technologies
-- Database schema for OTK
--
-- This table holds valid client application values as defined when the application was registered
--
CREATE TABLE oauth_client (
  client_ident varchar(128) primary key,
  name varchar(128) not null COMMENT 'The associated name of the application using this client_id',
  type varchar(128) not null DEFAULT 'oob' COMMENT 'used with oauth 2.0',
  description varchar(256) null,
  organization varchar(128) not null,
  registered_by varchar(128) not null,
  created bigint DEFAULT 0 not null,
  custom longtext null COMMENT 'longtext object containing custom fields',
  constraint uk_oc_name_org unique (name, organization)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

-- add IDX to oauth_client
CREATE INDEX oc_idx_clientname ON oauth_client(name);
--
-- This table holds valid client keys
--
CREATE TABLE oauth_client_key (
  client_key varchar(128) primary key COMMENT 'oauth_consumer_key or client_id',
  secret varchar(128) not null COMMENT 'oauth_consumer_key_secret or client_secret',
  scope varchar(512) not null DEFAULT 'oob' COMMENT 'for oauth2, to be defined by the customer and handled accordingly within the policy',
  callback varchar(2048) not null DEFAULT 'oob' COMMENT 'in oauth2 = redirect_uri, contains one URI',
  environment varchar(128) not null DEFAULT 'ALL' COMMENT 'COULD BE SOMETHING LIKE Test, Prod, Integration',
  expiration bigint not null DEFAULT 0 COMMENT 'Date until this key is valid',
  status varchar(128) not null COMMENT 'for validation purposes, ENABLED or DISABLED',
  created bigint DEFAULT 0 not null,
  created_by varchar(128) not null,
  client_ident varchar(128) not null COMMENT 'The client that owns this key',
  client_name varchar(128) not null COMMENT 'The name of the client that owns this key. Not normalized for performance.',
  custom longtext null COMMENT 'longtext object containing custom fields',
  serviceIds varchar(256) null COMMENT 'A list of service IDs that the key is authorized for',
  accountPlanMappingIds varchar(256) null COMMENT 'Account plan associated with the client',
  constraint ock_fk_clientIdent foreign key (client_ident) references oauth_client (client_ident) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;
-- Add IDX to oauth_client_key
CREATE INDEX ock_idx_clientident ON oauth_client_key(client_ident);
--
-- This table holds access_tokens and refresh_tokens
-- oauth 1.0 = access_token
-- oauth 2.0 = access_token, refresh_token
--
CREATE TABLE oauth_token (
  otk_token_id varchar(128) primary key,
  token varchar(128) unique,
  secret varchar(128) null COMMENT 'null for oauth 2.0, it does not provide a secret',
  expiration bigint not null,
  scope varchar(512) null COMMENT 'for 0auth 2.0, the scope granted by the resource owner',
  resource_owner varchar(128) not null COMMENT 'the authenticated user that granted the token',
  created bigint DEFAULT 0 COMMENT 'the date this token (or these tokens in oauth 2.0) were created',
  rtoken varchar(128) null unique key,
  rexpiration bigint DEFAULT 0 COMMENT 'DEFAULT 0 because otherwise timestamp will be set to now() on an update',
  status varchar(128) not null COMMENT 'for validation purposes, ENABLED or DISABLED',
  client_key varchar(128) not null COMMENT 'the client_key this token was issued for',
  client_name varchar(128) not null COMMENT 'The name of the client that owns this key. Not normalized for performance.',
  client_ident varchar(128) not null COMMENT 'Client',
  custom longtext null COMMENT 'longtext object containing custom fields'

) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;
-- Adding indexes to oauth_token. This will improve the overall performance
CREATE INDEX oat_idx_expiration ON oauth_token (expiration);
CREATE INDEX oat_idx_rowner_client ON oauth_token(resource_owner,client_key);
CREATE INDEX oat_idx_rowner ON oauth_token(resource_owner);
CREATE INDEX oat_idx_client ON oauth_token(client_key);
CREATE INDEX oat_idx_rowner_client_ident ON oauth_token(resource_owner, client_ident);
--
-- This table holds temporary tokens
-- oauth 1.0 = request_token
-- oauth 2.0 = authorization_code
--
CREATE TABLE oauth_initiate (
  token varchar(128) primary key COMMENT 'for oauth 1.0, 2.0',
  secret varchar(128) null COMMENT 'null for oauth 2.0, it does not provide a secret',
  expiration bigint not null DEFAULT 0 COMMENT 'for oauth 1.0, 2.0, DEFAULT 0 because otherwise timestamp will be set to now() on an update',
  scope varchar(512) null COMMENT 'for oauth 2.0, the scope granted by the resource owner',
  resource_owner varchar(128) null COMMENT 'the authenticated user that granted the token',
  created bigint DEFAULT 0 COMMENT 'the date this token (or these tokens in oauth 2.0) were created',
  verifier varchar(128) null COMMENT 'for oauth 1.0',
  callback varchar(256) null COMMENT 'for oauth 1.0, 2.0',
  client_key varchar(128) not null COMMENT 'the client that received this token',
  client_name varchar(128) not null COMMENT 'The name of the client that owns this key. Not normalized for performance.',
  custom longtext null COMMENT 'longtext object containing custom fields'
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;
--
-- This table holds session info
--
CREATE TABLE oauth_session (
  session_key varchar(128) not null,
  session_group varchar(128) not null,
  expiration bigint not null,
  value mediumtext not null,
  primary key (session_key, session_group)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;
--
CREATE TABLE otk_version (
  current_version char(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;
INSERT INTO otk_version (current_version) VALUES ('otk4.2.00');
--
-- This table will contain all id_token
--
CREATE TABLE oauth_id_token (
  resource_owner varchar(128) not null,
  azp varchar(128) not null,
  sub varchar(128) null,
  jwt_id varchar(512) null,
  jwt mediumtext not null,
  salt varchar(128) null,
  shared_secret varchar(128) null,
  shared_secret_type varchar(128) null,
  iss varchar(128) not null,
  expiration bigint not null COMMENT 'expiration date in seconds',
  constraint pk_mag_id_token primary key (resource_owner, azp)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;
-- Adding indexes to oauth_id_token. This will improve the overall performance
CREATE INDEX oaidt_idx_expiration ON oauth_id_token (expiration);
CREATE INDEX oaidt_idx_azp ON oauth_id_token (azp);
--
-- CA API Portal API Keys
--
CREATE TABLE portal_apikey (
  apikey_pk varchar(128) primary key COMMENT 'id from JSON Sync message',
  apikey varchar(255) unique not null COMMENT 'key from JSON Sync message',
  apikey_secret varchar(255) not null COMMENT 'secret from JSON Sync message',
  status varchar(100) not null COMMENT 'status from JSON sync message',
  organization_id varchar(128) not null COMMENT 'organizationId from JSON sync message. Previously this was accountPlanMappingId',
  organization varchar(255) not null COMMENT 'organizationName from JSON sync message',
  label varchar(255) not null COMMENT 'label from JSON sync message',
  created_by varchar(128) not null COMMENT 'createdBy from JSON sync message',
  modified_by varchar(128) not null COMMENT 'modifiedBy from JSON sync message',
  created bigint DEFAULT 0 not null COMMENT 'the date this apikey was created, which is now in the case of it being a new one',
  updated bigint DEFAULT 0 not null COMMENT 'the date this apikey was updated, which is now',
  apis longtext null COMMENT 'apis from JSON sync message',
  value_xml longtext not null COMMENT 'Contains more or less all values again'
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;
--
CREATE INDEX papikey_updated ON portal_apikey (updated);
--
--
-- Test data for an initial installation.
--
-- Delete the existing test clients to install them
--
delete from oauth_client where client_ident = '123456800-otk';
delete from oauth_client_key where client_ident = '123456800-otk';
delete from oauth_client where client_ident = '123456801-otk';
delete from oauth_client_key where client_ident = '123456801-otk';
delete from oauth_client where client_ident = 'TestClient1.0';
delete from oauth_client_key where client_ident = '1234TestClient1.0';
delete from oauth_client where client_ident = 'TestClient2.0';
delete from oauth_client_key where client_ident = 'TestClient2.0';
--
-- OpenID Connect Client for the Basic Client Profile specification
--
insert into oauth_client (client_ident, name, description, organization, registered_by, type, custom)
values ('123456800-otk', 'OpenID Connect Basic Client Profile', 'Test for OpenID Connect BCP', 'Layer7 Technologies Inc.', 'admin', 'confidential', '{}');
insert into oauth_client_key (client_key, secret, status, created_by, client_ident, client_name, callback, scope, custom)
values ('5eed868e-7ad0-4172-88f2-704bcf78b61e', '2054e4d7-77f2-46c9-bc4d-11a47255a6ec', 'ENABLED', 'admin', '123456800-otk', 'OpenID Connect Basic Client Profile', 'https://mas:8443/oauth/v2/client/bcp?auth=done', 'openid email profile phone address', '{}');
--
-- OpenID Connect Client for the Implicit Client Profile specification
--
insert into oauth_client (client_ident, name, description, organization, registered_by, type, custom)
values ('123456801-otk', 'OpenID Connect Implicit Client Profile', 'Test for OpenID Connect ICP', 'Layer7 Technologies Inc.', 'admin', 'public', '{}');
insert into oauth_client_key (client_key, secret, status, created_by, client_ident, client_name, callback, scope, custom)
values ('5edc4a38-75ec-4617-8854-1a71ff1e0a2e', '5005a669-0295-4602-be7d-6a75342db6d8', 'ENABLED', 'admin', '123456801-otk', 'OpenID Connect Implicit Client Profile', 'https://mas:8443/oauth/v2/client/icp?auth=done', 'openid email profile phone address', '{}');
--
-- Create an OAuth 1.0 and OAuth 2.0 client
--
INSERT INTO oauth_client (client_ident, name, description, organization, registered_by, custom)
VALUES ('TestClient1.0', 'OAuth1Client', 'OAuth 1.0 test client hosted on the ssg', 'Layer7 Technologies Inc.', 'admin', '{}');

INSERT INTO oauth_client (client_ident, name, description, organization, registered_by, type, custom)
VALUES ('TestClient2.0', 'OAuth2Client', 'OAuth 2.0 test client hosted on the ssg', 'Layer7 Technologies Inc.', 'admin', 'confidential', '{}');

INSERT INTO oauth_client_key (client_key, secret, status, created_by, client_ident, client_name, scope, custom)
VALUES ('acf89db2-994e-427b-ac2c-88e6101f9433', '74d5e0db-cd8b-4d8e-a989-95a0746c3343', 'ENABLED', 'admin', 'TestClient1.0', 'OAuth1Client', 'scope_test', '{}');

INSERT INTO oauth_client_key (client_key, secret, status, created_by, client_ident, client_name, callback, custom)
VALUES ('54f0c455-4d80-421f-82ca-9194df24859d', 'a0f2742f-31c7-436f-9802-b7015b8fd8e6', 'ENABLED', 'admin', 'TestClient2.0', 'OAuth2Client', 'https://mas:8443/oauth/v2/client/authcode,https://mas:8443/oauth/v2/client/implicit', '{}');



COMMIT;

-- CA Technologies
-- Database schema for MAG
--

CREATE TABLE mag_msso_device (
  certdn varchar (248) not null COMMENT 'The complete DN of the cert',
  magidentifier varchar(128) not null,
  username varchar(128) not null COMMENT 'The username who registered this device',
  deviceid varchar(128) not null,
  devicename varchar(128) not null,
  devicestatus varchar (32) not null,
  created bigint not null DEFAULT 0 COMMENT 'the date this device was registered',
  updated bigint not null DEFAULT 0 COMMENT 'the date this device registration was updated',
  multiuser varchar(32) null COMMENT 'indicates whether this device provides multiuser support',
  csr_base64 mediumtext null COMMENT 'the certificate signing request used when device first registered',
  signed_cert_base64 mediumtext null COMMENT 'the currently active base64 encoded ca_msso signed cert',
  grace_expiration bigint not null DEFAULT 0 COMMENT 'This is the grace expiry date of the device certificate, it is calculated based on certificate expiry + configured accept_expiry time period',
  constraint uk_mag_msso_device_dn unique (certdn),
  constraint uk_mag_msso_device_id unique (deviceid),
  constraint pk_msso_device primary key (magidentifier)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

CREATE INDEX device_status_index ON mag_msso_device(devicestatus);
CREATE INDEX device_username_index ON mag_msso_device(username);

CREATE TABLE mag_device_app (
  magidentifier varchar(128) not null,
  client_key varchar(128) not null,
  access_token varchar(128) not null,
  constraint pk_mag_device_app primary key (magidentifier, client_key),
  constraint fk_mag_device_app foreign key (magidentifier) references mag_msso_device (magidentifier) on delete cascade
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;
CREATE INDEX mda_magidentifier ON mag_device_app(magidentifier);
CREATE INDEX mda_access_token ON mag_device_app(access_token);

CREATE TABLE mag_version (
  current_version char(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;
INSERT INTO mag_version (current_version) VALUES ('mag4.1.00');
--
-- Adding a table to support MAG OTP
--
CREATE TABLE mag_otp_records (
  USER_ID varchar(128) NOT NULL,
  OTP VARCHAR(64) NOT NULL,
  RETRY_COUNT TINYINT NOT NULL DEFAULT 0,
  EXPIRATION_TIME BIGINT NOT NULL DEFAULT 0,
  NEXT_ALLOWED_TIME BIGINT NOT NULL DEFAULT 0,
  CREATED BIGINT NOT NULL DEFAULT 0,
  PRIMARY KEY (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE INDEX UIDX ON mag_otp_records(otp);

-- Mobile test client installation:
--

-- MAG/ MSSO test device data:
--
DELETE FROM mag_device_app WHERE magidentifier = 'magidentifier01';
DELETE FROM mag_device_app WHERE magidentifier = 'magidentifier02';
DELETE FROM mag_device_app WHERE magidentifier = 'magidentifier04';
DELETE FROM mag_device_app WHERE magidentifier = 'magidentifier06';

DELETE FROM mag_msso_device WHERE magidentifier = 'magidentifier01';
DELETE FROM mag_msso_device WHERE magidentifier = 'magidentifier02';
DELETE FROM mag_msso_device WHERE magidentifier = 'magidentifier03';
DELETE FROM mag_msso_device WHERE magidentifier = 'magidentifier04';
DELETE FROM mag_msso_device WHERE magidentifier = 'magidentifier06';

INSERT INTO mag_msso_device (certdn,magidentifier,username,deviceid,devicename,devicestatus,created,updated,multiuser)
VALUES ('certdn01', 'magidentifier01', 'username01', 'deviceid01', 'devicename01', 'activated',(unix_timestamp()+86400),(unix_timestamp()+86400),"TRUE");
INSERT INTO mag_msso_device (certdn,magidentifier,username,deviceid,devicename,devicestatus,created,updated,multiuser)
VALUES ('certdn02', 'magidentifier02', 'username01', 'deviceid02', 'devicename02', 'activated',(unix_timestamp()+86400),(unix_timestamp()+86400),"TRUE");
INSERT INTO mag_msso_device (certdn,magidentifier,username,deviceid,devicename,devicestatus,created,updated,multiuser)
VALUES ('certdn06', 'magidentifier06', 'username02', 'deviceid06', 'devicename06', 'registered',(unix_timestamp()+86400),(unix_timestamp()+86400),"TRUE");

-- insert a device which is not used anywhere
INSERT INTO mag_msso_device (certdn, magidentifier,username,deviceid,devicename,devicestatus,created,updated,multiuser)
VALUES('certdn03','magidentifier03','username01','deviceid03','devicename03','activated',(unix_timestamp()+86400),(unix_timestamp()+86400),"TRUE");

-- insert a device which is not used anywhere which is using an expried app
INSERT INTO mag_msso_device (certdn, magidentifier,username,deviceid,devicename,devicestatus,created,updated,multiuser)
VALUES('certdn04','magidentifier04','username01','deviceid04','devicename04','activated',(unix_timestamp()+86400),(unix_timestamp()+86400),"TRUE");

INSERT INTO mag_device_app (magidentifier,client_key,access_token)
VALUES('magidentifier01', 'client_key01', 'access_token01');

INSERT INTO mag_device_app (magidentifier,client_key,access_token)
VALUES('magidentifier01', 'client_key02', 'access_token05');

INSERT INTO mag_device_app (magidentifier,client_key,access_token)
VALUES('magidentifier02', 'client_key01', 'access_token02');

INSERT INTO mag_device_app (magidentifier,client_key,access_token)
VALUES('magidentifier06', 'client_key01', 'access_token06');

-- insert an access_token for magidentifier02 which is not valid anymore
INSERT INTO mag_device_app (magidentifier,client_key,access_token)
VALUES('magidentifier02', 'client_key02', 'access_token04');

-- for the device which is not used anywhere which is using an expired app
INSERT INTO mag_device_app (magidentifier,client_key,access_token)
VALUES('magidentifier04', 'client_key01', 'access_token04');

-- This script inserts required data to enable MAG Manager and social login
--
-- MAG Manager:
INSERT INTO oauth_client (client_ident, name, description, organization, registered_by, type, custom)
VALUES ('18661300-45df-4cdc-826f-23e402275463', 'MAG Manager', 'MAG Manager is used to manage registered devices', 'CA Technologies', 'admin', 'confidential', '{}');

-- Credentials for MAG Manager:
INSERT INTO oauth_client_key (client_key, secret, status, created_by, client_ident, client_name, callback, scope, environment, custom)
VALUES ('18661300-45df-4cdc-826f-23e402275463', '171f6a0b-deee-44a9-89fe-8dda80b67cba', 'ENABLED', 'admin', '18661300-45df-4cdc-826f-23e402275463', 'MAG Manager', 'https://mas:8443/mag/manager', 'openid profile email user_role', 'MAGServer', '{}');

-- OAuth Server to support 'local' social login:
INSERT INTO oauth_client (client_ident, name, description, organization, registered_by, type, custom)
VALUES ('c716ac35-ae5b-4870-bfa1-5530c65952f9', 'MAG Authorization Server', 'Used to support social login via the MAG', 'CA Technologies', 'admin', 'confidential', '{}');

-- Credentials for OAuth Server to support 'local' social magidentifier:
INSERT INTO oauth_client_key (client_key, secret, status, created_by, client_ident, client_name, callback, scope, environment, custom)
VALUES ('c716ac35-ae5b-4870-bfa1-5530c65952f9', '269957e2-5bc0-4a59-b0b5-c37e88460159', 'ENABLED', 'admin', 'c716ac35-ae5b-4870-bfa1-5530c65952f9', 'MAG Authorization Server', 'https://mas:8443/auth/oauth/v2/authorize/login?action=login&provider=enterprise', 'openid profile email', 'MAGServer', '{}');

-- Mobile test client installation:
--

DELETE FROM oauth_client WHERE client_ident = '6438edb0-3e74-mag-test-msso-clientAppA';
DELETE FROM oauth_client WHERE client_ident = '6438edb0-3e74-mag-test-msso-clientAppB';
DELETE FROM oauth_client WHERE client_ident = '6438edb0-3e74-mag-test-msso-clientAppC';
DELETE FROM oauth_client_key WHERE client_key = '6438edb0-3e74-48b6-8f08-9034140bd797';
DELETE FROM oauth_client_key WHERE client_key = '3f27bb4f-b5aa-458b-962b-14d352b7977c';
DELETE FROM oauth_client_key WHERE client_key = '68d155e9-1402-48a2-9750-e5d9f0746e17';
DELETE FROM oauth_client_key WHERE client_key = 'e53378b6-a07d-4c22-89da-8088f443fa95';
DELETE FROM oauth_client_key WHERE client_key = '8298bc51-f242-4c6d-b547-d1d8e8519cb4';

-- Testapp AppA:
INSERT INTO oauth_client (client_ident, name, description, organization, registered_by, type, custom)
VALUES ('6438edb0-3e74-mag-test-msso-clientAppA', 'AppA', 'Example application for Mobile SSO demonstrations', 'CA Technologies', 'admin', 'confidential', '{}');
-- Credentials for AppA used with iOS:
INSERT INTO oauth_client_key (client_key, secret, status, created_by, client_ident, client_name, callback, scope, environment, custom)
VALUES ('6438edb0-3e74-48b6-8f08-9034140bd797', '6438edb0-3e74-48b6-8f08-9034140bd797', 'ENABLED', 'admin', '6438edb0-3e74-mag-test-msso-clientAppA', 'AppA', 'https://ios.ssosdk.ca.com/ios', 'openid msso phone profile address email msso_register', 'iOS', '{}');
-- Credentials for AppA used with Android:
INSERT INTO oauth_client_key (client_key, secret, status, created_by, client_ident, client_name, callback, scope, environment, custom)
VALUES ('3f27bb4f-b5aa-458b-962b-14d352b7977c', '3f27bb4f-b5aa-458b-962b-14d352b7977c', 'ENABLED', 'admin', '6438edb0-3e74-mag-test-msso-clientAppA', 'AppA', 'https://android.ssosdk.ca.com/android', 'openid msso phone profile address email msso_register', 'Android', '{}');

-- Testapp AppB:
INSERT INTO oauth_client (client_ident, name, description, organization, registered_by, type, custom)
VALUES ('6438edb0-3e74-mag-test-msso-clientAppB', 'AppB', 'Example application for Mobile SSO demonstrations', 'CA Technologies', 'admin', 'confidential', '{}');

INSERT INTO oauth_client_key (client_key, secret, status, created_by, client_ident, client_name, callback, scope, environment, custom)
VALUES ('7c1f4b13-3813-4d8a-91cf-cba60d668fd4', '7c1f4b13-3813-4d8a-91cf-cba60d668fd4', 'ENABLED', 'admin', '6438edb0-3e74-mag-test-msso-clientAppB', 'AppB', 'https://android.ssosdk.ca.com/android', 'openid msso phone profile address email msso_register', 'Android', '{}');
-- Credentials for AppB used with iOS:
INSERT INTO oauth_client_key (client_key, secret, status, created_by, client_ident, client_name, callback, scope, environment, custom)
VALUES ('68d155e9-1402-48a2-9750-e5d9f0746e17', '68d155e9-1402-48a2-9750-e5d9f0746e17', 'ENABLED', 'admin', '6438edb0-3e74-mag-test-msso-clientAppB', 'AppB', 'https://ios.ssosdk.ca.com/ios', 'openid msso phone profile address email msso_register', 'iOS', '{}');

-- Testapp AppC:
INSERT INTO oauth_client (client_ident, name, description, organization, registered_by, type, custom)
VALUES ('6438edb0-3e74-mag-test-msso-clientAppC', 'AppC', 'PhoneGap example application for Mobile SSO demonstrations', 'CA Technologies', 'admin', 'confidential', '{}');
-- Credentials for AppC used with iOS:
INSERT INTO oauth_client_key (client_key, secret, status, created_by, client_ident, client_name, callback, scope, environment, custom)
VALUES ('e53378b6-a07d-4c22-89da-8088f443fa95', 'e53378b6-a07d-4c22-89da-8088f443fa95', 'ENABLED', 'admin', '6438edb0-3e74-mag-test-msso-clientAppC', 'AppC', 'https://ios.ssosdk.ca.com/ios', 'openid msso phone profile address email msso_register', 'iOS', '{}');
-- Credentials for AppC used with Android:
INSERT INTO oauth_client_key (client_key, secret, status, created_by, client_ident, client_name, callback, scope, environment, custom)
VALUES ('8298bc51-f242-4c6d-b547-d1d8e8519cb4', '8298bc51-f242-4c6d-b547-d1d8e8519cb4', 'ENABLED', 'admin', '6438edb0-3e74-mag-test-msso-clientAppC', 'AppC', 'https://android.ssosdk.ca.com/android', 'openid msso phone profile address email msso_register', 'Android', '{}');

DELETE FROM oauth_token WHERE token = 'access_token01';
DELETE FROM oauth_token WHERE token = 'access_token02';
DELETE FROM oauth_token WHERE token = 'access_token05';
DELETE FROM oauth_token WHERE token = 'access_token06';

INSERT INTO oauth_id_token (resource_owner,azp,sub,jwt,salt,shared_secret,shared_secret_type,iss,expiration)
VALUES('username01','magidentifier01','sub01','jwt01','salt01','shared_secret01','shared_secret_type01','iss01',(unix_timestamp()+86400));

INSERT INTO oauth_id_token (resource_owner,azp,sub,jwt,salt,shared_secret,shared_secret_type,iss,expiration)
VALUES('username01','magidentifier02','sub02','jwt02','salt01','shared_secret02','shared_secret_type02','iss01',(unix_timestamp()+86400));

INSERT INTO oauth_id_token (resource_owner,azp,sub,jwt,salt,shared_secret,shared_secret_type,iss,expiration)
VALUES('username02','magidentifier06','sub06','jwt06','salt06','shared_secret06','shared_secret_type06','iss06',(unix_timestamp()+86400));

INSERT INTO oauth_token (otk_token_id, token, scope, status, client_name, expiration, resource_owner, client_key, client_ident)
VALUES ('access_token01', 'access_token01', 'scope01','ENABLED', 'client_name01',(unix_timestamp()+3600),'testbuddy1','client_key01', 'client_ident01');
INSERT INTO oauth_token (otk_token_id, token, scope, status, client_name, expiration, resource_owner, client_key, client_ident)
VALUES ('access_token02', 'access_token02', 'scope02','ENABLED', 'client_name02',(unix_timestamp()+3600),'testbuddy2','client_key01', 'client_ident02');
INSERT INTO oauth_token (otk_token_id, token, scope, status, client_name, expiration, resource_owner, client_key, client_ident)
VALUES ('access_token05', 'access_token05', 'scope02','ENABLED', 'client_name02',(unix_timestamp()+3600),'testbuddy5','client_key02', 'client_ident02');
INSERT INTO oauth_token (otk_token_id, token, scope, status, client_name, expiration, resource_owner, client_key, client_ident)
VALUES ('access_token06', 'access_token06', 'scope06','ENABLED', 'client_name02',(unix_timestamp()+3600),'testbuddy6','client_key01', 'client_ident02');


