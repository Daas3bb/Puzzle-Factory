# Flutter SDK 位于 E:/flutter 时，需临时允许 git 访问该目录
$env:GIT_CONFIG_COUNT = 1
$env:GIT_CONFIG_KEY_0 = 'safe.directory'
$env:GIT_CONFIG_VALUE_0 = 'E:/flutter'

Set-Location $PSScriptRoot
flutter run -d chrome --web-port=8080 --web-hostname=127.0.0.1
