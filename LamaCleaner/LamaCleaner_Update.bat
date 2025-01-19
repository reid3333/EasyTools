@echo off
chcp 65001 > NUL

pushd %~dp0

call ..\Python\Python_Activate.bat
if %ERRORLEVEL% neq 0 ( popd & exit /b 1 )

echo python -m pip install -qq --upgrade pip
python -m pip install -qq --upgrade pip
if %ERRORLEVEL% neq 0 ( pause & popd & exit /b 1 )

echo pip install -qq torch==1.13.1+cu117 torchvision --extra-index-url https://download.pytorch.org/whl/cu117
pip install -qq torch==1.13.1+cu117 torchvision --extra-index-url https://download.pytorch.org/whl/cu117
if %ERRORLEVEL% neq 0 ( pause & popd & exit /b 1 )

echo pip install -qq -r requirements.txt
pip install -qq -r requirements.txt
if %ERRORLEVEL% neq 0 ( pause & popd & exit /b 1 )

popd rem %~dp0
