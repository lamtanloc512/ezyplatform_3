#!/bin/sh
#
 # Copyright 2022 youngmonkeys.org
 # 
 # Licensed under the ezyplatform, Version 1.0.0 (the "License");
 # you may not use this file except in compliance with the License.
 # You may obtain a copy of the License at
 # 
 #     https://youngmonkeys.org/licenses/ezyplatform-1.0.0.txt
 # 
 # Unless required by applicable law or agreed to in writing, software
 # distributed under the License is distributed on an "AS IS" BASIS,
 # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 # See the License for the specific language governing permissions and
 # limitations under the License.
#

EZYFOX_SERVER_HOME="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PID_FILE=$EZYFOX_SERVER_HOME/.runtime/ezyfox_server_instance.pid

if [ ! -f "${PID_FILE}" ]; then
    echo "No ezyfox server instance is running."
    exit 0
fi

PID=$(cat "${PID_FILE}");
if [ -z "${PID}" ]; then
    echo "No ezyfox server instance is running."
    exit 0
else
   kill -15 "${PID}"
   rm "${PID_FILE}"
   echo "Ezyfox server with PID ${PID} shutdown."
   exit 0
fi
