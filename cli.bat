@echo off
set "ezyclasspath=lib\*;external\lib\*;"
java -cp %ezyclasspath% org.youngmonkeys.ezyplatform.cli.CLI %1
