
/*AREA 2*/
/*Casi todos los problemas que he tenido a la hora de realizar esta tarea han sido*/
/*Tener claro qué variables relacionar*/
/*Saber cómo seleccionar las cosas*/
/*Saber cómo escribir las cosas: entre paréntesis, entre comillas...*/
/*Identificar cuándo estaba el vehículo de alta o no*/
/*No tengo ni idea de cuándo usar JOIN*/

/*1*/
SELECT nombre, plazas FROM modelo;

/*2*/
SELECT DISTINCT provincia FROM persona ORDER BY 1 ASC;

/*3*/
SELECT * FROM persona WHERE provincia='CORDOBA' ORDER BY 2,3;

/*4*/
SELECT matricula, propietario FROM vehiculo WHERE modelo=10007 ORDER BY 2;

/*5*/
SELECT DISTINCT alta, baja FROM vehiculo WHERE matricula<'0050AA' ORDER BY 1,2;
SELECT DISTINCT alta, baja FROM vehiculo WHERE matricula<'0050AAA' ORDER BY alta,baja;

/*6*/
SELECT nombre FROM fabricante WHERE provincia BETWEEN 'ALAVA' AND 'BARCELONA';

/*7*/ 

SELECT DISTINCT fabricante, plazas ;
/*NO ES CÓDIGO SINO FABRICANTE FROM modelo WHERE fabricante= 'B22222222' OR fabricante='B66666666' OR fabricante='B88888888'*/

/*FORMA CORRECTA DE HACERLO*/

SELECT DISTINCT fabricante, plazas /*NO ES CÓDIGO SINO FABRICANTE*/
FROM modelo 
WHERE fabricante IN ('B22222222','B66666666','B88888888');

/*8*/ 
/*¿?¿?¿?*/
/*Sale pero teniendo que usar UNION. ¿Cómo hacerlo sin unión?*/
SELECT DISTINCT provincia FROM persona WHERE provincia LIKE '%TL%' UNION SELECT DISTINCT provincia FROM persona WHERE provincia LIKE '%T_L%' UNION SELECT DISTINCT provincia FROM persona WHERE provincia LIKE '%T%L%';

/*FORMA CORRECTA DE HACERLO*/
SELECT DISTINCT provincia FROM persona WHERE provincia LIKE '%T%L%';
/*'%T%L%' = este incluye '%T_L%','%TL%'*/

/*9*/
/*¿HAY ALGUNA FORMA DE NO TENER QUE UTILIZAR EL COMANDO 'UNION'?*/
SELECT DISTINCT nombre FROM persona WHERE nombre LIKE 'MARIA' UNION SELECT DISTINCT nombre FROM persona WHERE nombre LIKE  'MARIA %' UNION SELECT DISTINCT nombre FROM persona WHERE nombre LIKE  '% MARIA';

/*Otra posibilidad*/
 SELECT DISTINCT nombre FROM persona WHERE nombre LIKE  'MARIA' OR nombre LIKE '% MARIA' OR nombre LIKE 'MARIA %';
 /*en el primer like puede omitirse y ponerse un = porque no es un patrón sino una constante*/
 /*Aquí solo queremos cualquier nombre compuesto con María*/
 
/*10*/
SELECT matricula,alta FROM vehiculo WHERE baja IS NULL;

/*11*/
/*MAL, SE ME HA OLVIDADO PONER EL NOT*/
SELECT DISTINCT alta FROM vehiculo WHERE baja IS NULL ORDER BY 1;

/*CORRECTO*/
SELECT DISTINCT alta FROM vehiculo WHERE baja IS NOT NULL ORDER BY 1;

/*12*/
/*No están en la misma columna*/
SELECT modelo.nombre,fabricante.nombre FROM modelo, fabricante WHERE modelo.fabricante=fabricante.cif;

¿Cómo se unen en una misma columna?
SELECT CONCAT (modelo.nombre,fabricante.nombre) FROM modelo, fabricante WHERE modelo.fabricante=fabricante.cif;

