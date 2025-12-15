@echo off
echo ======================================================
echo          Starting Graduation Project...
echo ======================================================

:: Check if backend folder exists
if not exist "backend" (
    echo Error: Folder 'backend' not found!
    echo Please make sure this script is in the project root.
    pause
    exit
)

:: Check if frontend folder exists
if not exist "frontend" (
    echo Error: Folder 'frontend' not found!
    echo Please make sure this script is in the project root.
    pause
    exit
)

:: 1. Start Backend in a new window
echo [1/3] Starting Spring Boot Backend...
:: We use 'call' to ensure the command runs properly
start "Vite-Backend" cmd /c "cd backend && mvn spring-boot:run"

:: 2. Start Frontend in a new window
echo [2/3] Starting Vue Frontend...
start "Vite-Frontend" cmd /c "cd frontend && npm run dev"

:: 3. Wait 15 seconds for services to initialize, then open browser
echo [3/3] Waiting for services to initialize...
timeout /t 15 >nul
start http://localhost:5174

echo.
echo ======================================================
echo      Done! Please do not close the new windows.
echo ======================================================
pause