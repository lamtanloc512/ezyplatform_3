@echo off
set modulesClasspath=%~1
set modulesClasspath=%modulesClasspath:"=^"%
set ezyclasspath=lib\*;external\lib\*;external\resources;settings;socket\lib\*;socket\settings;%modulesClasspath%
echo classpath = %ezyclasspath%

java -cp %ezyclasspath% org.youngmonkeys.ezyplatform.socket.SocketStartup socket\settings\socket.properties
