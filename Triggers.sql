--Creado por Tania del Angel 

---2. Crea una base de datos llamada test que contenga una tabla llamada alumnos con las siguientes columnas.

-- Tabla alumnos:
-- • id (entero sin signo)
-- • nombre (cadena de caracteres)
-- • apellido1 (cadena de caracteres)
-- • apellido2 (cadena de caracteres)
-- • email (cadena de caracteres)

DROP DATABASE IF EXISTS test;
CREATE DATABASE test;
USE test;
CREATE TABLE IF NOT EXISTS alumnos(
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(30),
  apellido1 VARCHAR(30),
  apellido2 VARCHAR(30),
  email VARCHAR(100)
);

-- Escriba un procedimiento llamado crear_email que dados los parámetros de entrada: nombre, apellido1, apellido2 y dominio, cree una dirección de email y la devuelva como salida. ---
--• Procedimiento: crear_email
-- • Entrada:
-- – nombre (cadena de caracteres)
-- – apellido1 (cadena de caracteres)
-- – apellido2 (cadena de caracteres)
-- – dominio (cadena de caracteres

-- devuelva una dirección de correo electrónico con el siguiente formato:
-- • El primer carácter del parámetro nombre.
-- • Los tres primeros caracteres del parámetro apellido1.
-- • Los tres primeros caracteres del parámetro apellido2.
-- • El carácter @.
-- • El dominio pasado como parámetro.


  --LEFT(cadena, longitud) extrae varios caracteres del comienzo (la parte izquierda) de la cadena: SELECT LEFT('Hola',2); ⇒ Ho

DELIMITER //
DROP PROCEDURE IF EXISTS crear_email//
CREATE PROCEDURE crear_email(
  IN nombre VARCHAR(30),
  IN apellido1 VARCHAR(30),
  IN apellido2 VARCHAR(30),
  IN dominio VARCHAR(20),
  OUT email VARCHAR(100)
)
BEGIN
  SET email = CONCAT((SELECT LEFT(nombre, 1)), (SELECT LEFT(apellido1, 3)), (SELECT LEFT(apellido2, 3)), '@', dominio);
ENDfunc
//
DELIMITER ;
CALL crear_email('Tania', 'Del Angel', 'Hernandez', 'gmail.com',@email);
SELECT @email AS email;

-- Una vez creada la tabla escriba un trigger con las siguientes características:
-- • Trigger: trigger_crear_email_before_insert
-- – Se ejecuta sobre la tabla alumnos.
-- – Se ejecuta antes de una operación de inserción.
-- – Si el nuevo valor del email que se quiere insertar es NULL, entonces se le creará automáticamente una dirección de email y se insertará en la tabla.
-- – Si el nuevo valor del email no es NULL se guardará en la tabla el valor del email.
-- Nota: Para crear la nueva dirección de email se deberá hacer uso del procedimiento crear_email.


DELIMITER //
DROP TRIGGER IF EXISTS trigger_crear_email_before_insert//
CREATE TRIGGER trigger_crear_email_before_insert
BEFORE INSERT ON alumnos FOR EACH ROW
BEGIN
  IF (new.email IS NULL) THEN
    CALL crear_email(new.nombre, new.apellido1, new.apellido2, 'alumno.uaemex.com', @email);
    SET new.email = @email;
  END IF;
END
//
DELIMITER ;
INSERT INTO alumnos VALUES (NULL, 'Jose','Vargas','Estrada', NULL);
SELECT * FROM alumnos;


-- 3. Modifica el ejercicio anterior y añade un nuevo trigger que las siguientes características:
-- Trigger: trigger_guardar_email_after_update:
-- • Se ejecuta sobre la tabla alumnos.
-- • Se ejecuta después de una operación de actualización.
-- • Cada vez que un alumno modifique su dirección de email se deberá insertar un nuevo registro en una tabla llamada log_cambios_email.
-- La tabla log_cambios_email contiene los siguientes campos:
-- • id: clave primaria (entero autonumérico)
-- • id_alumno: id del alumno (entero)
-- • fecha_hora: marca de tiempo con el instante del cambio (fecha y hora)
-- • old_email: valor anterior del email (cadena de caracteres)
-- • new_email: nuevo valor con el que se ha actualizado


CREATE TABLE IF NOT EXISTS log_cambios_email(
  id INT AUTO_INCREMENT PRIMARY KEY,
  id_alumno INT,
  fecha_hora DATETIME,
  old_email VARCHAR(100),
  new_email VARCHAR(100)
);


DELIMITER //
DROP TRIGGER IF EXISTS trigger_guardar_email_after_update//
CREATE TRIGGER trigger_guardar_email_after_update
AFTER UPDATE ON alumnos FOR EACH ROW
BEGIN
    INSERT INTO log_cambios_email VALUES(NULL,new.id, (SELECT NOW()) ,old.email, new.email);
END
//
DELIMITER ;

INSERT INTO alumnos VALUES(NULL, 'Sergio', 'Del Angel', 'Hernandez','sergiodelangel@gmail.com');

UPDATE alumnos SET email = 'sdelangelh@gmail.com' WHERE nombre = 'Sergio';

SELECT * FROM log_cambios_email;

-- 4. Modifica el ejercicio anterior y añade un nuevo trigger que tenga las siguientes características:
-- Trigger: trigger_guardar_alumnos_eliminados:
-- • Se ejecuta sobre la tabla alumnos.
-- • Se ejecuta después de una operación de borrado.
-- • Cada vez que se elimine un alumno de la tabla alumnos se deberá insertar
--   un nuevo registro en una tablallamada log_alumnos_eliminados.
-- La tabla log_alumnos_eliminados contiene los siguientes campos:
-- • id: clave primaria (entero autonumérico)
-- • id_alumno: id del alumno (entero)
-- • fecha_hora: marca de tiempo con el instante del cambio (fecha y hora)
-- • nombre: nombre del alumno eliminado (cadena de caracteres)
-- • apellido1: primer apellido del alumno eliminado (cadena de caracteres)
-- • apellido2: segundo apellido del alumno eliminado (cadena de caracteres)
-- • email: email del alumno eliminado (cadena de caracteres)
CREATE TABLE IF NOT EXISTS log_alumnos_eliminados(
  id INT AUTO_INCREMENT PRIMARY KEY,
  idAlumno INT,
  fecha_hora DATETIME,
  nombre VARCHAR(30),
  apellido1 VARCHAR(30),
  apellido2 VARCHAR(30),
  email VARCHAR(100)
);

DELIMITER //
DROP TRIGGER IF EXISTS trigger_guardar_alumnos_eliminados//
CREATE TRIGGER trigger_guardar_alumnos_eliminados
AFTER DELETE  ON alumnos FOR EACH ROW
BEGIN
  INSERT INTO log_alumnos_eliminados VALUES(NULL, old.id, (SELECT NOW()), old.nombre, old.apellido1, old.apellido2, old.email);
END
//
DELIMITER ;
INSERT INTO alumnos VALUES(NULL, 'Bruno', 'Sandoval', 'Diaz', 'brdiaz.@outlook.com');

DELETE FROM alumnos WHERE nombre = 'Bruno';
SELECT * FROM log_alumnos_eliminados;
