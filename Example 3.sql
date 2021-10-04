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
/*PRUEBA 1*/
/*Estoy contando distintos contajes*/
SELECT DISTINCT COUNT(provincia)
FROM persona, vehiculo, modelo
WHERE nif=propietario
AND modelo=codigo
AND plazas=2;

/*Número total de provincias*/
SELECT COUNT(provincia) FROM persona;

/*PRUEBA 2*/
/*En la anterior me he equivocado debido a que no he 
interpretad el enunciado al pie de la letra y he 
cambiado el orden de count y distinct.
Número distinto, no distinto número*/
SELECT COUNT(DISTINCT provincia)
FROM persona, vehiculo, modelo
WHERE nif=propietario
AND modelo=codigo
AND plazas=2;

/*6*/
/*PRUEBA 1*/
/*Los coches se matriculan en el sitio en el que se compran,
por lo que hay que relacionarlos con la provincia de el propietario.
Aquí he relacionado con el fabricante y no es correcta la respuesta*/
SELECT COUNT(matricula), provincia
FROM vehiculo, fabricante, modelo
WHERE modelo=codigo AND fabricante=cif
AND  baja IS NULL
AND provincia IN ('MADRID','VALENCIA','BARCELONA')
GROUP BY provincia;

/*PRUEBA 2*/
/*De esta manera obtengo la cantidad de vehículos 
matriculados en cada provincia (USANDO GROUP BY).

NO ES NECESARIO TENER UNA SONSULTA SUMATORIA EN SELECT
PARA USAR GROUP BY

Con el comando 'IN' no hace falta que esté usando x= AND,
es mucho más rápido y efectivo*/
SELECT COUNT(matricula)
FROM vehiculo, persona
WHERE nif=propietario
AND baja IS NULL
AND provincia IN('MADRID','VALENCIA','BARCELONA')
GROUP BY provincia;


/*PRUEBA 3*/
SELECT COUNT(matricula)
FROM vehiculo, persona
WHERE nif=propietario
AND baja IS NULL
AND provincia IN('MADRID','VALENCIA','BARCELONA');

/*7*/
/*PRUEBA 1*/
SELECT persona.provincia, COUNT(nombre)
FROM persona,vehiculo, modelo, fabricante
WHERE nif=propietario AND modelo=codigo AND fabricante=cif
AND persona.provincia=fabricante.provincia
ORDER BY 2 DESC,1 ASC;

/*PRUEBA 2 (+distinct)*/
SELECT DISTINCT persona.provincia, COUNT(nombre)
FROM persona,vehiculo, modelo, fabricante
WHERE nif=propietario AND modelo=codigo AND fabricante=cif
AND persona.provincia=fabricante.provincia
ORDER BY 2 DESC,1 ASC;

/*PRUEBA 3 (sin relacionar)*/
SELECT persona.provincia, COUNT(nif)
FROM persona, fabricante
WHERE persona.provincia=fabricante.provincia
ORDER BY 2 DESC, 1 ASC;


/*PRUEBA 4 (subconsulta1 con relaciones en subconsulta) */
SELECT persona.provincia, COUNT(nif)
FROM persona
WHERE persona.provincia =
(SELECT DISTINCT fabricante.provincia
FROM fabricante, persona,vehiculo, modelo
WHERE nif=propietario AND modelo=codigo
AND fabricante=cif)
ORDER BY 2 DESC, 1 ASC;


/*PRUEBA 5 (subconsulta1 con relaciones en consulta) */
SELECT persona.provincia, COUNT(nif)
FROM persona, vehiculo, modelo, fabricante
WHERE nif=propietario AND modelo=codigo
AND fabricante=cif
WHERE persona.provincia =
(SELECT DISTINCT fabricante.provincia
FROM fabricante)
ORDER BY 2 DESC, 1 ASC;


/*PRUEBA 6 (usando JOIN)*/
SELECT persona.provincia, COUNT(persona.nif)
FROM persona 
JOIN vehiculo ON(nif=propietario)
JOIN modelo ON (modelo=codigo)
JOIN fabricante ON (fabricante=cif)
WHERE persona.provincia=fabricante.provincia
ORDER BY 2 DESC, 1 ASC;

/*Prueba 7 (usando JOIN y DISTINCT)*/
SELECT DISTINCT persona.provincia, COUNT(persona.nif)
FROM persona 
JOIN vehiculo ON(nif=propietario)
JOIN modelo ON (modelo=codigo)
JOIN fabricante ON (fabricante=cif)
WHERE persona.provincia=fabricante.provincia
ORDER BY 2 DESC, 1 ASC;

