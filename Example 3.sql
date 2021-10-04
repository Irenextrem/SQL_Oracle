1) Menor nombre, mayor nombre, menor apellido y mayor apellido de las personas.
2) Número de modelos de dos plazas que están a la venta.
3) Número de vehículos que no han sido dados de baja (campo baja con valor nulo).
4) Número de plazas totales de los vehículos que han sido matriculados y están dados de baja
(campo baja con valor no nulo).
5) Número distinto de provincias en las que viven los propietarios de vehículos de dos plazas.
6) Número total de vehículos matriculados en las provincias de MADRID, BARCELONA o
VALENCIA (contar los vehículos matriculados en las tres provincias) y que no han sido dados de
baja.
7) Provincia y número de personas que viven en la misma provincia que un fabricante de vehículos,
ordenado por el número de personas en orden descendente y por provincia en orden ascendente.
8) Nombre del fabricante, nombre del modelo y número de vehículos matriculados de cada modelo
que no permanecen en activo (campo baja con valor no nulo), ordenados de mayor a menor número.
9) Nombre del fabricante y del modelo, y número de vehículos matriculados para aquellos modelos
de los que la suma de sus plazas sea mayor de 1200 plazas, ordenados de mayor a menor número.
10) Nombre y apellidos de las persona, nombre de la marca, y número de vehículos de aquellas
personas que han comprado más de 5 vehículos de una misma marca.
11) Nombre y apellidos de las personas que viven en la misma provincia que la persona de NIF
12413000J. En la respuesta no debe aparecer la propia persona. (Utilizar una subconsulta y no una
autocomposición).
12) Todos los datos de las personas que nunca han tenido un vehículo matriculado.
13) Todos los datos de las personas que alguna vez han tenido matriculado algún vehículo y en la
actualidad todos están dado de baja.
14) Nombre distinto del fabricante, del modelo y de la provincia donde se ha vendido algún modelo
y actualmente todos los vehículos de ese modelo están dados de baja.
15) Nombre de los fabricantes que han vendido menos vehículos que el fabricante de nombre
'SEAT'.
16) Nombre y apellidos de las personas que han comprado como mínimo un vehículo de cada
fabricante.
17) Datos de las personas que han comprado más de un vehículo y todos los vehículos son del
mismo fabricante.
18) Provincia en la que viven el menor número de personas.
19) Nombre del fabricante y número de vehículos vendidos por el fabricante del que se ha
matriculado el mayor número de plazas.
20) Nombre de los fabricantes, nombre de los modelos y número de provincias en que se ha
vendido un modelo, para aquellos modelos que se ha vendido en el menor número de provincias.
Máster en

/*1*/
SELECT MIN(nombre),MAX(nombre), MIN(apellidos), MAX(apellidos) 
FROM persona;

/*2*/
SELECT COUNT(codigo)
FROM  modelo
WHERE plazas=2;

/*3*/
SELECT COUNT(matricula)
FROM vehiculo
WHERE baja IS NULL;

/*4*/
SELECT SUM(plazas)
FROM modelo, vehiculo
WHERE modelo=codigo 
AND baja IS NOT NULL;

/*5*/
SELECT COUNT(DISTINCT provincia)
FROM persona, vehiculo, modelo
WHERE nif=propietario
AND modelo=codigo
AND plazas=2;

/*6*/
SELECT COUNT(matricula)
FROM vehiculo, persona
WHERE nif=propietario
AND baja IS NULL
AND provincia IN('MADRID','VALENCIA','BARCELONA');

/*7*/
SELECT provincia, COUNT(*)
FROM persona 
WHERE provincia IN 
(SELECT provincia FROM fabricante)
GROUP BY provincia
ORDER BY 2 DESC, 1 ASC;


/*8*/
SELECT fabricante.nombre, modelo.nombre, COUNT(matricula)
FROM fabricante
JOIN modelo ON (fabricante=cif)
JOIN vehiculo ON (modelo=codigo)
WHERE vehiculo.baja IS NOT NULL
GROUP BY fabricante.nombre, modelo.nombre
ORDER BY 3 DESC;

/*9*/
SELECT fabricante.nombre, modelo.nombre, COUNT(matricula)
FROM fabricante
JOIN modelo ON (fabricante=cif)
JOIN vehiculo ON (modelo=codigo)
GROUP BY fabricante.nombre, modelo.nombre
HAVING SUM(plazas)>1200
ORDER BY 3 DESC;

