@echo off
chcp 65001 > NUL

if not exist %~dp0env\ ( mkdir %~dp0env )
pushd %~dp0env

call %~dp0..\Python\Python_Activate.bat
if %ERRORLEVEL% neq 0 ( popd & exit /b 1 )

echo python -m pip install -qq -U pip setuptools wheel
python -m pip install -qq -U pip setuptools wheel
if %ERRORLEVEL% neq 0 ( pause & popd & exit /b 1 )

echo pip install -qq huggingface_hub
pip install -qq huggingface_hub
if %ERRORLEVEL% neq 0 ( pause & popd & exit /b 1 )

popd rem %~dp0env

echo python %~dp0hugging_face_hub.py %*
python %~dp0hugging_face_hub.py %*
if %ERRORLEVEL% neq 0 ( pause & exit /b 1 )
