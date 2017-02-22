-- CA Technologies
-- Database test data for MAG 3.2.00
-- 2016/05
--
-- This script inserts test data. It is not necessary but recommended to install this script in non-production environments.
-- It is provided for testing purposes only.
--
-- run this command on a ssg command line: mysql -u root 'your_otk_database' < 'this_script'
-- rm: 'your_otk_database' needs to include the tables of the script 'mag_db_schema.sql'
--
-- Demo Mobile test client installation:
--

DELETE FROM oauth_client WHERE client_ident = '6438edb0-3e74-mag-test-msso-demoApp';
DELETE FROM oauth_client_key WHERE client_key = 'ae4e29c2-1a95-4956-84b4-c8a8b88c9834';
DELETE FROM oauth_client_key WHERE client_key = 'b680e59b-729a-41c4-a4f6-3f6980650d09';

-- Testapp DemoApp:
INSERT INTO oauth_client (client_ident, name, description, organization, registered_by, type, custom)
VALUES ('6438edb0-3e74-mag-test-msso-demoApp', 'DemoApp', 'Example application for Mobile demonstrations', 'CA Technologies', 'admin', 'confidential', '{}');
-- Credentials for AppA used with iOS:
INSERT INTO oauth_client_key (client_key, secret, status, created_by, client_ident, client_name, callback, scope, environment, custom)
VALUES ('ae4e29c2-1a95-4956-84b4-c8a8b88c9834', 'ae4e29c2-1a95-4956-84b4-c8a8b88c9834', 'ENABLED', 'admin', '6438edb0-3e74-mag-test-msso-demoApp', 'DemoApp', 'https://ios.ssosdk.ca.com/ios', 'openid msso phone profile address email msso_register msso_client_register mas_messaging mas_storage mas_identity', 'iOS', '{}');
-- Credentials for DemoApp used with Android:
INSERT INTO oauth_client_key (client_key, secret, status, created_by, client_ident, client_name, callback, scope, environment, custom)
VALUES ('b680e59b-729a-41c4-a4f6-3f6980650d09', 'b680e59b-729a-41c4-a4f6-3f6980650d09', 'ENABLED', 'admin', '6438edb0-3e74-mag-test-msso-demoApp', 'DemoApp', 'https://android.ssosdk.ca.com/android', 'openid msso phone profile address email msso_register msso_client_register mas_messaging mas_storage mas_identity', 'Android', '{}');
