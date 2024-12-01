@echo off
chcp 65001 > NUL

@REM HKEY_LOCAL_MACHINE の変更には管理者権限が必要
echo reg add "HKCU\SYSTEM\CurrentControlSet\Control\FileSystem" /v LongPathsEnabled /t REG_DWORD /d 1 /f
reg add "HKCU\SYSTEM\CurrentControlSet\Control\FileSystem" /v LongPathsEnabled /t REG_DWORD /d 1 /f
if %ERRORLEVEL% neq 0 (
	echo "PC の管理者権限で EasyTools/EnableLongPaths.bat を実行してください。"
	pause & exit /b 1
)
