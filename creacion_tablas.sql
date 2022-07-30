----------------------
-- Creacion de tablas
----------------------

CREATE TABLE tipo_documento
(
tipo_documento VARCHAR2(3),
descripcion VARCHAR2 (150),
PRIMARY KEY (tipo_documento)
);

CREATE TABLE cliente
(
documento VARCHAR2(20),
primer_nombre VARCHAR2 (50),
segundo_nombre VARCHAR2 (50),
primer_apellido VARCHAR2 (50),
segundo_apellido VARCHAR2 (50),
tipo_documento VARCHAR2 (3),
celular VARCHAR2 (15),
direccion VARCHAR2 (150),
correo_e VARCHAR2 (100),
presupuesto_max DECIMAL (12,2),
PRIMARY KEY (documento),
FOREIGN KEY (tipo_documento) REFERENCES tipo_documento (tipo_documento)
);

CREATE TABLE tipo_vehiculo
(
tipo_vehiculo VARCHAR2(3),
descripcion VARCHAR2 (150),
PRIMARY KEY (tipo_vehiculo)
);

CREATE TABLE vehiculo
(
numero_vehiculo NUMBER GENERATED ALWAYS AS IDENTITY,
tipo_vehiculo VARCHAR2(20),
placa VARCHAR2 (15),
documento_cliente VARCHAR2(20),
PRIMARY KEY (numero_vehiculo),
FOREIGN KEY (tipo_vehiculo) REFERENCES tipo_vehiculo (tipo_vehiculo),
FOREIGN KEY (documento_cliente) REFERENCES cliente (documento)
);

CREATE TABLE mecanico
(
documento VARCHAR2(20),
primer_nombre VARCHAR2 (50),
segundo_nombre VARCHAR2 (50),
primer_apellido VARCHAR2 (50),
segundo_apellido VARCHAR2 (50),
tipo_documento VARCHAR2 (3),
celular VARCHAR2 (15),
direccion VARCHAR2 (150),
correo_e VARCHAR2 (100),
PRIMARY KEY (documento),
FOREIGN KEY (tipo_documento) REFERENCES tipo_documento (tipo_documento)
);

CREATE TABLE repuestos
(
num_repuesto NUMBER GENERATED ALWAYS AS IDENTITY,
nombre_repuesto VARCHAR2 (100),
cantidad_disponbile NUMBER,
precio_unidad DECIMAL (12,2),
PRIMARY KEY (num_repuesto)
);

CREATE TABLE estado_mantenimiento
(
estado VARCHAR2(15),
descripcion VARCHAR2 (150),
PRIMARY KEY (estado)
);

CREATE TABLE tipo_servicio
(
tipo_servicio VARCHAR2(3),
descripcion VARCHAR2 (150),
valor_min_obra DECIMAL (12,2),
valor_max_obra DECIMAL (12,2),
PRIMARY KEY (tipo_servicio)
);

CREATE TABLE mantenimiento
(
num_mantenimiento NUMBER GENERATED ALWAYS AS IDENTITY,
numero_vehiculo NUMBER,
num_repuesto NUMBER,
documento_cliente VARCHAR2(20),
documento_mecanico VARCHAR2(20),
accion_realizada VARCHAR2(150),
fecha_inicio DATE,
fecha_fin DATE,
estado VARCHAR2(15),
tipo_servicio VARCHAR2(3),
precio_repuesto DECIMAL (12,2) NOT NULL,
cantidad_repuesto NUMBER,
total_repuesto DECIMAL (12,2) NOT NULL,
descuento_repuesto DECIMAL (3,2),
valor_mano_obra DECIMAL (12,2),
descuento_mano_obra DECIMAL (3,2),
PRIMARY KEY (num_mantenimiento),
FOREIGN KEY (numero_vehiculo) REFERENCES vehiculo (numero_vehiculo),
FOREIGN KEY (num_repuesto) REFERENCES respuestos (num_repuesto),
FOREIGN KEY (documento_mecanico) REFERENCES mecanico (documento),
FOREIGN KEY (documento_cliente) REFERENCES cliente (documento),
FOREIGN KEY (estado) REFERENCES estado_mantenimiento (estado),
FOREIGN KEY (tipo_servicio) REFERENCES tipo_servicio (tipo_servicio)
);

CREATE TABLE factura
(
num_factura NUMBER GENERATED ALWAYS AS IDENTITY,
fecha DATE,
documento_cliente VARCHAR2(20),
primer_nombre_cliente VARCHAR2 (50),
segundo_nombre_cliente VARCHAR2 (50),
primer_apellido_cliente VARCHAR2 (50),
segundo_apellido_cliente VARCHAR2 (50),
tipo_documento_cliente VARCHAR2 (3),
celular_cliente VARCHAR2 (15),
direccion_cliente VARCHAR2 (150),
correo_e_cliente VARCHAR2 (100),
documento_mecanico VARCHAR2(20),
primer_nombre_mecanico VARCHAR2 (50),
segundo_nombre_mecanico VARCHAR2 (50),
primer_apellido_mecanico VARCHAR2 (50),
segundo_apellido_mecanico VARCHAR2 (50),
tipo_documento_mecanico VARCHAR2 (3),
celular_mecanico VARCHAR2 (15),
direccion_mecanico VARCHAR2 (150),
correo_e_mecanico VARCHAR2 (100),
total_repuestos DECIMAL (12,2) NOT NULL,
total_descuento_repuestos DECIMAL (12,2),
total_mano_obra DECIMAL (12,2) NOT NULL,
total_descuento_mano_obra DECIMAL (12,2),
total_pago_sin_iva DECIMAL (12,2) NOT NULL,
total_pago_iva DECIMAL (12,2) NOT NULL,
total_pago_cliente DECIMAL (12,2) NOT NULL,
PRIMARY KEY (num_factura),
FOREIGN KEY (documento_cliente) REFERENCES cliente (documento),
FOREIGN KEY (documento_mecanico) REFERENCES mecanico (documento)
);

