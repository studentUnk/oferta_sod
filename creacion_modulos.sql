------------------------
-- Modulo
------------------------

CREATE OR REPLACE PACKAGE facturacion AS

TYPE porcentaje_iva CONSTANT REAL := 0.19;
TYPE descuento_servicio CONSTANT REAL := 3000000.00;
TYPE porcentaje_descuento_servicio CONSTANT REAL := 0.50;

FUNCTION obtener_iva (valor IN DECIMAL) RETURN DECIMAL IS
BEGIN 
RETURN valor * porcentaje_iva;
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.put_line ('Error en obtencion valor de iva');
    RAISE;
END;

FUNCTION descuento_servicio (valor IN DECIMAL) RETURN DECIMAL IS
BEGIN
IF valor > descuento_servicio THEN
RETURN valor * porcentaje_descuento_servicio;
ELSE 
RETURN valor;
END IF;
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.put_line ('Error en obtencion valor de iva');
    RAISE;
END;

-- Procedimiento para eliminar factura 
PROCEDURE eliminar_factura (numero_factura IN NUMBER) IS
BEGIN
DELETE FROM factura
WHERE num_factura = numero_factura;
COMMIT;
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.put_line ('Error al eliminar factura');
    RAISE;
END;

-- Procedimiento para restar productos disponibles
PROCEDURE restar_productos (cantidad IN NUMBER, numero_repuesto IN NUMBER) IS
BEGIN
UPDATE repuestos
SET cantidad_disponible = cantidad_disponible - cantidad
WHERE num_repuesto = numero_repuesto;
COMMIT;
END;

-- Procedimiento para crear una unica factura
PROCEDURE crear_factura (documento_cliente_f IN VARCHAR2, documento_mecanico_f IN VARCHAR2) IS

p_n_cliente AS VARCHAR2 (50);
s_n_cliente AS VARCHAR2 (50);
p_a_cliente AS VARCHAR2 (50);
s_a_cliente AS VARCHAR2 (50);
t_doc_cliente VARCHAR2 (3);
cel_cliente VARCHAR2 (15);
dir_cliente VARCHAR2 (150);
cor_cliente VARCHAR2 (100);
p_n_mecanico AS VARCHAR2 (50);
s_n_mecanico AS VARCHAR2 (50);
p_a_mecanico AS VARCHAR2 (50);
s_a_mecanico AS VARCHAR2 (50);
t_doc_mecanico VARCHAR2 (3);
cel_mecanico VARCHAR2 (15);
dir_mecanico VARCHAR2 (150);
cor_mecanico VARCHAR2 (100);
total_rep DECIMAL (12,2);
total_desc_rep DECIMAL (12,2);
total_ob DECIMAL (12,2);
total_desc_ob DECIMAL (12,2);
t_sin_iva DECIMAL (12,2);
t_iva DECIMAL (12,2);
t_factura DECIMAL (12,2);
max_cliente DECIMAL (12,2);

BEGIN
DBMS_OUTPUT.put_line ('Inicia creacion de factura');

-- Datos cliente
SELECT primer_nombre,
segundo_nombre,
primer_apellido,
segundo_apellido,
tipo_documento,
celular,
direccion,
correo_e
INTO p_n_cliente,
s_n_cliente,
p_a_cliente,
s_a_cliente,
t_doc_cliente,
cel_cliente,
dir_cliente,
cor_cliente
FROM cliente
WHERE documento = documento_cliente_f;

-- Datos mecanico
SELECT primer_nombre,
segundo_nombre,
primer_apellido,
segundo_apellido,
tipo_documento,
celular,
direccion,
correo_e
INTO p_n_mecanico,
s_n_mecanico,
p_a_mecanico,
s_a_mecanico,
t_doc_mecanico,
cel_mecanico,
dir_mecanico,
cor_mecanico
FROM mecanico
WHERE documento = documento_mecanico_f;

-- Datos mantenimiento
SELECT SUM(total_repuesto),
SUM(descuento_repuesto),
SUM(valor_mano_obra),
SUM(descuento_mano_obra),
INTO total_rep,
total_desc_rep,
total_ob,
total_desc_ob
FROM mantenimiento
WHERE documento_cliente_f = documento_cliente
AND estado = 'terminado';

total_ob := descuento_servicio(total_ob);

t_sin_iva := total_rep+total_ob;
t_iva := obtener_iva(total_rep+total_ob);
t_factura := t_sin_iva+t_iva;

BEGIN 
SELECT presupuesto_max
INTO max_cliente
FROM cliente
WHERE documento_cliente_f = documento_cliente;
EXCEPTION
WHEN NO_DATA_FOUND THEN
max_cliente := 0.00;
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.put_line ('Error en obtencion de presupuesto maximo');
    RAISE;
END;

-- Validar si el cliente establecio valor maximo antes de insertar factura
IF max_cliente <> 0.00 AND t_factura > max_cliente THEN
DBMS_OUTPUT.put_line ('La factura no se puede generar por presupuesto maximo del cliente');
RETURN -1;
END IF;

-- Crear factura
INSERT INTO factura (
fecha,
documento_cliente,
primer_nombre_cliente,
segundo_nombre_cliente,
primer_apellido_cliente,
segundo_apellido_cliente,
tipo_documento_cliente,
celular_cliente,
direccion_cliente,
correo_e_cliente,
documento_mecanico,
primer_nombre_mecanico,
segundo_nombre_mecanico,
primer_apellido_mecanico,
segundo_apellido_mecanico,
tipo_documento_mecanico,
celular_mecanico,
direccion_mecanico,
correo_e_mecanico,
total_repuestos,
total_descuento_repuestos,
total_mano_obra,
total_descuento_mano_obra
total_pago_sin_iva,
total_pago_iva,
total_pago_cliente
)
VALUES
(
SYSDATE,
documento_cliente_f,
p_n_cliente,
s_n_cliente,
p_a_cliente,
s_a_cliente,
t_doc_cliente,
cel_cliente,
dir_cliente,
cor_cliente,
documento_mecanico_f,
p_n_mecanico,
s_n_mecanico,
p_a_mecanico,
s_a_mecanico,
t_doc_mecanico,
cel_mecanico,
dir_mecanico,
cor_mecanico,
total_rep,
total_rep,
total_desc_rep,
total_ob,
total_desc_ob,
t_sin_iva,
t_iva,
t_factura
);
COMMIT;

EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.put_line ('Error en creacion de factura');
    RAISE;
END;

END facturacion;
/