/*10*/
SELECT persona.nombre, apellidos, fabricante.nombre, COUNT(matricula)
FROM persona
JOIN vehiculo ON nif=propietario
JOIN modelo ON modelo=codigo
JOIN fabricante ON fabricante=cif
GROUP BY persona.nombre, apellidos, fabricante.nombre
HAVING SUM(fabricante.nombre)>5;

/*11*/
SELECT persona.nombre, persona.apellidos
FROM persona, persona dis
WHERE dis.provincia=persona.provincia
AND  dis.nif='12413000J' 
AND persona.nif <> 
(SELECT dis.nif
FROM persona dis
WHERE nif='12413000J');

/*12*/
SELECT nif, nombre, apellidos, provincia
FROM persona
LEFT JOIN vehiculo ON nif=propietario
WHERE nif NOT IN
(SELECT propietario
FROM vehiculo);


/*13*/
SELECT nif, nombre, apellidos, provincia
FROM persona
JOIN vehiculo ON nif=propietario
WHERE nif IN (SELECT propietario FROM vehiculo)
GROUP BY nif, nombre, apellidos, provincia
HAVING COUNT(matricula)=COUNT(baja);


/*14*/
SELECT DISTINCT fabricante.nombre, modelo.nombre, persona.provincia
FROM persona
JOIN vehiculo ON nif=propietario
JOIN modelo ON modelo=codigo
JOIN fabricante ON fabricante=cif
WHERE nif IN (SELECT propietario FROM vehiculo)
GROUP BY fabricante.nombre, modelo.nombre, persona.provincia
HAVING COUNT(matricula)=COUNT(baja);

/*15*/
SELECT fabricante.nombre, COUNT(propietario)
FROM fabricante
JOIN modelo ON cif=fabricante
JOIN vehiculo ON codigo=modelo
GROUP BY fabricante.nombre
HAVING COUNT(propietario)<
(SELECT COUNT(propietario)
FROM fabricante
JOIN modelo ON cif=fabricante
JOIN vehiculo ON codigo=modelo
WHERE fabricante.nombre='SEAT');

/*16*/
/*CONSULTA 1: Personas y el número de fabricantes a los que les han comprado*/
SELECT COUNT( DISTINCT fabricante.nombre),persona.nombre, apellidos
FROM fabricante
JOIN modelo ON fabricante=cif
JOIN vehiculo ON modelo=codigo
JOIN persona ON propietario=nif
GROUP BY persona.nombre, apellidos;

/*CONSULTA 2: Número de fabricantes totales que hay*/
SELECT COUNT(nombre)
FROM fabricante;

/*CONSULTA 3: JUNTAR LAS ANTERIORES*/
SELECT COUNT( DISTINCT fabricante.nombre),persona.nombre, apellidos
FROM fabricante
JOIN modelo ON fabricante=cif
JOIN vehiculo ON modelo=codigo
JOIN persona ON propietario=nif
GROUP BY persona.nombre, apellidos
HAVING COUNT( DISTINCT fabricante.nombre)='8' ;

/*QUE ES LO MISMO A*/
SELECT COUNT( DISTINCT fabricante.nombre),persona.nombre, apellidos
FROM fabricante
JOIN modelo ON fabricante=cif
JOIN vehiculo ON modelo=codigo
JOIN persona ON propietario=nif
GROUP BY persona.nombre, apellidos
HAVING COUNT( DISTINCT fabricante.nombre)=
(SELECT COUNT(nombre)FROM fabricante);

/*Resolver ejercicio*/
SELECT persona.nombre, apellidos
FROM fabricante
JOIN modelo ON fabricante=cif
JOIN vehiculo ON modelo=codigo
JOIN persona ON propietario=nif
GROUP BY persona.nombre, apellidos
HAVING COUNT( DISTINCT fabricante.nombre)=
(SELECT COUNT(nombre)FROM fabricante);
/*Ojito conmigo*/

/*17*/
/*Datos de las personas que han comprado más de un vehículo y todos los vehículos son del
mismo fabricante.*/

/*COMPROBACIÓN 1: Personas y el número de fabricantes a los que les han comprado*/
SELECT COUNT( DISTINCT fabricante.nombre),persona.nombre, apellidos
FROM fabricante
JOIN modelo ON fabricante=cif
JOIN vehiculo ON modelo=codigo
JOIN persona ON propietario=nif
GROUP BY persona.nombre, apellidos;

