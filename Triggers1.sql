--Created by Tania del Angel


--1. Crea una base de datos llamada test que contenga una tabla llamada alumnos con las siguientes columnas.

-- • id (entero sin signo)
-- • nombre (cadena de caracteres)
-- • apellido1 (cadena de caracteres)
-- • apellido2 (cadena de caracteres)
-- • nota (número real)


DROP DATABASE IF EXISTS testTriggers;
CREATE DATABASE testTriggers;
USE testTriggers;
CREATE TABLE alumnos(
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(30),
  apellido1 VARCHAR(30),
  apellido2 VARCHAR(30),
  nota FLOAT
);


-- Una vez creada la tabla escriba dos triggers con las siguientes características:
-- • Trigger 1: trigger_check_nota_before_insert
-- – Se ejecuta sobre la tabla alumnos.
-- – Se ejecuta antes de una operación de inserción.
-- – Si el nuevo valor de la nota que se quiere insertar es negativo, se guarda como 0.
-- – Si el nuevo valor de la nota que se quiere insertar es mayor que 10, se guarda como 10

DELIMITER //
DROP TRIGGER IF EXISTS trigger_checkNota_B_insert//
CREATE TRIGGER trigger_checkNota_B_insert
BEFORE INSERT ON alumnos FOR EACH ROW
BEGIN
  IF new.nota < 0 THEN
  set new.nota = 0;
  ELSEIF new.nota > 10 THEN
  set new.nota = 10;
  END IF;
END
//

INSERT INTO alumnos VALUES (2, 'Leonardo', 'Villanueva', 'Medina', 7.7);

INSERT INTO alumnos Values (2, 'Tania', 'Del Angel' ,'Hernandez', 10)

INSERT INTO alumnos VALUES (4, 'Bladimir', 'Garduo', 'Sanchez', 5); 🙁

I

NSERT INTO alumnos VALUES (5, 'Miguel', 'Flores', 'Urbina', -3);


-- Trigger2 : trigger_check_nota_before_update
-- – Se ejecuta sobre la tabla alumnos.
-- – Se ejecuta antes de una operación de actualización.
-- – Si el nuevo valor de la nota que se quiere actualizar es negativo, se guarda como 0.
-- – Si el nuevo valor de la nota que se quiere actualizar es mayor que 10, se guarda como 10.


DELIMITER //
DROP TRIGGER IF EXISTS trigger_checkNota__B_update//
CREATE TRIGGER trigger_checkNota_B_update
BEFORE UPDATE ON alumnos FOR EACH ROW
BEGIN
  IF new.nota < 0 THEN
  set new.nota = 0;
  ELSEIF new.nota > 10 THEN
  set new.nota = 10;
  END IF;
END
//



SHOW TRIGGERS;
SHOW CREATE TRIGGER trigger_checkNota_B_insert;
SELECT * FROM information_schema.triggers WHERE trigger_schema = 'testTriggers'\G;
SELECT TRIGGER_SCHEMA, TRIGGER_NAME FROM information_schema.triggers WHERE trigger_schema = 'testTriggers';
SELECT TRIGGER_SCHEMA, TRIGGER_NAME, EVENT_MANIPULATION,
EVENT_OBJECT_TABLE, ACTION_STATEMENT, ACTION_TIMING FROM information_schema.triggers WHERE trigger_schema = 'testTriggers'\G;


-- The RETURN statement is not permitted in triggers, which cannot return a
-- value. To exit a trigger immediately, use the LEAVE statement.
--Triggers are not permitted on tables in the mysql database.
--Nor are they permitted on INFORMATION_SCHEMA or performance_schema tables.
--Those tables are actually views and triggers are not permitted on views.
--https://dev.mysql.com/doc/refman/8.0/en/triggers.html
