@echo off
echo ======================================================
echo    Transit Information System - Server Starter
echo ======================================================
echo.
echo This script starts a development server to serve the
echo Transit Information System web application.
echo.

echo Choose a server option:
echo 1. PHP Server (if PHP is installed)
echo 2. Python Server (if Python is installed)
echo 3. Node.js Server (if Node.js is installed)
echo.
set /p server_choice="Enter your choice (1-3): "

if "%server_choice%"=="1" (
    call :start_php_server
) else if "%server_choice%"=="2" (
    call :start_python_server
) else if "%server_choice%"=="3" (
    call :start_node_server
) else (
    echo Invalid choice. Trying PHP server by default...
    call :start_php_server
)

exit /b 0

:start_php_server
echo.
echo Checking if PHP is installed...
php --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: PHP is not installed or not in your PATH.
    echo.
    echo Please install PHP from https://windows.php.net/download/
    echo and make sure it's added to your PATH environment variable.
    echo.
    echo Trying alternative server options...
    call :try_alternatives
    exit /b 1
)

echo.
echo PHP is installed. Starting PHP server...
echo Server will be available at: http://localhost:8000
echo.
echo Press Ctrl+C to stop the server when you're done.
echo ======================================================
echo.
php -S localhost:8000
exit /b 0

:start_python_server
echo.
echo Checking if Python is installed...
python --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Checking for Python 3...
    py --version >nul 2>&1
    if %ERRORLEVEL% NEQ 0 (
        echo ERROR: Python is not installed or not in your PATH.
        echo.
        echo Please install Python from https://www.python.org/downloads/
        echo and make sure it's added to your PATH environment variable.
        echo.
        echo Trying alternative server options...
        call :try_alternatives
        exit /b 1
    ) else (
        echo Python 3 found. Starting Python server...
        echo Server will be available at: http://localhost:8000
        echo.
        echo Press Ctrl+C to stop the server when you're done.
        echo ======================================================
        echo.
        py -m http.server 8000
        exit /b 0
    )
) else (
    echo Python found. Checking version...
    python -c "import sys; print(sys.version_info.major)" > temp.txt
    set /p PYTHON_VERSION=<temp.txt
    del temp.txt
    
    if "%PYTHON_VERSION%"=="3" (
        echo Python 3 found. Starting Python server...
        echo Server will be available at: http://localhost:8000
        echo.
        echo Press Ctrl+C to stop the server when you're done.
        echo ======================================================
        echo.
        python -m http.server 8000
    ) else (
        echo Python 2 found. Trying Python 3...
        py --version >nul 2>&1
        if %ERRORLEVEL% NEQ 0 (
            echo ERROR: Python 3 is not available.
            echo.
            echo Trying alternative server options...
            call :try_alternatives
            exit /b 1
        ) else (
            echo Python 3 found. Starting Python server...
            echo Server will be available at: http://localhost:8000
            echo.
            echo Press Ctrl+C to stop the server when you're done.
            echo ======================================================
            echo.
            py -m http.server 8000
            exit /b 0
        )
    )
)
exit /b 0

:start_node_server
echo.
echo Checking if Node.js is installed...
node --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Node.js is not installed or not in your PATH.
    echo.
    echo Please install Node.js from https://nodejs.org/
    echo and make sure it's added to your PATH environment variable.
    echo.
    echo Trying alternative server options...
    call :try_alternatives
    exit /b 1
)

echo Creating a temporary server file...
echo const http = require('http'); > server.js
echo const fs = require('fs'); >> server.js
echo const path = require('path'); >> server.js
echo. >> server.js
echo const server = http.createServer((req, res) => { >> server.js
echo   const filePath = req.url === '/' ? 'index.html' : req.url.substring(1); >> server.js
echo   const extname = path.extname(filePath); >> server.js
echo. >> server.js
echo   const contentTypeMap = { >> server.js
echo     '.html': 'text/html', >> server.js
echo     '.js': 'text/javascript', >> server.js
echo     '.css': 'text/css', >> server.js
echo     '.json': 'application/json', >> server.js
echo     '.png': 'image/png', >> server.js
echo     '.jpg': 'image/jpg', >> server.js
echo     '.txt': 'text/plain' >> server.js
echo   }; >> server.js
echo. >> server.js
echo   const contentType = contentTypeMap[extname] || 'text/plain'; >> server.js
echo. >> server.js
echo   fs.readFile(filePath, (error, content) => { >> server.js
echo     if (error) { >> server.js
echo       if (error.code === 'ENOENT') { >> server.js
echo         res.writeHead(404); >> server.js
echo         res.end('File not found'); >> server.js
echo       } else { >> server.js
echo         res.writeHead(500); >> server.js
echo         res.end('Internal server error: ' + error.code); >> server.js
echo       } >> server.js
echo     } else { >> server.js
echo       res.writeHead(200, { 'Content-Type': contentType }); >> server.js
echo       res.end(content, 'utf-8'); >> server.js
echo     } >> server.js
echo   }); >> server.js
echo }); >> server.js
echo. >> server.js
echo server.listen(8000, () => { >> server.js
echo   console.log('Server running at http://localhost:8000/'); >> server.js
echo }); >> server.js

echo Node.js found. Starting Node.js server...
echo Server will be available at: http://localhost:8000
echo.
echo Press Ctrl+C to stop the server when you're done.
echo ======================================================
echo.
node server.js
del server.js
exit /b 0

:try_alternatives
echo.
echo Trying Python server...
call :start_python_server

echo.
echo Trying Node.js server...
call :start_node_server

echo.
echo ERROR: No suitable server found.
echo.
echo Please install one of the following:
echo - PHP: https://windows.php.net/download/
echo - Python: https://www.python.org/downloads/
echo - Node.js: https://nodejs.org/
echo.
echo Press any key to exit...
pause > nul
exit /b 1
