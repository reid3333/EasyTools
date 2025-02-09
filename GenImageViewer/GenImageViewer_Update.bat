@echo off
chcp 65001 > NUL
set GITHUB_CLONE_OR_PULL_HASH=%~dp0..\Git\GitHub_CloneOrPull_Hash.bat

pushd %~dp0

@REM https://github.com/Zuntan03/GenImageViewer
call %GITHUB_CLONE_OR_PULL_HASH% Zuntan03 GenImageViewer main
if %ERRORLEVEL% neq 0 ( popd & exit /b 1 )

popd rem %~dp0
