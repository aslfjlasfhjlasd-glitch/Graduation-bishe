@echo off
echo ======================================================
echo          正在启动毕业设计项目 (后端+前端)...
echo ======================================================

:: 1. 启动后端 (在新窗口中运行)
echo [1/3] 正在启动 Spring Boot 后端...
start "Vite-Backend" cmd /c "cd backend && mvn spring-boot:run"

:: 2. 启动前端 (在新窗口中运行)
echo [2/3] 正在启动 Vue 前端...
start "Vite-Frontend" cmd /c "cd frontend && npm run dev"

:: 3. 等待一会儿让服务启动，然后打开浏览器
echo [3/3] 等待服务初始化，即将自动打开浏览器...
timeout /t 15 >nul
start http://localhost:5173

echo.
echo ======================================================
echo      启动命令已发送！请勿关闭弹出的两个黑色窗口
echo ======================================================
pause