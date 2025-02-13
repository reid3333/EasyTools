@echo off
chcp 65001 > NUL

if not exist %~dp0LlamaCpp\LlamaCpp\ (
	echo call %~dp0LlamaCpp\LlamaCpp_Update.bat
	call %~dp0LlamaCpp\LlamaCpp_Update.bat
)
if not exist %~dp0LlamaCpp\LlamaCpp\ (
	echo %~dp0LlamaCpp\LlamaCpp\ not found
	pause & exit /b 1
)

pushd %~dp0LlamaCpp\LlamaCpp\

echo llama-server.exe %*
llama-server.exe %*
if %ERRORLEVEL% neq 0 ( pause & popd & exit /b 1 )

popd rem %~dp0LlamaCpp\LlamaCpp\
