--Creado por Tania del Angel

--1. Crea los siguientes usuarios y asigna los permisos correspondientes. Donde XXX Corresponde a las iniciales de tu nombre.
CREATE USER 'jefeDepTDH'@'localhost' IDENTIFIED BY 'contrasenia1';

CREATE USER 'tablasTDH'@'localhost' IDENTIFIED BY 'contrasenia2';

GRANT SELECT, INSERT, UPDATE, CREATE VIEW, SHOW VIEW ON ej2_empleados.* TO jefeDepTDH@localhost;

FLUSH PRIVILEGES;

GRANT SELECT, INSERT ON ej2_empleados.* TO tablasTDH@localhost;
FLUSH PRIVILEGES;


GRANT UPDATE ON ej2_empleados.PROYECTO TO tablasTDH@localhost;
FLUSH PRIVILEGES;

GRANT DELETE ON ej2_empleados.DEPARTAMENTO TO tablasTDH@localhost;
FLUSH PRIVILEGES;

GRANT DELETE ON ej2_empleados.LOCALIZACIONES_DPTO TO tablasTDH@localhost;
FLUSH PRIVILEGES;


--2. Muestra los usuarios y sus permisos
SHOW GRANTS FOR jefeDepTDH@localhost;
SHOW GRANTS FOR tablasTDH@localhost;


--3. Quita el permiso al usuario tablasXXX para borrar registros en la tabla departamento

REVOKE DELETE ON ej2_empleados.DEPARTAMENTO FROM tablasTDH@localhost;

--4. Modifica los permisos del usuario tablasXXX para que se le permita modificar la estructura de todas las tablas.
GRANT ALL PRIVILEGES ON ej2_empleados.* TO tablasTDH@localhost;
GRANT ALTER ON ej2_empleados.* TO tablasTDH@localhost;


--5. Usando el usuario jefeDepXXX intenta eliminar un registro de alguna tabla, explica el resultado obtenido.
DELETE FROM LOCALIZACIONES_DPTO WHERE UbicacionDpto  =  'Valencia';
--RESULTADO: ERROR 1142 (42000): DELETE command denied to user 'jefeDepTDH'@'localhost' for table 'localizaciones_dpto'
--EXPLICACIÓN: jefeDepTDH no tiene los permisos de borrar en las tablas

--Con el usuario jefeDepXXX realiza las siguientes vistas:
  mysql -u jefeDepTDH -p
  --password: contrasenia1
--  6. Crear una vista con todos los proyectos ubicados en Madrid
CREATE VIEW proyMadrid AS SELECT * FROM PROYECTO WHERE UbicacionProyecto = 'Madrid';
--  a) Usando la vista creada, muestra los proyectos ordenados por número de  departamento
SELECT * FROM proyMadrid ORDER BY NumDptoProyecto;

--  b) Agrega un nuevo proyecto llamado “Auditoria” usando la vista, revisa las  restricciones existentes
INSERT INTO proyMadrid VALUES (5, 'Auditoria',  'Los Angeles', 5);
--  c Usando la vista, modifica el proyecto para que su número de proyecto sea tu edad.
UPDATE proyMadrid SET NumProyecto=20 WHERE NombreProyecto='Auditoria';
-- ERROR 1062 (23000): Duplicate entry '20' for key 'proyecto.PRIMARY' no se pudo pues otro proyecto ya tiene esa clave primaria, intente con 21 :)

--7. Crear una vista con el nombre, apellido1, sueldo, dni, superdni, dno de todos los empleados del departamento 5.
CREATE VIEW EmpDep5 AS SELECT NOMBRE, APELLIDOUNO, SUELDO, DNI, SUPER_DNI, departamento.NumeroDpto FROM empleado INNER JOIN departamento ON empleado.dni = departamento.DniDirector WHERE departamento.NumeroDpto = 5;

--  a)Intenta ingresar un dato, explica el resultado obtenido
INSERT INTO EmpDep5 VALUES ('Eduardo', 'Ochoa', 55000, 888665555, 987654321, 5);
-- RESULTADO Can not insert into join view 'ej2_empleados.empdep5' without fields list
--EXPLICACION no podemos insertar en una vista donde se haya echo una operacion join

--8. Crear una vista de todos los proyectos realizados por el departamento 4, se debe  mostrar el nombre y dni del director de departamento, nombre y número de departamento, así como nombre y número de proyecto.

CREATE VIEW ProyDep4 AS SELECT  NOMBRE, DNI, DEPARTAMENTO.NombreDpto, DEPARTAMENTO.NumeroDpto, PROYECTO.NombreProyecto, PROYECTO.NumProyecto FROM empleado INNER JOIN  DEPARTAMENTO ON empleado.dni = departamento.DniDirector INNER JOIN PROYECTO on departamento.NumeroDpto = proyecto.NumDptoProyecto WHERE DEPARTAMENTO.NumeroDpto = 4;
-- a. Modifica la vista para que no se muestre el número de proyecto
CREATE OR REPLACE VIEW ProyDep4 AS SELECT  NOMBRE, DNI, DEPARTAMENTO.NombreDpto, DEPARTAMENTO.NumeroDpto, PROYECTO.NombreProyecto FROM empleado INNER JOIN  DEPARTAMENTO ON empleado.dni = departamento.DniDirector INNER JOIN PROYECTO on departamento.NumeroDpto = proyecto.NumDptoProyecto WHERE DEPARTAMENTO.NumeroDpto = 4;

--9. Crear una vista en la que se muestren los empleados que trabajan en los proyectos 10 y 30, mostrando el dni, nombre y horas trabajadas del empleado, nombre y número del proyecto.

CREATE VIEW PROY1030 AS SELECT DNI, NOMBRE, TRABAJA_EN.Horas, PROYECTO.NombreProyecto, PROYECTO.NumProyecto FROM EMPLEADO INNER JOIN TRABAJA_EN ON empleado.dni = TRABAJA_EN.DniEmpleado INNER JOIN PROYECTO ON TRABAJA_EN.NumProy = PROYECTO.NumProyecto WHERE PROYECTO.NumProyecto in(10, 30);

--a. Usando la vista, indica el número de horas totales trabajadas para los proyectos 10 y 30.
SELECT NombreProyecto , NumProyecto, SUM(HORAS) FROM PROY1030 WHERE numProyecto = 10;
SELECT NombreProyecto , NumProyecto, SUM(HORAS) FROM PROY1030 WHERE numProyecto = 30;


-- 10. Crea una vista en la que se muestre el número de horas totales trabajadas en cada proyecto. Muestra el número y nombre de proyecto, así como horas totales trabajadas

CREATE VIEW HRS_PROY AS SELECT NUMPROYECTO, NOMBREPROYECTO, SUM(HORAS) FROM PROYECTO INNER JOIN TRABAJA_EN ON NUMPROYECTO=NUMPROY GROUP BY NUMPROYECTO;

SELECT NumProyecto, NombreProyecto, TRABAJA_EN.Horas, SUM(Horas) from PROYECTO INNER JOIN TRABAJA_EN  ON PROYECTO.numProyecto = TRABAJA_EN.numProy;

--Vista proy3
 CREATE VIEW PROY3 AS SELECT NOMBRE, APELLIDOUNO, APELLIDODOS, trabaja_en.NumProy FROM empleado INNER JOIN trabaja_en ON empleado.dni = trabaja_en.DniEmpleado WHERE trabaja_en.NumProy in(30,3);