/*PRUEBA 8 (GROUP BY)*/
/*¿Por qué no está bien? --> PREGUNTAR ENRIQUE*/
SELECT persona.provincia, COUNT(persona.nif)
FROM persona 
JOIN vehiculo ON(nif=propietario)
JOIN modelo ON (modelo=codigo)
JOIN fabricante ON (fabricante=cif)
WHERE persona.provincia=fabricante.provincia
GROUP BY persona.provincia
ORDER BY 2 DESC, 1 ASC;

/*PRUEBA 9 AIDA*/
/*La lógica es la siguiente:
IDEA PRINCIPAL: Provincias de personas que
están contenidas en las provincias de los fabricantes.
DIVIDO LA IDEA EN SUBCONSULTAS:
Subconsulta 1: Número de personas que viven 
en la misma provincia que el fabricante.
Subconsulta 2:Cuál es esa provincia. */

/*PREGUNTA:¿No es necesario relacionar
la tabla persona con la tabla fabricante?*/

SELECT provincia, COUNT(*)
FROM persona 
WHERE provincia IN 
(SELECT provincia FROM fabricante)
GROUP BY provincia
ORDER BY 2 DESC, 1 ASC;

/*Si le quito 'GROUP BY' en la subconsulta
me sale un error que me indica:"not a single-group group function"*/

/*8*/
/*PRUEBA 1 (USANDO JOIN)*/
SELECT fabricante.nombre, modelo.nombre, COUNT(matricula)
FROM fabricante
JOIN modelo ON (fabricante=cif)
JOIN vehiculo ON (modelo=codigo)
WHERE baja IS NOT NULL
ORDER BY 3;

/*PRUEBA 2 (USANDO JOIN Y AÑADO DISTINCT)*/
SELECT DISTINCT fabricante.nombre, DISTINCT modelo.nombre, COUNT(matricula)
FROM fabricante
JOIN modelo ON (fabricante=cif)
JOIN vehiculo ON (modelo=codigo)
WHERE vehiculo.baja IS NOT NULL
ORDER BY 3;

/*PRUEBA 2 (USANDO JOIN Y GROUP BY)*/
/*Cuando son consultas sumarias y hay más de dos 
columnas es necesario agrupar por GROUP BY porque 
sino sale un error de: "not a single-group group function"*/
SELECT fabricante.nombre, modelo.nombre, COUNT(matricula)
FROM fabricante
JOIN modelo ON (fabricante=cif)
JOIN vehiculo ON (modelo=codigo)
WHERE vehiculo.baja IS NOT NULL
GROUP BY fabricante.nombre, modelo.nombre
ORDER BY 3 DESC;

/*9*/
/*PRUEBA 1*/
SELECT fabricante.nombre, modelo.nombre, COUNT(matricula)
FROM fabricante
JOIN modelo ON (fabricante=cif)
JOIN vehiculo ON (modelo=codigo)
GROUP BY fabricante.nombre, modelo.nombre
HAVING SUM(plazas)>1200
ORDER BY 3 DESC;

/*10*/
/*PRUEBA 1*/
/*Como nombre de la marca se usa el del fabricante NO EL DEL MODELO.
Por lo que esto es erroneo.*/
SELECT persona.nombre, apellidos, modelo.nombre,COUNT(matricula)
FROM persona
JOIN vehiculo ON (nif=propietario)
JOIN modelo ON (modelo=codigo)
GROUP BY persona.nombre, apellidos, modelo.nombre
HAVING COUNT()>5;

/*Personas que han comprado más de 5 vehículos*/
SELECT nombre, apellidos, COUNT(matricula)
FROM persona, vehiculo
WHERE nif=propietario
GROUP BY nombre, apellidos
HAVING COUNT(modelo)>5;

/*PRUEBA 2*/
/*Personas que han comprado más de 5 vehículos del mismo modelo*/
/*No sé si he seleccionado bien con HAVING SUM*/
/*Cuando hablan de marca se refieren al fabricante*/
SELECT nombre, apellidos, modelo, COUNT(matricula)
FROM persona, vehiculo
WHERE nif=propietario
GROUP BY nombre,apellidos,modelo
HAVING SUM(modelo)>5;

/*Me sale que la matrícula tiene valor 1, por lo que está
mal planteada la consulta*/

/*PRUEBA 3 (CORRECTA)*/
/*Está planteada como la anterior pero poniendo bien el campo de 
nombre de la marca*/
SELECT persona.nombre, apellidos, fabricante.nombre, COUNT(matricula)
FROM persona
JOIN vehiculo ON nif=propietario
JOIN modelo ON modelo=codigo
JOIN fabricante ON fabricante=cif
GROUP BY persona.nombre, apellidos, fabricante.nombre
HAVING COUNT(fabricante.nombre)>5;

