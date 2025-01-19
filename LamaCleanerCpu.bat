@echo off
chcp 65001 > NUL

if not exist %~dp0LamaCleaner\venv\ (
	echo call %~dp0LamaCleaner\LamaCleaner_Update.bat
	call %~dp0LamaCleaner\LamaCleaner_Update.bat
)
if not exist %~dp0LamaCleaner\venv\ (
	echo %~dp0LamaCleaner\venv\ not found
	pause & exit /b 1
)

pushd %~dp0LamaCleaner

call %~dp0Python\Python_Activate.bat
if %ERRORLEVEL% neq 0 ( popd & exit /b 1 )

start http://localhost:7840
echo http://localhost:7840

lama-cleaner --model=lama --port=7840 --device=cpu %*
if %ERRORLEVEL% neq 0 ( pause & popd & exit /b 1 )

popd rem %~dp0\LamaCleaner
