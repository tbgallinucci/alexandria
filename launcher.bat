@echo off
SETLOCAL EnableDelayedExpansion
cd /d "%~dp0"

echo ========================================
echo   Engineering Wiki - Local Launcher
echo ========================================

:: 1. Check for Python
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Python not found. Please install Python 3.10+.
    pause
    exit /b
)

:: 2. Create virtual environment if missing
if not exist "venv" (
    echo [INFO] Creating virtual environment...
    python -m venv venv
)

:: 3. Activate and install dependencies
echo [INFO] Activating environment and installing dependencies...
call venv\Scripts\activate
pip install -q -r requirements.txt

:: 4. Open browser and start server
echo [INFO] Starting server on http://localhost:8000
start "" "http://localhost:8000"
python -m uvicorn app.main:app --host 0.0.0.0 --port 8000

pause
