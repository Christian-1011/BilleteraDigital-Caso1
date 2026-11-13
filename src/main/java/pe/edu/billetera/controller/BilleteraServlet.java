package pe.edu.billetera.controller;

import pe.edu.billetera.model.Movimiento;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.List;

/** Controlador principal: procesa GET/POST y mantiene los datos en HttpSession. */
@WebServlet(name = "BilleteraServlet", urlPatterns = {"/billetera"})
public class BilleteraServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String ATR_SALDO = "saldo";
    private static final String ATR_MOVIMIENTOS = "movimientos";
    private static final BigDecimal SALDO_INICIAL = new BigDecimal("250.00");
    private static final String VISTA = "/WEB-INF/views/billetera.jsp";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession(true);
        inicializarSesion(session);
        cargarVista(request, response, session);
    }

    @Override
    @SuppressWarnings("unchecked")
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(true);
        inicializarSesion(session);

        String tipo = request.getParameter("tipo");
        String montoTexto = request.getParameter("monto");
        String error = validarTipo(tipo);
        BigDecimal monto = null;

        if (error == null) {
            try {
                if (montoTexto == null || montoTexto.trim().isEmpty()) {
                    throw new NumberFormatException("Monto vacío");
                }
                monto = new BigDecimal(montoTexto.trim()).setScale(2, RoundingMode.UNNECESSARY);
                if (monto.compareTo(BigDecimal.ZERO) <= 0) {
                    error = "El monto debe ser mayor que cero.";
                }
            } catch (NumberFormatException | ArithmeticException ex) {
                error = "Ingresa un monto numérico válido con máximo dos decimales.";
            }
        }

        BigDecimal saldo = (BigDecimal) session.getAttribute(ATR_SALDO);
        if (error == null && "Gasto".equals(tipo) && monto.compareTo(saldo) > 0) {
            error = "Saldo insuficiente. Tu saldo disponible es S/ " + saldo.toPlainString() + ".";
        }

        if (error != null) {
            request.setAttribute("mensajeError", error);
            request.setAttribute("tipoSeleccionado", tipo == null ? "Recarga" : tipo);
            request.setAttribute("montoIngresado", montoTexto == null ? "" : montoTexto);
            cargarVista(request, response, session);
            return;
        }

        synchronized (session) {
            // Se vuelve a leer el saldo dentro del bloque para evitar gastar sobre un saldo obsoleto.
            saldo = (BigDecimal) session.getAttribute(ATR_SALDO);
            if ("Gasto".equals(tipo) && monto.compareTo(saldo) > 0) {
                request.setAttribute("mensajeError", "Saldo insuficiente. Tu saldo disponible es S/ " + saldo.toPlainString() + ".");
                request.setAttribute("tipoSeleccionado", tipo);
                request.setAttribute("montoIngresado", montoTexto);
                cargarVista(request, response, session);
                return;
            }
            List<Movimiento> movimientos = (List<Movimiento>) session.getAttribute(ATR_MOVIMIENTOS);
            if ("Recarga".equals(tipo)) {
                saldo = saldo.add(monto);
            } else {
                saldo = saldo.subtract(monto);
            }
            movimientos.add(0, new Movimiento(tipo, monto));
            session.setAttribute(ATR_SALDO, saldo);
        }

        // Post-Redirect-Get: actualizar la página no repite el movimiento.
        response.sendRedirect(request.getContextPath() + "/billetera?ok=1");
    }

    private String validarTipo(String tipo) {
        if (!"Recarga".equals(tipo) && !"Gasto".equals(tipo)) {
            return "Selecciona un tipo de movimiento válido.";
        }
        return null;
    }

    @SuppressWarnings("unchecked")
    private void inicializarSesion(HttpSession session) {
        synchronized (session) {
            if (session.getAttribute(ATR_SALDO) == null) {
                session.setAttribute(ATR_SALDO, SALDO_INICIAL);
            }
            if (session.getAttribute(ATR_MOVIMIENTOS) == null) {
                session.setAttribute(ATR_MOVIMIENTOS, new ArrayList<Movimiento>());
            }
        }
    }

    @SuppressWarnings("unchecked")
    private void cargarVista(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws ServletException, IOException {
        request.setAttribute("saldo", session.getAttribute(ATR_SALDO));
        request.setAttribute("movimientos", session.getAttribute(ATR_MOVIMIENTOS));
        request.getRequestDispatcher(VISTA).forward(request, response);
    }
}
