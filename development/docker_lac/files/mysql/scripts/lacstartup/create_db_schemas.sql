#
#  Copyright (c) 2016 CA. All rights reserved.
#
#  This software may be modified and distributed under the terms
#  of the MIT license. See the LICENSE file for details.
#
# This creates the user in mysql and grant it permissions
CREATE DATABASE IF NOT EXISTS lacadmindb;
GRANT ALL PRIVILEGES ON *.* TO 'db_admin'@'%' identified by '7layer';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' identified by '7layer';
FLUSH PRIVILEGES;
