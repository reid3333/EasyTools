@echo off
chcp 65001 > NUL

if not exist %~dp0SdImageDiet\SdImageDiet\venv\ (
	echo call %~dp0SdImageDiet\SdImageDiet_Update.bat
	call %~dp0SdImageDiet\SdImageDiet_Update.bat
)
if not exist %~dp0SdImageDiet\SdImageDiet\venv\ (
	echo %~dp0SdImageDiet\SdImageDiet\venv\ not found
	pause & exit /b 1
)

pushd %~dp0SdImageDiet\SdImageDiet

call %~dp0Python\Python_Activate.bat
if %ERRORLEVEL% neq 0 ( popd & exit /b 1 )

start pythonw SdImageDietGUI.py %*
if %ERRORLEVEL% neq 0 ( pause & popd & exit /b 1 )

popd rem %~dp0\SdImageDiet\SdImageDiet
