@echo off
cd /d "%~dp0"
where mvn >nul 2>nul
if errorlevel 1 (
  echo No se encontro Maven. Instala Apache Maven y agregalo al PATH.
  pause
  exit /b 1
)
echo Compilando Billetera Digital...
mvn clean package
if errorlevel 1 (
  echo La compilacion fallo. Revisa los mensajes anteriores.
  pause
  exit /b 1
)
echo.
echo WAR generado en: target\demo.war
pause