/*PRUEBA 4 (NO SE PUEDE USAR SUM PARA LETRAS ERROR)*/
SELECT persona.nombre, apellidos, fabricante.nombre, COUNT(matricula)
FROM persona
JOIN vehiculo ON nif=propietario
JOIN modelo ON modelo=codigo
JOIN fabricante ON fabricante=cif
GROUP BY persona.nombre, apellidos, fabricante.nombre
HAVING SUM(fabricante.nombre)>5;

/*11*/
/*PRUEBA 1*/
/*¿FORMA CORRECTA Y RÁPIDA? NO SUBCONSULTA*/
SELECT persona.nombre, persona.apellidos
FROM persona, persona dis
WHERE dis.provincia=persona.provincia
AND dis.nif='12413000J' 
AND persona.nif <>'12413000J';

/*PRUEBA 2 <> como subconsulta usando la misma tabla*/
SELECT persona.nombre, persona.apellidos
FROM persona, persona dis
WHERE dis.provincia=persona.provincia
AND  dis.nif='12413000J' 
AND persona.nif <> 
(SELECT dis.nif
FROM persona dis
WHERE nif='12413000J');

/*Me da lo mismo solo que una no es subconsulta
y la otra si lo es*/

/*12*/
/*Todos los datos de las personas que nunca han tenido un vehículo matriculado.*/

/*PRUEBA 1*/
/*¿Cómo seleccionar todos los datos de solo personas sin que se me 
incluyan los datos de vehículo?
RESPUESTA: Hago una subconsulta en donde pregunto por los datos
de los propietarios de los vehículos*/
/*¿No tengo muy claro por qué left join y no right join?*/
SELECT nif, nombre, apellidos, provincia
FROM persona
LEFT JOIN vehiculo ON nif=propietario
WHERE matricula IS NULL;+

/*PRUEBA 2*/
SELECT nif, nombre, apellidos, provincia
FROM persona
LEFT JOIN vehiculo ON nif=propietario
WHERE nif NOT IN
(SELECT propietario
FROM vehiculo);


/*13*/
/*PRUEBA 1*/
SELECT nif, nombre, apellidos, provincia
FROM persona
JOIN vehiculo ON nif=propietario
WHERE baja IS NOT NULL
AND matricula IS NULL;
/*¿No sé cómo mirar que el vehículo en
algún momento haya estado matriculado*/
/*Los propietarios que en algún momento han tenido un coche
han de aparecer en la base de datos vehículos*/

/*No sé cómo mirar que en la actualidad todos están dados de baja*/
/*Para mirar que todos estén dados de baja hay que comparar la cantidad
de vehiculos matriculados de esa personas con la cantidad de bajas
que tiene esas persona.
Esto se sustenta porque una persona puede tener varios coches, uno de
ellos dado de baja y el resto no. Por ello tengo que igualar ambos contajes.*/

/*PRUEBA 2*/
SELECT nif, nombre, apellidos, provincia
FROM persona
JOIN vehiculo ON nif=propietario
WHERE nif IN (SELECT propietario FROM vehiculo)
GROUP BY nif, nombre, apellidos, provincia
HAVING COUNT(matricula)=COUNT(baja);


/*14*/
/*PRUEBA 1*/
/*Considero que para que se haya vendido
ese modelo en vehículo debe de haber 
propietario*/

SELECT DISTINCT fabricante.nombre, modelo.nombre, provincia
FROM fabricante
JOIN modelo ON cif=fabricante
JOIN vehiculo ON codigo=modelo
JOIN persona ON propietario=nif
WHERE propietario IS NOT NULL
AND baja IS NOT NULL;

/*PRUEBA 2*/
/*Creo que es una subconsulta*/
/*Por partes*/
/*Nombre distinto del fabricante, del modelo y de la provincia*/
SELECT DISTINCT fabricante.nombre, modelo.nombre, provincia

/*Modelo vendido y provincia en la que se ha vendido algún modelo*/;
SELECT DISTINCT provincia, modelo
FROM vehiculo
JOIN modelo ON modelo=codigo
JOIN fabricante ON fabricante=cif
WHERE propietario IS NOT NULL;

/*Modelo de coche y su provincia en la que actualmente todos los vehículos de ese modelo están dados de baja.*/
SELECT DISTINCT provincia, modelo
FROM vehiculo
JOIN modelo ON modelo=codigo
JOIN fabricante ON fabricante=cif
WHERE baja IS NOT NULL;

/*Junto las dos anteriores*/
SELECT DISTINCT fabricante.nombre, modelo.nombre, provincia
FROM vehiculo
JOIN modelo ON modelo=codigo
JOIN fabricante ON fabricante=cif
WHERE baja IS NOT NULL
AND propietario IS NOT NULL

/*HAY QUE AÑADIR LA TABLA PERSONA. Porque el sitio donde se
vende el coche es donde el propietario lo compra, no donde 
está el fabricante*/