/*COMPROBACIÓN 2:Personas que solo le han comprado a un fabricante*/
SELECT persona.nombre, apellidos
FROM persona
JOIN vehiculo ON propietario=nif
JOIN modelo ON modelo=codigo
GROUP BY persona.nombre, apellidos
HAVING COUNT(DISTINCT fabricante)=1;
/*Poniendo distinct me aseguro de que solo va a contar fabricantes diferentes y no repetidos*/

/*89 personas les han comprado solo a un fabricante*/


/*EJEMPLO SIN DISTINCT*/
SELECT persona.nombre, apellidos, COUNT(fabricante)
FROM persona
JOIN vehiculo ON propietario=nif
JOIN modelo ON modelo=codigo
GROUP BY persona.nombre, apellidos
HAVING COUNT(DISTINCT fabricante)=1;

/*Me suma el mismo fabricante varias veces y la condición que he puesto es 
que sea el mismo*/

/*COMPROBACIÓN 3:Personas que tienen más de un vehículo*/
SELECT nombre
FROM persona
JOIN vehiculo ON nif=propietario
GROUP BY nombre
HAVING COUNT(matricula)<>1;

/*JUNTO AMBAS Y RESUELVO*/
SELECT persona.nombre, apellidos, nif, provincia
FROM persona
JOIN vehiculo ON propietario=nif
JOIN modelo ON modelo=codigo
GROUP BY persona.nombre, apellidos, nif, provincia
HAVING COUNT(DISTINCT fabricante)=1 AND COUNT(matricula)<>1;


/*18*/
/*Provincia en la que viven el menor número de personas.*/

/*COMPROBACIÓN 1:Provincias y personas en esas provincias*/
SELECT COUNT(provincia), provincia
FROM persona
GROUP BY provincia
ORDER BY 1 ASC;
/*Tiene que salir Albacete*/

/*COMPROBACIÓN 2*/
SELECT provincia
FROM persona
GROUP BY provincia 
HAVING COUNT(provincia)= '24';

/*COMPROBACIÓN 3:*/
SELECT MIN(COUNT(provincia))
FROM persona
GROUP BY provincia;

/*PRUEBA 1*/
SELECT provincia
FROM persona
GROUP BY provincia 
HAVING COUNT(provincia)= 
(SELECT MIN(COUNT(provincia))
FROM persona
GROUP BY provincia);

/*Puedo hacer varios sumatorios juntos --> MIN(count()).
/*A pesar de que no aparezcan más columnas puedo agrupar en GROUP BY*/

/*19*/

/*Por partes*/
/*COMPROBACIÓN 1:Nombre de los fabricante y número de vehículos vendidos por ellas*/
SELECT fabricante.nombre, COUNT(matricula)*/
FROM fabricante
JOIN modelo ON cif=fabricante
JOIN vehiculo ON modelo=codigo
GROUP BY fabricante.nombre
ORDER BY 2 DESC;

/*Así compruebo que es RENAULT 1848 quien tiene más vehículos matriculados*/

/*Saco el fabricante que más vehículos vendidos tiene*/
SELECT fabricante.nombre,MAX(COUNT(matricula))
FROM fabricante
JOIN modelo ON cif=fabricante
JOIN vehiculo ON modelo=codigo
GROUP BY fabricante.nombre;
/*No me sale así el que tiene más vehículos-->¿Cómo lo saco?*/

/*CONSULTA 2:Fabricantes y la suma de su número de plazas*/
/*¿Seria lo mismo que las plazas matrículadas?*/
SELECT fabricante.nombre, SUM(plazas)
FROM fabricante
JOIN modelo ON cif=fabricante
JOIN vehiculo ON modelo=codigo
GROUP BY fabricante.nombre
ORDER BY 2 DESC;
/*Renault es el que más plazas tiene 9231*/
SELECT MAX(SUM(plazas))
FROM fabricante, vehiculo, modelo
WHERE modelo=codigo AND fabricante=cif
GROUP BY fabricante.nombre;

/*SALE DIFERENTE A ESTO*/
SELECT fabricante,SUM(plazas) FROM modelo GROUP BY fabricante ORDER BY 2 DESC;

