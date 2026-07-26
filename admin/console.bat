@echo off
set modulesClasspath=%~1
set modulesClasspath=%modulesClasspath:"=^"%
set ezyclasspath=lib\*;external\lib\*;external\resources;settings;admin\lib\*;admin\settings;admin\resources;%modulesClasspath%
echo classpath = %ezyclasspath%

java -cp %ezyclasspath% org.youngmonkeys.ezyplatform.admin.AdminStartup
