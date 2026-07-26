@echo off
set modulesClasspath=%~1
set modulesClasspath=%modulesClasspath:"=^"%
set ezyclasspath=lib\*;external\lib\*;external\resources;settings;web\lib\*;web\settings;web\public;web\resources;%modulesClasspath%
echo classpath = %ezyclasspath%

java -cp %ezyclasspath% org.youngmonkeys.ezyplatform.web.WebStartup
