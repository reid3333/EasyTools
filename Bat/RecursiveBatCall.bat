@echo off
chcp 65001 > NUL
setlocal enabledelayedexpansion
for /r "%~1" %%i in (*.bat) do (
	call "%%i"
	if !ERRORLEVEL! neq 0 ( endlocal & exit /b 1 )
)
endlocal
