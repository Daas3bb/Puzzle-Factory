@echo off
set GIT_CONFIG_COUNT=1
set GIT_CONFIG_KEY_0=safe.directory
set GIT_CONFIG_VALUE_0=E:/flutter
cd /d "%~dp0"
flutter run -d chrome --web-port=8080 --web-hostname=127.0.0.1
