--Create by Tania del Angel
--Este archivo muestra creación de Roles y permisos

--Movernos a la base de datos jardineria

USE jardineria;
--Crear los usuarios
CREATE USER IF NOT EXISTS john IDENTIFIED BY 'sesame';
CREATE USER IF NOT EXISTS jane IDENTIFIED BY 'sesame';
CREATE USER IF NOT EXISTS jim IDENTIFIED BY 'sesame';
CREATE USER IF NOT EXISTS joel@localhost IDENTIFIED BY 'sesame';


--Crear los roles
CREATE ROLE IF NOT EXISTS developer, manager, user;

--Crear un ROL para el manejo de COLUMNAS
CREATE ROLE IF NOT EXISTS columnas;


--Conseder privilegios al developer role
GRANT ALL ON *.* TO developer WITH GRANT OPTION;

--Concedir privilegios al manager role
GRANT SELECT, INSERT, UPDATE, DELETE ON jardineria.* TO manager WITH GRANT OPTION;

--Conseder privilegios al user role
GRANT SELECT, INSERT, UPDATE, DELETE ON jardineria.empleado TO user;
GRANT SELECT, INSERT, UPDATE, DELETE ON jardineria.cliente TO user;
GRANT SELECT, INSERT, UPDATE, DELETE ON jardineria.gama_producto TO user;
GRANT SELECT ON jardineria.detalle_pedido TO user;
GRANT SELECT ON jardineria.pago TO user;

--asignar roles a los usuarios
GRANT developer TO joel@localhost;
GRANT manager TO jim;
GRANT user TO john, jane;

--Conseder privilegios al role ĆOLUMNAS en columnas
GRANT SELECT (codigo_pedido, codigo_producto, precio_unidad),
      UPDATE(precio_unidad)
      ON jardineria.detalle_pedido
      TO columnas;

GRANT SELECT(codigo_cliente, forma_pago, id_transaccion, fecha_pago, total), UPDATE(fecha_pago, total)
ON jardineria.pago
TO columnas;

--Dar roles por DEFAULT para users
SET DEFAULT ROLE developer TO joel@localhost;
SET DEFAULT ROLE manager to jim;
SET DEFAULT ROLE user TO john, jane;
