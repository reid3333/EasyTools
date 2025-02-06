@echo off
chcp 65001 > NUL
cd /d %~dp0SdImageDiet
call venv\Scripts\activate.bat
cmd /k
