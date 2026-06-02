@echo off
setlocal enabledelayedexpansion

echo ================================
echo   C++ Dev Environment Setup
echo ================================

:: -------------------------------
:: ASK INSTALL LOCATION
:: -------------------------------
set /p INSTALL_DIR=Enter install directory (e.g. D:\dev): 

if "%INSTALL_DIR%"=="" (
    echo Invalid directory.
    pause
    exit /b
)

mkdir "%INSTALL_DIR%" >nul 2>&1

echo.
echo Using install folder: %INSTALL_DIR%
echo.

:: -------------------------------
:: CHECK GIT
:: -------------------------------
git --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Git is required but not installed. Install it from the official website.
    pause
    exit /b
)

:: -------------------------------
:: INSTALL CMAKE (SYSTEM-WIDE)
:: -------------------------------
cmake --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: CMake is not installed.. Install it from the official website.
) else (
    echo CMake is installed.
)

:: -------------------------------
:: INSTALL NINJA (PORTABLE)
:: -------------------------------
ninja --version >nul 2>&1

set NINJA_DIR=%INSTALL_DIR%\ninja
if errorlevel 1 (
	mkdir "%NINJA_DIR%" >nul 2>&1
    echo Downloading Ninja...

    powershell -Command ^
    "Invoke-WebRequest -Uri https://github.com/ninja-build/ninja/releases/latest/download/ninja-win.zip -OutFile ninja.zip"

    powershell -Command ^
    "Expand-Archive ninja.zip -DestinationPath '%NINJA_DIR%' -Force"

    del ninja.zip

    echo Ninja installed at %NINJA_DIR%
) else (
    echo Ninja already installed globally
)

:: -------------------------------
:: INSTALL VCPKG (CUSTOM LOCATION)
:: -------------------------------
set VCPKG_DIR=%INSTALL_DIR%\vcpkg

if exist "%VCPKG_DIR%" (
    echo vcpkg already exists at %VCPKG_DIR%
) else (
    echo Cloning vcpkg...

    git clone https://github.com/microsoft/vcpkg "%VCPKG_DIR%"

    echo Bootstrapping vcpkg...
    call "%VCPKG_DIR%\bootstrap-vcpkg.bat"
)

:: -------------------------------
:: SET ENV VARIABLES
:: -------------------------------
echo.
echo Setting environment variables safely...

:: -------------------------------
:: VCPKG_ROOT (only if not already set correctly)
:: -------------------------------
for /f "tokens=2*" %%A in ('reg query HKCU\Environment /v VCPKG_ROOT 2^>nul') do set CURRENT_VCPKG=%%B

if not "%CURRENT_VCPKG%"=="%VCPKG_DIR%" (
    echo Setting VCPKG_ROOT...
    setx VCPKG_ROOT "%VCPKG_DIR%" >nul
) else (
    echo VCPKG_ROOT already set correctly.
)

:: -------------------------------
:: PATH (add ninja only if missing)
:: -------------------------------
for /f "tokens=2*" %%A in ('reg query HKCU\Environment /v PATH 2^>nul') do set CURRENT_PATH=%%B

echo %CURRENT_PATH% | find /I "%NINJA_DIR%" >nul
if errorlevel 1 (
    echo Adding Ninja to PATH...
    setx PATH "%INSTALL_DIR%\ninja;%PATH%" >nul
) else (
    echo Ninja already in PATH.
)

powershell.exe -ExecutionPolicy Bypass -File "%~dp0src\install-create-cpp-project-reg.ps1"

echo.
echo ================================
echo Setup complete!
echo ================================
echo Install location: %INSTALL_DIR%
echo vcpkg: %VCPKG_DIR%
echo ninja: %NINJA_DIR%
echo.
echo IMPORTANT:
echo - Restart terminal to apply PATH changes
echo - Verify: vcpkg, ninja
echo.

pause