-- CA Technologies
-- Database schema for MAG 3.3.00
-- 2016/11
--
-- This script extends the OAuth Toolkit database. These tables have to be accessible via the /tokenstore endpoint just as the 
-- oauth tables "oauth_token" and "oauth_initiate".
-- This script is compliant with okt_database version otk3.5.00
--
-- run this command on a ssg command line: mysql -u root 'your_otk_database' < 'this_script'
--
-- drop table if exists mag_version;
-- drop table if exists mag_device_app;
-- drop table if exists mag_msso_device;
--
-- Modifications:
-- MAG 2.0: initial database
-- MAG 2.0   -> 2.0.1: see mag_db_schema_update_2.0-2.0.1.sql
-- MAG 2.0.1 -> 2.1: see mag_db_schema_update_2.0.1-2.1.sql
-- MAG 2.1 -> 2.2: table 'mag_id_token' has been moved to 'otk.sql'. It is now part of OTK, added mag_smc tables
-- MAG 2.2 -> 2.3: moved knox/smc tables to mag_db_schema_knox.sql; adding columns to mag_msso_device
-- MAG 2.4 -> 2.4: update the version to 2.4
-- MAG 2.4 -> 3.0.01: add indexes on mag_device_app
-- MAG 3.0.01 -> 3.1.00: update the version to 3.1.00
-- MAG 3.1.00 -> 3.2.00: update the version to 3.2.00
-- MAG 3.2.00 -> 3.3.00: update the version to 3.3.00
-- MAG 3.3.00 -> 3.4.00: update the version to 3.4.00, add new columns to support certificate renewal
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
INSERT INTO mag_version (current_version) VALUES ('mag3.3.00');
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
