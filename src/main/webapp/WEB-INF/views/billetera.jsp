<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.math.BigDecimal,java.text.DecimalFormat,java.util.List,pe.edu.billetera.model.Movimiento" %>
<%!
    private String escapar(String valor) {
        if (valor == null) return "";
        return valor.replace("&", "&amp;").replace("<", "&lt;")
                    .replace(">", "&gt;").replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }
    private String dinero(BigDecimal valor) {
        if (valor == null) return "0.00";
        return new DecimalFormat("#,##0.00").format(valor);
    }
%>
<%
    BigDecimal saldo = (BigDecimal) request.getAttribute("saldo");
    List<Movimiento> movimientos = (List<Movimiento>) request.getAttribute("movimientos");
    String mensajeError = (String) request.getAttribute("mensajeError");
    String tipoSeleccionado = (String) request.getAttribute("tipoSeleccionado");
    String montoIngresado = (String) request.getAttribute("montoIngresado");
    if (tipoSeleccionado == null) tipoSeleccionado = "Recarga";
    if (montoIngresado == null) montoIngresado = "";
    if (movimientos == null) movimientos = java.util.Collections.emptyList();
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Mi Billetera Digital</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background: #f2f6fb; color: #1b2b42; }
        .topbar { background: #17263b; }
        .panel { border: 1px solid #dce5ef; border-radius: 14px; box-shadow: 0 4px 14px rgba(20,40,70,.04); }
        .saldo { color: #12845b; font-size: clamp(2rem, 4vw, 2.7rem); font-weight: 750; letter-spacing: -.04em; }
        .tag { display: inline-block; min-width: 94px; text-align: center; border-radius: 7px; padding: 5px 12px; color: white; font-size: .82rem; font-weight: 600; }
        .tag-recarga { background: #13865e; } .tag-gasto { background: #c63750; }
        .monto-recarga { color: #13865e; font-weight: 700; } .monto-gasto { color: #c63750; font-weight: 700; }
        .btn-primary { background: #2463d8; border-color: #2463d8; }
        .muted { color: #718096; }
    </style>
</head>
<body>
<nav class="navbar navbar-dark topbar"><div class="container py-2">
    <span class="navbar-brand fw-semibold mb-0">Mi Billetera Digital</span>
    <span class="badge rounded-pill text-bg-secondary px-3 py-2">Java · JSP + Servlet</span>
</div></nav>
<main class="container py-4 py-lg-5">
    <div class="row g-4 mb-4">
        <div class="col-lg-5"><section class="panel bg-white p-4 h-100">
            <div class="small text-uppercase fw-semibold muted mb-2">Saldo disponible</div>
            <div class="saldo">S/ <%= dinero(saldo) %></div>
            <div class="small muted mt-2"><%= movimientos.isEmpty() ? "Saldo inicial de la billetera" : "Después de " + movimientos.size() + " movimiento(s) válido(s)" %></div>
        </section></div>
        <div class="col-lg-7"><section class="panel p-4 h-100" style="background:#eaf2ff;border-color:#cbdcff">
            <span class="badge text-bg-primary mb-3">GET / Servlet</span>
            <h2 class="h5 fw-bold">Información de tu billetera</h2>
            <p class="mb-1">El Servlet obtiene el saldo y el historial almacenados en tu sesión HTTP.</p>
            <p class="small muted mb-0">La página JSP presenta la información de la billetera.</p>
        </section></div>
    </div>
    <% if ("1".equals(request.getParameter("ok"))) { %>
        <div class="alert alert-success" role="alert">Movimiento registrado correctamente.</div>
    <% } %>
    <% if (mensajeError != null && !mensajeError.trim().isEmpty()) { %>
        <div class="alert alert-danger" role="alert"><strong>No se pudo registrar:</strong> <%= escapar(mensajeError) %></div>
    <% } %>
    <div class="row g-4">
        <div class="col-lg-8"><section class="panel bg-white p-3 p-md-4">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h2 class="h5 fw-bold mb-0">Movimientos recientes</h2>
                <span class="badge text-bg-light border text-secondary"><%= movimientos.size() %> registro(s)</span>
            </div>
            <% if (movimientos.isEmpty()) { %>
                <div class="text-center py-5"><div class="fs-1 mb-2">▤</div>
                    <h3 class="h6 fw-semibold">Aún no hay movimientos</h3>
                    <p class="muted small mb-0">Cuando registres una recarga o un gasto aparecerá aquí.</p>
                </div>
            <% } else { %>
                <div class="table-responsive"><table class="table align-middle mb-0">
                    <thead class="table-light"><tr><th>Tipo</th><th>Monto (S/)</th><th>Fecha</th></tr></thead><tbody>
                    <% for (Movimiento mov : movimientos) { boolean recarga = mov.isRecarga(); %>
                        <tr>
                            <td><span class="tag <%= recarga ? "tag-recarga" : "tag-gasto" %>"><%= escapar(mov.getTipo()) %></span></td>
                            <td class="<%= recarga ? "monto-recarga" : "monto-gasto" %>"><%= recarga ? "+" : "−" %> S/ <%= dinero(mov.getMonto()) %></td>
                            <td class="small muted"><%= escapar(mov.getFecha()) %></td>
                        </tr>
                    <% } %>
                    </tbody></table></div>
            <% } %>
        </section></div>
        <div class="col-lg-4"><section class="panel bg-white p-3 p-md-4">
            <h2 class="h5 fw-bold mb-3">Nuevo movimiento</h2>
            <form action="<%= escapar(ctx) %>/billetera" method="post">
                <div class="mb-3"><label for="tipo" class="form-label fw-semibold">Tipo de movimiento</label>
                    <select class="form-select" id="tipo" name="tipo" required>
                        <option value="Recarga" <%= "Recarga".equals(tipoSeleccionado) ? "selected" : "" %>>Recarga</option>
                        <option value="Gasto" <%= "Gasto".equals(tipoSeleccionado) ? "selected" : "" %>>Gasto</option>
                    </select></div>
                <div class="mb-3"><label for="monto" class="form-label fw-semibold">Monto (S/)</label>
                    <input class="form-control" type="number" id="monto" name="monto" min="0.01" step="0.01" placeholder="Ej. 100.00" value="<%= escapar(montoIngresado) %>" required>
                    <div class="form-text">Ingresa un monto mayor que cero.</div></div>
                <button class="btn btn-primary w-100 fw-semibold" type="submit">Registrar movimiento</button>
            </form>
        </section>
        <section class="mt-3 rounded-3 p-3" style="background:#fff7e8;border:1px solid #f5dfb4">
            <div class="fw-bold small mb-1">Reglas de validación</div><ul class="small mb-0 ps-3">
                <li>El monto debe ser positivo.</li><li>No se aceptan montos vacíos o no numéricos.</li>
                <li>Un gasto no puede superar el saldo.</li><li>Los errores no alteran saldo ni historial.</li>
            </ul></section></div>
    </div>
    <p class="text-center small muted mt-4 mb-0">Evaluación T1 · Caso 1 · Datos guardados durante la sesión HTTP.</p>
</main>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body></html>