/*PRUEBA 3*/
SELECT DISTINCT fabricante.nombre, modelo.nombre, persona.provincia
FROM persona
JOIN vehiculo ON nif=propietario
JOIN modelo ON modelo=codigo
JOIN fabricante ON fabricante=cif
WHERE nif IN (SELECT propietario FROM vehiculo)
GROUP BY fabricante.nombre, modelo.nombre, persona.provincia
HAVING COUNT(matricula)=COUNT(baja);

/*15*/
/*Nombre de los fabricantes que han vendido menos 
vehículos que el fabricante de nombre'SEAT'.*/

/*Por partes para que me entere*/
/*ventas del fabricante 'SEAT'*/
SELECT fabricante.nombre, COUNT(propietario)
FROM fabricante
JOIN modelo ON cif=fabricante
JOIN vehiculo ON codigo=modelo
WHERE fabricante.nombre='SEAT'
GROUP BY fabricante.nombre;

/*PRUEBA 1*/
/*Comparación de el número de propietarios de los 
demás fabricantes con el anterior*/
/*¿Se pueden usar los comandos SUM, AVG... después de WHERE?*/
SELECT fabricante.nombre
FROM fabricante
JOIN modelo ON cif=fabricante
JOIN vehiculo ON codigo=modelo
WHERE SUM(propietario)<
(SELECT fabricante.nombre, COUNT(propietario)
FROM fabricante
JOIN modelo ON cif=fabricante
JOIN vehiculo ON codigo=modelo
WHERE fabricante.nombre='SEAT'
GROUP BY fabricante.nombre);

/*PRUEBA 2*/
SELECT fabricante.nombre
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

/*COMPROBACIÓN: AÑADO COUNT PARA VER SI EFECTIVAMENTE EL NÚMERO
DE VALORES DE ESTOS ES INFERIOR AL DE SEAT*/
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
/*Nombre y apellidos de las personas que han comprado como mínimo un vehículo de cada fabricante.*/
/*Lo básico*/
SELECT persona.nombre, persona.apellidos
FROM persona
JOIN vehiculo ON nif=propietario
JOIN modelo ON modelo=codigo
JOIN fabricante ON fabricante=cif;

/*Personas que han comprado un vehículo del fabricante seat*/
SELECT persona.nombre, persona.apellidos, fabricante.nombre
FROM persona
JOIN vehiculo ON nif=propietario
JOIN modelo ON modelo=codigo
JOIN fabricante ON fabricante=cif
WHERE fabricante.nombre='SEAT';

/*PRUEBA 1*/
/*Personas que han comprado un vehículo a todos los fabricantes*/
SELECT persona.nombre, persona.apellidos
FROM persona
JOIN vehiculo ON nif=propietario
JOIN modelo ON modelo=codigo
JOIN fabricante ON fabricante=cif
WHERE fabricante.nombre='*';
/*No funciona*/

/*¿Cuántos fabricantes hay?*/
SELECT COUNT(nombre)
FROM fabricante;
/*Hay 8 fabricantes*/

/*PRUEBA 2*/
/*Personas que han comprado un vehículo a todos los fabricantes*/
SELECT persona.nombre, persona.apellidos
FROM persona
JOIN vehiculo ON nif=propietario
JOIN modelo ON modelo=codigo
JOIN fabricante ON fabricante=cif
WHERE COUNT(fabricante.nombre)=>
(SELECT COUNT(nombre)
FROM fabricante);
/*No funciona. ¿Por qué?--> No se puede poner COUNT después
de WHERE. Va con la expresión HAVING*/


/*PRUEBA 3*/
/*Nombre y apellidos de las personas que han comprado como mínimo un vehículo de cada fabricante.*/
/*IDEA 16 Y 17*/
/*Número de fabricantes a los que les compra cada persona igual al número de fabricantes.*/

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

/*¿Cómo selecciono la provincia que
menos población tiene?*/

/*19*/
/*Nombre del fabricante y número de vehículos 
vendidos por el fabricante del que se ha
matriculado el mayor número de plazas*/

/*Por partes*/
/*COMPROBACIÓN 1:Nombre de los fabricante y número de vehículos vendidos por ellas*/
SELECT fabricante.nombre, COUNT(matricula)
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





/*IDEA 16 Y 17*/
/*Número de fabricantes a los que les compra cada persona 
igual al número de fabricantes.*/

/*1- Idea principal:''
2- Disgregarla --> Comprobarlas
3- Juntarlo
4- Comprobaciones*/

/*19*/
/*Condicionar al número de plazas y mostrar el número de vehículos*/

/*20*/
/*Seguir misma dinámica del 18: PACIENCIA*/






