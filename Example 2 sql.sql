1) Nombre y número de plazas de los modelos de vehículos (MODELO).
2) Provincias distintas donde viven las personas ordenadas alfabéticamente en orden ascendente
(PERSONA).
3) Todos los datos de las persona que viven en la provincia de ‘CORDOBA’ ordenados por
apellidos y nombre (PERSONA).
4) Matrícula y propietario de los vehículos cuyo modelo es el 10007, ordenado por propietario
(VEHICULO).
5) Fechas distintas de alta y baja de los vehículos cuya matrícula es anterior a la matrícula
‘0050AAA’, ordenadas por alta y baja (VEHICULO).
6) Nombres de los fabricantes cuyo nombre de provincia está comprendido entre ‘ALAVA’ y
‘BARCELONA’ (FABRICANTE).
7) CIF del fabricante y número de plazas distintas de los modelos cuyos fabricantes son los CIFs
‘B22222222’, ‘B66666666’ y ‘B88888888’ (MODELO).
8) Provincias distintas que contienen la letra T y después la letra L, no teniendo porque estar
consecutivas ambas letras (PERSONA).
9) Nombres distintos de los propietarios de vehículos en los que el nombre es MARIA o un nombre
compuesto utilizando MARIA como puede ser MARIA JOSE o JOSE MARIA, teniendo en cuenta
que no deben aparecer en la respuesta nombres como MARIANO (PERSONA).
10) Matrícula de los vehículos y fecha de alta de los vehículos que no han sido dados de baja (baja
con valor nulo) (VEHICULO).
11) Fechas distintas de alta de los vehículos que han sido dados de baja (baja con valor no nulo),
ordenados por fecha de alta (VEHICULO).
12) Nombre de los modelos (C1, C2, etc.) unido al nombre de los fabricantes (SEAT, FORD, etc.),
ordenado ascendentemente. Nota, la salida es una única columna con el nombre de los modelos y
fabricantes. (MODELO y FABRICANTE).
13) Nombre de las provincias en las que no existe una fabrica de automóviles, ordenadas de mayor
a menor (PERSONA y FABRICANTE).
14) Nombre de los fabricantes y de los modelos de dos plazas (FABRICANTE y MODELO).
15) Nombre distinto de los modelos de vehículos que corresponden con el nombre de una provincia
existente (MODELO y PERSONA).
16) Matrícula del vehículo, número de plazas y nombre, apellidos y provincia de su propietario para
aquellos propietarios cuya provincia contiene la cadena ‘AL’, ordenado por provincia y matrícula
(VEHICULO, MODELO y PERSONA).
17) Matrícula, nombre del fabricante y nombre del modelo de los vehículos de cuatro plazas o
menos que han sido dados de baja (baja tiene un valor no nulo) y han sido fabricados en la
provincia de ‘AVILA’ o ‘NAVARRA’ (VEHICULO, MODELO, FABRICANTE).
18) Nombre y apellidos distintos de los propietarios que tienen en activo (baja tiene valor nulo) un
vehículo y viven en la misma provincia que el fabricante cuyo nombre es ‘RENAULT’
(PERSONA, VEHICULO y FABRICANTE).
19) Nombre y apellidos de las personas que viven en la misma provincia que la persona de NIF
‘12466007G’, teniendo en cuenta que no debe aparecer esa persona en la respuesta (PERSONA dos
veces como autocomposición).
20) Datos distintos del nombre, apellidos y provincia de las personas que han comprado un vehículo
fabricado en su provincia de residencia y no lo han dado de baja, ordenados de forma descendente
por provincia, y de forma ascendente por apellidos y nombre (PERSONA, VEHICULO, MODELO,
FABRICANTE).

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
SELECT DISTINCT fabricante, plazas /*NO ES CÓDIGO SINO FABRICANTE*/
FROM modelo 
WHERE fabricante IN ('B22222222','B66666666','B88888888');

/*8*/ 
SELECT DISTINCT provincia FROM persona WHERE provincia LIKE '%T%L%';
/*'%T%L%' = este incluye '%T_L%','%TL%'*/

/*9*/
SELECT DISTINCT nombre FROM persona WHERE nombre LIKE 'MARIA' UNION SELECT DISTINCT nombre FROM persona WHERE nombre LIKE  'MARIA %' UNION SELECT DISTINCT nombre FROM persona WHERE nombre LIKE  '% MARIA';

 SELECT DISTINCT nombre FROM persona WHERE nombre LIKE  'MARIA' OR nombre LIKE '% MARIA' OR nombre LIKE 'MARIA %';
 /*en el primer like puede omitirse y ponerse un = porque no es un patrón sino una constante*/
 /*Aquí solo queremos cualquier nombre compuesto con María*/
 
/*10*/
SELECT matricula,alta FROM vehiculo WHERE baja IS NULL;

/*11*/
SELECT DISTINCT alta FROM vehiculo WHERE baja IS NOT NULL ORDER BY 1;

/*12*/
SELECT nombre FROM modelo UNION SELECT nombre FROM fabricante ORDER BY 1;


/*13*/ 
SELECT provincia FROM persona MINUS SELECT provincia FROM fabricante ORDER BY 1 DESC;
/*El 1 va siempre*/
/*En caso de haber puesto distinct hubiese eliminado duplicados en la respuesta, pero sale igual de bien igualmente porque no da la casualidad*/

/*14*/
SELECT fabricante.nombre, modelo.nombre FROM fabricante, modelo WHERE cif=fabricante AND plazas='2';
/*Otra forma de hacerlo*/
SELECT fabricante.nombre, modelo.nombre FROM fabricante JOIN modelo ON cif=fabricante WHERE plazas='2';


/*15*/
SELECT DISTINCT modelo.nombre FROM persona, modelo WHERE modelo.nombre=provincia;
/*OTRA FORMA DE HACERLO*/
SELECT DISTINCT modelo.nombre FROM modelo JOIN persona ON modelo.nombre=provincia;

/*16*/
SELECT matricula, plazas, persona.nombre, apellidos, provincia 
FROM vehiculo 
JOIN modelo ON (codigo=modelo)
JOIN persona ON propietario=nif 
WHERE provincia 
LIKE '%AL%' 
ORDER BY 5,1;

/*17*/ 
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

/*18*/

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

/*19*/
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

/*20*/
SELECT DISTINCT persona.nombre, apellidos, persona.provincia
FROM persona, vehiculo, modelo, fabricante
WHERE  nif=propietario AND codigo=modelo
AND fabricante=cif
AND persona.provincia=fabricante.provincia
AND baja IS NULL
ORDER BY 3 DESC, 2,1 ASC; 

/*OTRA FORMA DE HACERLO (COMPARARLO CON EL 18)*/
SELECT DISTINCT persona.nombre, apellidos, persona.provincia
FROM persona JOIN vehiculo ON(propietario=nif)
JOIN modelo ON (modelo=codigo)
JOIN fabricante ON (fabricante=cif)
WHERE persona.provincia=fabricante.provincia AND baja is NULL
ORDER BY provincia DES, apellidos, nombre;
















