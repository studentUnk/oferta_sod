------------------------
-- Consultas
------------------------
-- Consulta de clientes con compra acumulada de 100000 en los ultimos 60 dias
SELECT *
FROM (
SELECT documento_cliente, SUM(total_pago_cliente) AS acumulado
FROM factura
WHERE fecha BETWEEN (SYSDATE-60) AND SYSDATE
GROUP BY documento_cliente
) c
WHERE c.acumulado = 100000;

-- Consulta de servicios mas generados en los ultimos 30 dias
SELECT COUNT(tipo_servicio) cantidad, tipo_servicio
FROM mantenimiento
WHERE fecha_fin BETWEEN (SYSDATE-30) AND SYSDATE
GROUP BY tipo_servicio
ORDER BY COUNT(tipo_servicio) DESC
FETCH FIRST 100 ROWS ONLY;

-- Consulta de todos los clientes > 1 mantenimiento en los ultimos 30 dias
SELECT *
FROM (
SELECT COUNT(documento_cliente) cantidad, documento_cliente
FROM mantenimiento
WHERE fecha_fin BETWEEN (SYSDATE-30) AND SYSDATE
) c
WHERE c.cantidad > 1;
