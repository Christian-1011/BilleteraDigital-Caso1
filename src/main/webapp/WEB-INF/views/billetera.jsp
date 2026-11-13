<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
<nav class="navbar navbar-dark topbar">
    <div class="container py-2">
        <span class="navbar-brand fw-semibold mb-0">Mi Billetera Digital</span>
        <span class="badge rounded-pill text-bg-secondary px-3 py-2">Java · JSP + Servlet</span>
    </div>
</nav>

<main class="container py-4 py-lg-5">
    <div class="row g-4 mb-4">
        <div class="col-lg-5">
            <section class="panel bg-white p-4 h-100">
                <div class="small text-uppercase fw-semibold muted mb-2">Saldo disponible</div>
                <div class="saldo">S/ <fmt:formatNumber value="${saldo}" minFractionDigits="2" maxFractionDigits="2"/></div>
                <div class="small muted mt-2">
                    <c:choose>
                        <c:when test="${empty movimientos}">Saldo inicial de la billetera</c:when>
                        <c:otherwise>Después de <c:out value="${fn:length(movimientos)}"/> movimiento(s) válido(s)</c:otherwise>
                    </c:choose>
                </div>
            </section>
        </div>
        <div class="col-lg-7">
            <section class="panel p-4 h-100" style="background:#eaf2ff;border-color:#cbdcff">
                <span class="badge text-bg-primary mb-3">GET / Servlet</span>
                <h2 class="h5 fw-bold">Información de tu billetera</h2>
                <p class="mb-1">El Servlet obtiene el saldo y el historial almacenados en tu sesión HTTP.</p>
                <p class="small muted mb-0">La vista JSP presenta los datos utilizando JSTL, sin scriptlets.</p>
            </section>
        </div>
    </div>

    <c:if test="${param.ok eq '1'}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            Movimiento registrado correctamente.
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Cerrar"></button>
        </div>
    </c:if>
    <c:if test="${not empty mensajeError}">
        <div class="alert alert-danger" role="alert"><strong>No se pudo registrar:</strong> <c:out value="${mensajeError}"/></div>
    </c:if>

    <div class="row g-4">
        <div class="col-lg-8">
            <section class="panel bg-white p-3 p-md-4">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h2 class="h5 fw-bold mb-0">Movimientos recientes</h2>
                    <span class="badge text-bg-light border text-secondary"><c:out value="${fn:length(movimientos)}"/> registro(s)</span>
                </div>
                <c:choose>
                    <c:when test="${empty movimientos}">
                        <div class="text-center py-5">
                            <div class="fs-1 mb-2">▤</div>
                            <h3 class="h6 fw-semibold">Aún no hay movimientos</h3>
                            <p class="muted small mb-0">Cuando registres una recarga o un gasto aparecerá aquí.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="table-responsive">
                            <table class="table align-middle mb-0">
                                <thead class="table-light"><tr><th>Tipo</th><th>Monto (S/)</th><th>Fecha</th></tr></thead>
                                <tbody>
                                <c:forEach var="mov" items="${movimientos}">
                                    <tr>
                                        <td><span class="tag ${mov.recarga ? 'tag-recarga' : 'tag-gasto'}"><c:out value="${mov.tipo}"/></span></td>
                                        <td class="${mov.recarga ? 'monto-recarga' : 'monto-gasto'}">
                                            <c:choose><c:when test="${mov.recarga}">+</c:when><c:otherwise>−</c:otherwise></c:choose>
                                            S/ <fmt:formatNumber value="${mov.monto}" minFractionDigits="2" maxFractionDigits="2"/>
                                        </td>
                                        <td class="small muted"><c:out value="${mov.fecha}"/></td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:otherwise>
                </c:choose>
            </section>
        </div>

        <div class="col-lg-4">
            <section class="panel bg-white p-3 p-md-4">
                <h2 class="h5 fw-bold mb-3">Nuevo movimiento</h2>
                <form action="${pageContext.request.contextPath}/billetera" method="post" novalidate>
                    <div class="mb-3">
                        <label for="tipo" class="form-label fw-semibold">Tipo de movimiento</label>
                        <select class="form-select" id="tipo" name="tipo" required>
                            <option value="Recarga" ${tipoSeleccionado eq 'Recarga' ? 'selected' : ''}>Recarga</option>
                            <option value="Gasto" ${tipoSeleccionado eq 'Gasto' ? 'selected' : ''}>Gasto</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="monto" class="form-label fw-semibold">Monto (S/)</label>
                        <input class="form-control" type="number" id="monto" name="monto" min="0.01" step="0.01" placeholder="Ej. 100.00" value="<c:out value='${montoIngresado}'/>" required>
                        <div class="form-text">Ingresa un monto mayor que cero.</div>
                    </div>
                    <button class="btn btn-primary w-100 fw-semibold" type="submit">Registrar movimiento</button>
                </form>
            </section>
            <section class="mt-3 rounded-3 p-3" style="background:#fff7e8;border:1px solid #f5dfb4">
                <div class="fw-bold small mb-1">Reglas de validación</div>
                <ul class="small mb-0 ps-3">
                    <li>El monto debe ser positivo.</li>
                    <li>No se aceptan montos vacíos o no numéricos.</li>
                    <li>Un gasto no puede superar el saldo.</li>
                    <li>Los errores no alteran saldo ni historial.</li>
                </ul>
            </section>
        </div>
    </div>
    <p class="text-center small muted mt-4 mb-0">Evaluación T1 · Caso 1 · Datos guardados durante la sesión HTTP.</p>
</main>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
