@echo off
REM Exit immediately if a command exits with a non-zero status
setlocal enabledelayedexpansion
set "errorlevel=0"

REM Configuration
set "MAKE_CMD=make"
set "ISO_OUTPUT_PATH=pyos.iso"
set "LOG_FILE=build.log"

REM Logging function
:log
    echo %date% %time% - %~1 | tee -a %LOG_FILE%
    goto :eof

REM Main script execution
call :log "Starting build process..."

REM Clean previous builds
call :log "Cleaning previous builds..."
%MAKE_CMD% clean
if errorlevel 1 (
    call :log "Clean failed."
    exit /b 1
)

REM Build the project
call :log "Building the project..."
%MAKE_CMD%
if errorlevel 1 (
    call :log "Build failed."
    exit /b 1
)

REM Check if the ISO was created successfully
if exist %ISO_OUTPUT_PATH% (
    call :log "Build successful. ISO image created: %ISO_OUTPUT_PATH%"
) else (
    call :log "Build failed. ISO image not created."
    exit /b 1
)

call :log "Build process completed."