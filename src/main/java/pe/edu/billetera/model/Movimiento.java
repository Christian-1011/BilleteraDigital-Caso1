package pe.edu.billetera.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/** Representa un movimiento válido de la billetera. */
public class Movimiento implements Serializable {
    private static final long serialVersionUID = 1L;
    private static final DateTimeFormatter FORMATO_FECHA = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

    private final String tipo;
    private final BigDecimal monto;
    private final LocalDateTime fecha;

    public Movimiento(String tipo, BigDecimal monto) {
        this.tipo = tipo;
        this.monto = monto;
        this.fecha = LocalDateTime.now();
    }

    public String getTipo() { return tipo; }
    public BigDecimal getMonto() { return monto; }
    public String getFecha() { return fecha.format(FORMATO_FECHA); }
    public boolean isRecarga() { return "Recarga".equals(tipo); }
}
