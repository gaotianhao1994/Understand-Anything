@echo off
setlocal enabledelayedexpansion

set "GRAPH_DIR=%~1"
if "%GRAPH_DIR%"=="" (
    echo Usage: %0 ^<project-dir^>
    exit /b 1
)

if not exist "%GRAPH_DIR%\.understand-anything\knowledge-graph.json" (
    echo [ERROR] No knowledge graph found. Run /understand first.
    exit /b 1
)

set "DASHBOARD_DIR=%~dp0"

REM Resolve Windows Junction to real path using PowerShell
for /f "delims=" %%I in ('powershell -NoProfile -Command "(Get-Item '%%DASHBOARD_DIR%%').Target"') do set "REAL_DASHBOARD=%%I"

if not "%REAL_DASHBOARD%"=="" (
    if not "%REAL_DASHBOARD%"=="%DASHBOARD_DIR%" (
        echo [INFO] Symlink resolved to: %REAL_DASHBOARD%
    )
    cd /d "%REAL_DASHBOARD%"
) else (
    cd /d "%DASHBOARD_DIR%"
)

echo [INFO] Starting dashboard for: %GRAPH_DIR%
npx vite --host 127.0.0.1