/*Renault es el que más plazas tiene 45*/
/*¿Cuál es la diferencia entre ambas?*/

/*Seleccionar el nombre vendedor con más plazas*/
SELECT DISTINCT fabricante.nombre 
FROM fabricante 
JOIN modelo ON cif=fabricante
WHERE fabricante=
(SELECT fabricante FROM modelo 
GROUP BY fabricante HAVING SUM(plazas)= 
(SELECT MAX(SUM(plazas))FROM modelo GROUP BY fabricante));
/*Soy la puta ama*/
/*GROUP BY va detrás de WHERE*/

/*Ahora me meto con la consulta entera*/
SELECT fabricante.nombre, COUNT(matricula)
FROM fabricante
JOIN modelo ON fabricante=cif
JOIN vehiculo ON codigo=modelo
WHERE fabricante.nombre=
(SELECT DISTINCT fabricante.nombre FROM fabricante JOIN modelo ON cif=fabricante WHERE fabricante=
(SELECT fabricante FROM modelo GROUP BY fabricante HAVING SUM(plazas)= 
(SELECT MAX(SUM(plazas))FROM modelo GROUP BY fabricante)))
GROUP BY fabricante.nombre;
/*En esta no estoy incluyendo los que están matriculados*/

SELECT fabricante.nombre, COUNT(matricula)
FROM fabricante
JOIN modelo ON fabricante=cif
JOIN vehiculo ON codigo=modelo
GROUP BY fabricante.nombre
HAVING SUM(plazas) = (SELECT MAX(SUM(plazas))
FROM fabricante, vehiculo, modelo
WHERE modelo=codigo AND fabricante=cif
GROUP BY fabricante.nombre);
/*oLÉ*/
/*Condicionar al número de plazas y mostrar el número de vehículos*/
/*Número de plazas sería la subconsulta que condiciona al número
de vehículos matriculados a mostrar*/


/*20*/
/*Nombre de los fabricantes, nombre de los modelos y número de provincias en que se ha
vendido un modelo, para aquellos modelos que se ha vendido en el menor número de provincias.*/

/*General*/
SELECT fabricante.nombre, modelo.nombre, COUNT(persona.provincia)
FROM fabricante
JOIN modelo ON fabricante=cif
JOIN vehiculo ON codigo=modelo
JOIN persona ON propietario=nif;

/*COMPROBACIÓN 1:Nombre de los modelos que se han vendido en UNA provincia (UNO SOLO)*/
SELECT modelo.nombre
FROM persona
JOIN vehiculo ON nif=propietario
JOIN modelo ON modelo=codigo
GROUP BY persona.provincia, modelo.nombre
HAVING COUNT(persona.provincia)=1
ORDER BY 1 ASC;

/*COMPROBACIÓN 2: Modelos que se han vendido en cada provincia*/
/*Número de provincias totales*/
SELECT COUNT(DISTINCT provincia)
FROM persona;

SELECT COUNT(DISTINCT provincia), modelo
FROM persona
JOIN vehiculo ON nif=propietario
GROUP BY modelo
ORDER BY 1,2;

/*Salen los modelos 10007,20007 y 70003 que se han vendido en 46 provincias*/

/*COMPROBACIÓN 3: Modelos vendidos en menor número de provincias*/
SELECT modelo
FROM vehiculo
JOIN persona ON nif=propietario
GROUP BY modelo 
HAVING COUNT(DISTINCT provincia)=
(SELECT MIN(COUNT(DISTINCT provincia)) FROM persona JOIN vehiculo ON nif=propietario GROUP BY modelo);

/*Consulta final*/
SELECT fabricante.nombre, modelo.nombre, COUNT( DISTINCT persona.provincia)
FROM fabricante
JOIN modelo ON fabricante=cif
JOIN vehiculo ON codigo=modelo
JOIN persona ON propietario=nif
GROUP BY fabricante.nombre, modelo.nombre
HAVING COUNT(DISTINCT persona.provincia)=(SELECT MIN(COUNT(DISTINCT persona.provincia)) FROM persona JOIN vehiculo ON nif=propietario GROUP BY modelo);

WHERE modelo.nombre= (SELECT modelo.nombre
FROM persona
JOIN vehiculo ON nif=propietario
JOIN modelo ON modelo=codigo
GROUP BY persona.provincia, modelo.nombre
HAVING COUNT(DISTINCT persona.provincia)=1);





