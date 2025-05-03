-- Database: SITEMA_VENTAS_CELULARES

-- DROP DATABASE IF EXISTS "SITEMA_VENTAS_CELULARES";

CREATE DATABASE "SITEMA_VENTAS_CELULARES"
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'es-ES'
    LC_CTYPE = 'es-ES'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

	CREATE TABLE clientes (
  id_cliente SERIAL PRIMARY KEY,
  nombre VARCHAR(100),
  correo VARCHAR(100)
);

CREATE TABLE productos (
  id_producto SERIAL PRIMARY KEY,
  nombre VARCHAR(100),
  marca VARCHAR(50),
  precio NUMERIC(10, 2)
);

CREATE TABLE ventas (
  id_venta SERIAL PRIMARY KEY,
  id_cliente INTEGER REFERENCES clientes(id_cliente),
  fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE detalle_ventas (
  id_detalle SERIAL PRIMARY KEY,
  id_venta INTEGER REFERENCES ventas(id_venta),
  id_producto INTEGER REFERENCES productos(id_producto),
  cantidad INTEGER,
  subtotal NUMERIC(10, 2)
);


INSERT INTO clientes (nombre, correo) VALUES
('Juan Pérez', 'juan@example.com'),
('Ana Gómez', 'ana@example.com');


INSERT INTO productos (nombre, marca, precio) VALUES
('Galaxy S23', 'Samsung', 800.00),
('iPhone 14', 'Apple', 950.00),
('Redmi Note 12', 'Xiaomi', 300.00);


INSERT INTO ventas (id_cliente) VALUES (1);
INSERT INTO detalle_ventas (id_venta, id_producto, cantidad, subtotal) VALUES
(1, 1, 1, 800.00),
(1, 3, 2, 600.00);


INSERT INTO ventas (id_cliente) VALUES (2);
INSERT INTO detalle_ventas (id_venta, id_producto, cantidad, subtotal) VALUES
(2, 2, 1, 950.00);

SELECT  
  v.id_venta,
  c.nombre AS cliente,
  p.nombre AS producto,
  p.marca,
  dv.cantidad,
  dv.subtotal,
  v.fecha
FROM ventas v
INNER JOIN clientes c ON v.id_cliente = c.id_cliente
INNER JOIN detalle_ventas dv ON v.id_venta = dv.id_venta
INNER JOIN productos p ON dv.id_producto = p.id_producto;

SELECT  
  v.id_venta,
  c.nombre AS cliente,
  SUM(dv.subtotal) AS total
FROM ventas v
JOIN clientes c ON v.id_cliente = c.id_cliente
JOIN detalle_ventas dv ON v.id_venta = dv.id_venta
GROUP BY v.id_venta, c.nombre;

SELECT  
  p.nombre AS producto,
  SUM(dv.cantidad) AS total_vendidos
FROM productos p
JOIN detalle_ventas dv ON p.id_producto = dv.id_producto
GROUP BY p.nombre
ORDER BY total_vendidos DESC;
