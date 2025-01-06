@echo off
chcp 65001 > NUL
setlocal enabledelayedexpansion
for /r "%~1" %%i in (*.bat) do (
	call "%%i"
)
endlocal
