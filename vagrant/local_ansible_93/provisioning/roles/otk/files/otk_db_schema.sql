-- CA Technologies
-- Database schema for OTK 3.1.1
-- Database schema otk3.1.1
-- 2015/01/30
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
  constraint uk_oc_name_org unique (name, organization),
  constraint uk_oc_name unique (name)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;
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
  constraint ock_fk_clientIdent foreign key (client_ident) references oauth_client (client_ident) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;
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
  client_name varchar(128) not null COMMENT 'The name of the client that owns this key. Not normalized for performance.'
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;
-- Adding an index to oauth_token. This will improve the overall performance
CREATE INDEX oat_idx_expiration ON oauth_token (expiration);
CREATE INDEX oat_idx_rowner_client ON oauth_token(resource_owner,client_key);
--
-- This table holds temporary tokens
-- oauth 1.0 = request_token
-- oauth 2.0 = authorization_code
--
CREATE TABLE oauth_initiate (
  token varchar(128) primary key COMMENT 'for oauth 1.0, 2.0',
  secret varchar(128) null COMMENT 'null for oauth 2.0, it does not provide a secret',
  expiration bigint not null DEFAULT 0 COMMENT 'for oauth 1.0, 2.0, DEFAULT 0 because otherwise timestamp will be set to now() on an update',
  scope varchar(4096) null COMMENT 'for oauth 2.0, the scope granted by the resource owner',
  resource_owner varchar(128) null COMMENT 'the authenticated user that granted the token',
  created bigint DEFAULT 0 COMMENT 'the date this token (or these tokens in oauth 2.0) were created',
  verifier varchar(128) null COMMENT 'for oauth 1.0',
  callback varchar(256) null COMMENT 'for oauth 1.0, 2.0',
  client_key varchar(128) not null COMMENT 'the client that received this token',
  client_name varchar(128) not null COMMENT 'The name of the client that owns this key. Not normalized for performance.'
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
INSERT INTO otk_version (current_version) VALUES ('otk3.1.1');
--
-- This table will contain all id_token
--
CREATE TABLE oauth_id_token (
  resource_owner varchar(128) not null,
  azp varchar(128) not null,
  sub varchar(128) null,
  jwt_id varchar(128) null,
  jwt mediumtext not null,
  salt varchar(128) null,
  shared_secret varchar(128) null,
  shared_secret_type varchar(128) null,
  iss varchar(128) not null,
  expiration bigint not null COMMENT 'expiration date in seconds',
  constraint pk_mag_id_token primary key (resource_owner, azp)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;
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
insert into oauth_client (client_ident, name, description, organization, registered_by, type)
values ('123456800-otk', 'OpenID Connect Basic Client Profile', 'Test for OpenID Connect BCP', 'Layer7 Technologies Inc.', 'admin', 'confidential');
insert into oauth_client_key (client_key, secret, status, created_by, client_ident, client_name, callback, scope)
values ('5eed868e-7ad0-4172-88f2-704bcf78b61e', '2054e4d7-77f2-46c9-bc4d-11a47255a6ec', 'ENABLED', 'admin', '123456800-otk', 'OpenID Connect Basic Client Profile', 'YOUR_SSG/oauth/v2/client/bcp?auth=done', 'openid email profile phone address');
--
-- OpenID Connect Client for the Implicit Client Profile specification
--
insert into oauth_client (client_ident, name, description, organization, registered_by, type)
values ('123456801-otk', 'OpenID Connect Implicit Client Profile', 'Test for OpenID Connect ICP', 'Layer7 Technologies Inc.', 'admin', 'public');
insert into oauth_client_key (client_key, secret, status, created_by, client_ident, client_name, callback, scope)
values ('5edc4a38-75ec-4617-8854-1a71ff1e0a2e', '5005a669-0295-4602-be7d-6a75342db6d8', 'ENABLED', 'admin', '123456801-otk', 'OpenID Connect Implicit Client Profile', 'YOUR_SSG/oauth/v2/client/icp?auth=done', 'openid email profile phone address');
--
-- Create an OAuth 1.0 and OAuth 2.0 client
--
INSERT INTO oauth_client (client_ident, name, description, organization, registered_by)
VALUES ('TestClient1.0', 'OAuth1Client', 'OAuth 1.0 test client hosted on the ssg', 'Layer7 Technologies Inc.', 'admin');

INSERT INTO oauth_client (client_ident, name, description, organization, registered_by, type)
VALUES ('TestClient2.0', 'OAuth2Client', 'OAuth 2.0 test client hosted on the ssg', 'Layer7 Technologies Inc.', 'admin', 'confidential');

INSERT INTO oauth_client_key (client_key, secret, status, created_by, client_ident, client_name, scope)
VALUES ('acf89db2-994e-427b-ac2c-88e6101f9433', '74d5e0db-cd8b-4d8e-a989-95a0746c3343', 'ENABLED', 'admin', 'TestClient1.0', 'OAuth1Client', 'scope_test');

INSERT INTO oauth_client_key (client_key, secret, status, created_by, client_ident, client_name, callback)
VALUES ('54f0c455-4d80-421f-82ca-9194df24859d', 'a0f2742f-31c7-436f-9802-b7015b8fd8e6', 'ENABLED', 'admin', 'TestClient2.0', 'OAuth2Client', 'YOUR_SSG/oauth/v2/client/authcode,YOUR_SSG/oauth/v2/client/implicit');

INSERT INTO oauth_client (client_ident, name, description,organization,registered_by,type,custom)VALUES ('0daffd5c-d8b8-46f3-b38f-3f617624e591', 'Developer Console Access', 'Client used by the Developer Console','CA Technologies','admin','public','{}');

INSERT INTO oauth_client_key (client_key, secret, status, created_by, client_ident, client_name, scope, callback, custom)VALUES ('0daffd5c-d8b8-46f3-b38f-3f617624e591', 'e62afc98-7b87-11e6-9288-0fe490372cd1' , 'ENABLED' , 'admin' , '0daffd5c-d8b8-46f3-b38f-3f617624e591', 'Developer Console Access' , 'openid profile email name address devconsole' , '<https://localhost:8443>' , '{}');

COMMIT;
