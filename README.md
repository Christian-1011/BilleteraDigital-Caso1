# Billetera Digital - Caso 1

Aplicación web para registrar recargas y gastos. El saldo inicial es S/ 250.00. La información se guarda en la sesión HTTP; no se utiliza base de datos.

## Requisitos

- JDK 8 o superior.
- Apache Maven 3.8 o superior.
- Apache Tomcat 9.

## Compilar

Abrir una terminal en la carpeta del proyecto y ejecutar:

```bash
mvn clean package
```

Al terminar, el archivo `demo.war` se encontrará en la carpeta `target`.

En Windows también se puede ejecutar `compilar.bat`.

## Ejecutar en Tomcat

1. Copiar `target/demo.war` a la carpeta `webapps` de Tomcat 9.
2. Iniciar Tomcat.
3. Abrir en el navegador:

```text
http://localhost:8080/demo/billetera
```

## Estructura

- `src/main/java`: clases Java.
- `src/main/webapp/WEB-INF/web.xml`: configuración de la aplicación.
- `src/main/webapp/WEB-INF/views`: página JSP.
- `pom.xml`: dependencias y configuración de Maven.

## Pruebas

Al abrir la aplicación, el saldo debe ser S/ 250.00 y el historial debe estar vacío. Se pueden probar una recarga de S/ 100.00, un gasto de S/ 50.00 y un gasto de S/ 400.00 para comprobar la validación de saldo insuficiente.
