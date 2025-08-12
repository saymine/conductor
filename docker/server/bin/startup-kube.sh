#!/bin/sh
#
#  Copyright 2023 Conductor authors
#  <p>
#  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with
#  the License. You may obtain a copy of the License at
#  <p>
#  http://www.apache.org/licenses/LICENSE-2.0
#  <p>
#  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on
#  an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the
#  specific language governing permissions and limitations under the License.
#

# startup.sh - startup script for the server docker image

echo "Starting Conductor server"

echo "Running Nginx in background"

htpasswd -c -b /etc/nginx/.htpasswd $BASIC_USERNAME $BASIC_PASSWORD

envsubst '${API_KEY}' < /app/nginx/nginx.template > /etc/nginx/http.d/default.conf

# Start nginx as daemon
nginx

# Start the server
cd /app/libs

export config_file=/app/config/config.properties
cat $config_file 

echo "Using default configuration file: $config_file";

#Append env vars to config file

echo "" >> $config_file
echo "" >> $config_file

NV | grep '^CPROP_' | cut -c 7- | sed 's/\_/./g' >> $config_file

echo "Using java options config: $JAVA_OPTS"

java ${JAVA_OPTS} -jar -DCONDUCTOR_CONFIG_FILE=$config_file conductor-server.jar
