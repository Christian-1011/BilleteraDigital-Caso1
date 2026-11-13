@echo off
chcp 65001 >nul
setlocal
where mvn >nul 2>nul
if errorlevel 1 (
  echo ERROR: No se encontro Maven. Instala Apache Maven y agregalo al PATH.
  pause
  exit /b 1
)
echo Compilando Billetera Digital - Caso 1...
mvn clean package
if errorlevel 1 (
  echo.
  echo La compilacion fallo. Revisa los mensajes anteriores.
  pause
  exit /b 1
)
echo.
echo Correcto. WAR generado en: target\billetera-digital.war
pause
