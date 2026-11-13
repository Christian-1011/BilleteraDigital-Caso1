# Billetera Digital – T1 Caso 1 (Servlet + JSP)

Proyecto académico desarrollado en Java puro, sin frameworks, para el **Caso 1: Billetera Digital: Recarga y Movimientos**.

## Alcance implementado

- Saldo inicial de **S/ 250.00**.
- Historial inicialmente vacío.
- Operaciones de Recarga y Gasto.
- Validación de montos vacíos, no numéricos, cero, negativos y con más de dos decimales.
- Validación de saldo suficiente antes de aceptar un gasto.
- Los movimientos inválidos no cambian el saldo ni el historial.
- Saldo e historial almacenados en `HttpSession`; no usa base de datos.
- Servlet controlador con `doGet()` y `doPost()`.
- JSP como vista, utilizando JSTL (`c:forEach`, `c:if`, `c:choose`) y sin scriptlets.
- Bootstrap 5 para la presentación.
- Post-Redirect-Get después de un registro válido para evitar duplicados al actualizar.

## Tecnologías y versiones

- Java JDK 8 o superior (recomendado: JDK 17).
- Apache Tomcat 9.0.x (usa `javax.servlet`; no usar Tomcat 10/11 sin migrar paquetes).
- Maven 3.8 o superior.
- Servlet API 4.0.1 (scope `provided`, suministrada por Tomcat).
- JSTL 1.2.
- Bootstrap 5.3.3 mediante CDN (se requiere Internet en el navegador para cargar sus estilos).

## Estructura

```text
BilleteraDigital-Caso1/
├── pom.xml
├── README.md
└── src/main/
    ├── java/pe/edu/billetera/
    │   ├── controller/BilleteraServlet.java
    │   └── model/Movimiento.java
    └── webapp/
        ├── WEB-INF/web.xml
        └── WEB-INF/views/billetera.jsp
```

## Cómo ejecutar (Windows)

1. Instala un JDK (recomendado JDK 17) y Apache Maven.
2. Instala Apache Tomcat **9**. No uses Tomcat 10/11 con esta versión del proyecto porque cambian los paquetes `javax.*` por `jakarta.*`.
3. Abre CMD o PowerShell en la carpeta del proyecto.
4. Ejecuta:

   ```bash
   mvn clean package
   ```

5. Maven generará `target/billetera-digital.war`.
6. Copia ese WAR a la carpeta `webapps` de Tomcat 9.
7. Inicia Tomcat ejecutando `bin\startup.bat`.
8. Abre en el navegador:

   `http://localhost:8080/billetera-digital/billetera`

También puedes importar la carpeta como **Existing Maven Project** en Apache NetBeans o Eclipse y ejecutar/desplegar en Tomcat 9.

## Pruebas manuales requeridas

Cada sesión nueva comienza con saldo S/ 250.00 e historial vacío.

| Prueba | Acción | Resultado esperado |
|---|---|---|
| Inicial | Abrir la aplicación | S/ 250.00 e historial vacío |
| Recarga | Recargar S/ 100.00 | Saldo S/ 350.00; recarga al inicio del historial |
| Gasto | Gastar S/ 50.00 | Saldo S/ 300.00; gasto al inicio del historial |
| Saldo insuficiente | Gastar S/ 400.00 con saldo S/ 300.00 | Rechazo; saldo e historial sin cambios |
| Cero | Registrar S/ 0.00 | Rechazo; sin cambios |
| Negativo | Enviar S/ -20.00 | Rechazo; sin cambios |
| Vacío/no numérico | Enviar campo vacío o texto | Rechazo; sin cambios |
| Precisión | Enviar S/ 1.234 | Rechazo; máximo dos decimales |

## Notas importantes

- Los datos se conservan mientras exista la sesión HTTP. Al cerrar/expirar la sesión, se reinician a S/ 250.00 y lista vacía, tal como solicita el enunciado.
- No hay login, base de datos, APIs externas ni frameworks.
- El archivo WAR se genera localmente con Maven; el código fuente se entrega en este ZIP. Para compilar se necesita que Maven pueda descargar las dependencias declaradas en `pom.xml`.

En Windows también puedes ejecutar `compilar.bat` desde la carpeta raíz del proyecto; este script ejecuta `mvn clean package` y deja el WAR en `target/`.