¿Cómo se ponen en orden ascendente?
SELECT CONCAT (modelo.nombre,fabricante.nombre) FROM modelo, fabricante WHERE modelo.fabricante=fabricante.cif ORDER BY 1 ASC;

/*FORMA CORRECTA DE HACERLO (en el anterior no se ponen en la misma columna sino en una misma celda)*/
SELECT nombre FROM modelo UNION SELECT nombre FROM fabricante ORDER BY 1;


/*13*/ 
/*Creo que no he seleccionado bien los campos y por eso no me salen valores nulos.*/
/*13) Nombre de las provincias en las que no existe una fabrica de automóviles, ordenadas de mayor a menor (PERSONA y FABRICANTE)*/

SELECT persona.provincia, fabricante.nombre FROM persona,fabricante WHERE persona.provincia=fabricante.provincia;
SELECT persona.provincia, fabricante.nombre FROM persona,fabricante ///WHERE persona.provincia=fabricante.provincia, fabricante.provincia IS NULL//// ORDER BY DES ;

/*FORMA CORRECTA DE HACERLO: USANDO EL COMANDO MINUS*/
SELECT provincia FROM persona MINUS SELECT provincia FROM fabricante ORDER BY 1 DESC;
/*El 1 va siempre*/
/*En caso de haber puesto distinct hubiese eliminado duplicados en la respuesta, pero sale igual de bien igualmente porque no da la casualidad*/

/*14*/
SELECT fabricante.nombre, modelo.nombre FROM fabricante, modelo WHERE cif=fabricante AND plazas='2';
/*Otra forma de hacerlo*/
SELECT fabricante.nombre, modelo.nombre FROM fabricante JOIN modelo ON cif=fabricante WHERE plazas='2';


/*15
15) Nombre distinto de los modelos de vehículos que corresponden con el nombre de una provincia
existente (MODELO y PERSONA)*/

SELECT DISTINCT modelo.nombre FROM persona, modelo WHERE modelo.nombre=provincia;
/*OTRA FORMA DE HACERLO*/
SELECT DISTINCT modelo.nombre FROM modelo JOIN persona ON modelo.nombre=provincia;

/*16
(Aquí he estado fallando en la asignación de claves primarias en el apartado WHERE)
16) Matrícula del vehículo, número de plazas y nombre, apellidos y provincia de su propietario para
aquellos propietarios cuya provincia contiene la cadena ‘AL’, ordenado por provincia y matrícula
(VEHICULO, MODELO y PERSONA);*/

SELECT matricula, plazas, persona.nombre, apellidos, provincia 
FROM vehiculo, modelo, persona
WHERE propietario=nif AND codigo=modelo
AND provincia LIKE '%AL%' ORDER BY 5,1;
/*UNA VEZ TERMINE EL EJERCICIO VOLVER A RELEER EL UNUNCIADO PARA COMPROBAR QUE HE RESPONDIDO BIEN*/

/*Otra forma de hacerlo*/
SELECT matricula, plazas, persona.nombre, apellidos, provincia 
FROM vehiculo 
JOIN modelo ON (codigo=modelo)
JOIN persona ON propietario=nif 
WHERE provincia 
LIKE '%AL%' 
ORDER BY 5,1;

/*17*/ 
/*MAL SE ME HA OLVIDADO METER EL NÚMERO DE PLAZAS*/
SELECT matricula, fabricante.nombre, modelo.nombre 
FROM vehiculo, modelo, fabricante 
WHERE codigo=modelo 
AND cif=fabricante 
AND baja IS NOT NULL 
AND fabricante.provincia IN ('AVILA','NAVARRA');

/*Así me sale correcto*/
SELECT matricula, fabricante.nombre, modelo.nombre 
FROM vehiculo, modelo, fabricante 
WHERE codigo=modelo 
AND cif=fabricante 
AND baja IS NOT NULL 
AND fabricante.provincia IN ('AVILA','NAVARRA')
AND PLAZAS<=4;

/*Otra forma de hacerlo*/
SELECT matricula, fabricante.nombre, modelo.nombre 
FROM vehiculo
JOIN modelo ON codigo=modelo
JOIN fabricante ON cif=fabricante 
WHERE baja IS NOT NULL 
AND plazas<=4
AND provincia IN ('AVILA','NAVARRA');

