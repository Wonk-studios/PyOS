@echo off
setlocal enabledelayedexpansion

REM Configuration
set CONFIG_FILE=%~dp0config.bat
set BUILD_DIR=%~dp0..\g
set LOG_FILE=%~dp0build.log
set REQUIRED_PKGS=gcc g++ binutils nasm
set MAKE_CMD=make
set ISO_OUTPUT_PATH=%~dp0..\g\PyOS.img

REM Functions
:log
set msg=%1
set timestamp=%date% %time%
echo %timestamp% - %msg% >> %LOG_FILE%
echo %timestamp% - %msg%
goto :eof

:check_requirements
call :log "Checking required packages..."
for %%p in (%REQUIRED_PKGS%) do (
    where %%p >nul 2>nul
    if errorlevel 1 (
        call :log "Package %%p is not installed. Exiting."
        pause
        exit /b 1
    ) else (
        call :log "Package %%p is already installed."
    )
)
goto :eof

:load_config
if exist %CONFIG_FILE% (
    call :log "Loading configuration from %CONFIG_FILE%"
    call %CONFIG_FILE%
) else (
    call :log "Configuration file %CONFIG_FILE% not found!"
    pause
    exit /b 1
)
goto :eof

:build_project
call :log "Starting build process..."
if exist %BUILD_DIR% (
    cd /d %BUILD_DIR%
    %MAKE_CMD% >> %LOG_FILE% 2>&1
    if errorlevel 1 (
        call :log "Build failed!"
        pause
        exit /b 1
    )
    call :log "Build succeeded."
) else (
    call :log "Build directory %BUILD_DIR% not found!"
    pause
    exit /b 1
)
goto :eof

:create_iso
call :log "Creating ISO image..."
if exist %ISO_OUTPUT_PATH% (
    del %ISO_OUTPUT_PATH%
)
genisoimage -o %ISO_OUTPUT_PATH% -b boot/bootloader.bin -no-emul-boot -boot-load-size 4 -boot-info-table %BUILD_DIR% >> %LOG_FILE% 2>&1
if errorlevel 1 (
    call :log "ISO creation failed!"
    pause
    exit /b 1
)
call :log "ISO image created at %ISO_OUTPUT_PATH%."
goto :eof

REM Main script
call :log "Build script started."
call :load_config
call :check_requirements
call :build_project
call :create_iso
call :log "Build script completed."
pause