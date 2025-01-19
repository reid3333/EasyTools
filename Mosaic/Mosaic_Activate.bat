@echo off
chcp 65001 > NUL
cd /d %~dp0
set MOSAIC=mosaic_20240601
call %MOSAIC%\venv\Scripts\activate.bat
cmd /k
