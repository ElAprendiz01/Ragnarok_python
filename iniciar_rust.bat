@echo off
setlocal
title Ragnarok - Servidor Nativo Rust
color 0B

echo ============================================================
echo   RAGNAROK - Servidor Nativo en Rust
echo   Panel: http://127.0.0.1:5757
echo   Consumo: 0%% Chromium en background ^| RAM ^< 30 MB
echo ============================================================
echo.

where cargo >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ADVERTENCIA] No se encontro 'cargo' en el PATH.
    echo Buscando binario compilado directo...
    if exist "%~dp0rust_Ragnarok\target\debug\ragnarok.exe" (
        start http://127.0.0.1:5757
        "%~dp0rust_Ragnarok\target\debug\ragnarok.exe"
        goto fin
    ) else (
        echo [ERROR] No se encontro ni 'cargo' ni el ejecutable 'ragnarok.exe'.
        echo Por favor instala Rust desde https://rustup.rs/ o ejecuta desde una terminal con Rust.
        pause
        exit /b 1
    )
)

echo [1/2] Abriendo panel de control en tu navegador (http://127.0.0.1:5757)...
start http://127.0.0.1:5757

echo [2/2] Iniciando servidor con 'cargo run' (compilacion incremental automatica)...
cd /d "%~dp0rust_Ragnarok"
cargo run

:fin
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [AVISO] El servidor se ha detenido con codigo de salida %ERRORLEVEL%.
    pause
)