/*18 
18) Nombre y apellidos distintos de los propietarios que tienen en activo (baja tiene valor nulo) un;
vehículo y viven en la misma provincia que el fabricante cuyo nombre es ‘RENAULT’;
(PERSONA, VEHICULO y FABRICANTE)*/

SELECT DISTINCT persona.nombre, apellidos
FROM persona, vehiculo, fabricante 
WHERE nif=propietario 
AND baja IS NULL 
AND fabricante.nombre='RENAULT'
AND fabricante.provincia=persona.provincia;

/*OTRA FORMA DE HACERLO*/
SELECT DISTINCT persona.nombre, apellidos
FROM persona 
JOIN VEHICULO ON (propietario=nif)
JOIN fabricante ON (persona.provincia=fabricante.provincia)
WHERE baja IS NULL 
AND fabricante.nombre='RENAULT' ;

/*19 ¿¿CÓMO ELABORARLO?? ¿¿JOIN??
19) Nombre y apellidos de las personas que viven en la misma provincia que la persona de NIF
‘12466007G’, teniendo en cuenta que no debe aparecer esa persona en la respuesta (PERSONA dos
veces como autocomposición).*/

/*FORMA CORRECTA Y RÁPIDA*/
SELECT persona.nombre, persona.apellidos
FROM persona dis, persona
WHERE dis.nif='12466007G' 
AND dis.provincia=persona.provincia
AND persona.nif <> '12466007G';

/*OTRA FORMA DE HACERLO*/
SELECT persona.nombre, persona.apellidos
FROM persona
JOIN persona p ON (persona.provincia=p.provincia)
WHERE p.nif='124660076'
and persona.nif<>'124660076';



/*COMPROBAR CON ESTO*/
SELECT persona.nombre, persona.apellidos
FROM persona 2, persona
WHERE 2.nif='12466007G' 
AND 2.provincia=persona.provincia
MINUS
SELECT persona.nombre, persona.apellidos
FROM persona 2, persona
WHERE persona.nif='12466007G';

/*PROBAR CUANDO FUNCIONE: DE ESTA MANERA SE SELECCIONA ÚNICAMENTE UNA PERSONA, PERO COMPROBAR*/
SELECT persona.nombre, persona.apellidos
FROM persona 2, persona
WHERE persona.nif='12466007G' 
AND 2.provincia=persona.provincia;


/*20
20) Datos distintos del nombre, apellidos y provincia de las personas que han comprado un vehículo
fabricado en su provincia de residencia y no lo han dado de baja, ordenados de forma descendente
por provincia, y de forma ascendente por apellidos y nombre (PERSONA, VEHICULO, MODELO,FABRICANTE);*/

SELECT DISTINCT persona.nombre, apellidos, persona.provincia
FROM persona, vehiculo, modelo, fabricante
WHERE  nif=propietario AND codigo=modelo
AND fabricante=cif
AND persona.provincia=fabricante.provincia
AND baja IS NULL
ORDER BY 3 DESC, 2,1 ASC; 

/*NO HACE FALTA PONER 'AND' ENTRE ASC Y DSC*/

/*OTRA FORMA DE HACERLO (COMPARARLO CON EL 18)*/
SELECT DISTINCT persona.nombre, apellidos, persona.provincia
FROM persona JOIN vehiculo ON(propietario=nif)
JOIN modelo ON (modelo=codigo)
JOIN fabricante ON (fabricante=cif)
WHERE persona.provincia=fabricante.provincia AND baja is NULL
ORDER BY provincia DES, apellidos, nombre;

/*PROBAR SI FUNCIONACON ESTO*/
SELECT DISTINCT persona.nombre, apellidos, persona.provincia
FROM persona, vehiculo, modelo, fabricante
WHERE  nif=propietario AND codigo=modelo
AND fabricante=cif
AND persona.provincia=fabricante.provincia
AND alta IS NOT NULL
ORDER BY 3 DSC AND 1,2 ASC;















