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

/*N�mero total de provincias*/
SELECT COUNT(provincia) FROM persona;

/*PRUEBA 2*/
/*En la anterior me he equivocado debido a que no he 
interpretad el enunciado al pie de la letra y he 
cambiado el orden de count y distinct.
N�mero distinto, no distinto n�mero*/
SELECT COUNT(DISTINCT provincia)
FROM persona, vehiculo, modelo
WHERE nif=propietario
AND modelo=codigo
AND plazas=2;

/*6*/
/*PRUEBA 1*/
/*Los coches se matriculan en el sitio en el que se compran,
por lo que hay que relacionarlos con la provincia de el propietario.
Aqu� he relacionado con el fabricante y no es correcta la respuesta*/
SELECT COUNT(matricula), provincia
FROM vehiculo, fabricante, modelo
WHERE modelo=codigo AND fabricante=cif
AND  baja IS NULL
AND provincia IN ('MADRID','VALENCIA','BARCELONA')
GROUP BY provincia;

/*PRUEBA 2*/
/*De esta manera obtengo la cantidad de veh�culos 
matriculados en cada provincia (USANDO GROUP BY).

NO ES NECESARIO TENER UNA SONSULTA SUMATORIA EN SELECT
PARA USAR GROUP BY

Con el comando 'IN' no hace falta que est� usando x= AND,
es mucho m�s r�pido y efectivo*/
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
/*�Por qu� no est� bien? --> PREGUNTAR ENRIQUE*/
SELECT persona.provincia, COUNT(persona.nif)
FROM persona 
JOIN vehiculo ON(nif=propietario)
JOIN modelo ON (modelo=codigo)
JOIN fabricante ON (fabricante=cif)
WHERE persona.provincia=fabricante.provincia
GROUP BY persona.provincia
ORDER BY 2 DESC, 1 ASC;

/*PRUEBA 9 AIDA*/
/*La l�gica es la siguiente:
IDEA PRINCIPAL: Provincias de personas que
est�n contenidas en las provincias de los fabricantes.
DIVIDO LA IDEA EN SUBCONSULTAS:
Subconsulta 1: N�mero de personas que viven 
en la misma provincia que el fabricante.
Subconsulta 2:Cu�l es esa provincia. */

/*PREGUNTA:�No es necesario relacionar
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

/*PRUEBA 2 (USANDO JOIN Y A�ADO DISTINCT)*/
SELECT DISTINCT fabricante.nombre, DISTINCT modelo.nombre, COUNT(matricula)
FROM fabricante
JOIN modelo ON (fabricante=cif)
JOIN vehiculo ON (modelo=codigo)
WHERE vehiculo.baja IS NOT NULL
ORDER BY 3;

/*PRUEBA 2 (USANDO JOIN Y GROUP BY)*/
/*Cuando son consultas sumarias y hay m�s de dos 
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

/*Personas que han comprado m�s de 5 veh�culos*/
SELECT nombre, apellidos, COUNT(matricula)
FROM persona, vehiculo
WHERE nif=propietario
GROUP BY nombre, apellidos
HAVING COUNT(modelo)>5;

/*PRUEBA 2*/
/*Personas que han comprado m�s de 5 veh�culos del mismo modelo*/
/*No s� si he seleccionado bien con HAVING SUM*/
/*Cuando hablan de marca se refieren al fabricante*/
SELECT nombre, apellidos, modelo, COUNT(matricula)
FROM persona, vehiculo
WHERE nif=propietario
GROUP BY nombre,apellidos,modelo
HAVING SUM(modelo)>5;

/*Me sale que la matr�cula tiene valor 1, por lo que est�
mal planteada la consulta*/

/*PRUEBA 3 (CORRECTA)*/
/*Est� planteada como la anterior pero poniendo bien el campo de 
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
/*�FORMA CORRECTA Y R�PIDA? NO SUBCONSULTA*/
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
/*Todos los datos de las personas que nunca han tenido un veh�culo matriculado.*/

/*PRUEBA 1*/
/*�C�mo seleccionar todos los datos de solo personas sin que se me 
incluyan los datos de veh�culo?
RESPUESTA: Hago una subconsulta en donde pregunto por los datos
de los propietarios de los veh�culos*/
/*�No tengo muy claro por qu� left join y no right join?*/
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
/*�No s� c�mo mirar que el veh�culo en
alg�n momento haya estado matriculado*/
/*Los propietarios que en alg�n momento han tenido un coche
han de aparecer en la base de datos veh�culos*/

/*No s� c�mo mirar que en la actualidad todos est�n dados de baja*/
/*Para mirar que todos est�n dados de baja hay que comparar la cantidad
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
ese modelo en veh�culo debe de haber 
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

/*Modelo vendido y provincia en la que se ha vendido alg�n modelo*/;
SELECT DISTINCT provincia, modelo
FROM vehiculo
JOIN modelo ON modelo=codigo
JOIN fabricante ON fabricante=cif
WHERE propietario IS NOT NULL;

/*Modelo de coche y su provincia en la que actualmente todos los veh�culos de ese modelo est�n dados de baja.*/
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

/*HAY QUE A�ADIR LA TABLA PERSONA. Porque el sitio donde se
vende el coche es donde el propietario lo compra, no donde 
est� el fabricante*/

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
veh�culos que el fabricante de nombre'SEAT'.*/

/*Por partes para que me entere*/
/*ventas del fabricante 'SEAT'*/
SELECT fabricante.nombre, COUNT(propietario)
FROM fabricante
JOIN modelo ON cif=fabricante
JOIN vehiculo ON codigo=modelo
WHERE fabricante.nombre='SEAT'
GROUP BY fabricante.nombre;

/*PRUEBA 1*/
/*Comparaci�n de el n�mero de propietarios de los 
dem�s fabricantes con el anterior*/
/*�Se pueden usar los comandos SUM, AVG... despu�s de WHERE?*/
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

/*COMPROBACI�N: A�ADO COUNT PARA VER SI EFECTIVAMENTE EL N�MERO
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
/*Nombre y apellidos de las personas que han comprado como m�nimo un veh�culo de cada fabricante.*/
/*Lo b�sico*/
SELECT persona.nombre, persona.apellidos
FROM persona
JOIN vehiculo ON nif=propietario
JOIN modelo ON modelo=codigo
JOIN fabricante ON fabricante=cif;

/*Personas que han comprado un veh�culo del fabricante seat*/
SELECT persona.nombre, persona.apellidos, fabricante.nombre
FROM persona
JOIN vehiculo ON nif=propietario
JOIN modelo ON modelo=codigo
JOIN fabricante ON fabricante=cif
WHERE fabricante.nombre='SEAT';

/*PRUEBA 1*/
/*Personas que han comprado un veh�culo a todos los fabricantes*/
SELECT persona.nombre, persona.apellidos
FROM persona
JOIN vehiculo ON nif=propietario
JOIN modelo ON modelo=codigo
JOIN fabricante ON fabricante=cif
WHERE fabricante.nombre='*';
/*No funciona*/

/*�Cu�ntos fabricantes hay?*/
SELECT COUNT(nombre)
FROM fabricante;
/*Hay 8 fabricantes*/

/*PRUEBA 2*/
/*Personas que han comprado un veh�culo a todos los fabricantes*/
SELECT persona.nombre, persona.apellidos
FROM persona
JOIN vehiculo ON nif=propietario
JOIN modelo ON modelo=codigo
JOIN fabricante ON fabricante=cif
WHERE COUNT(fabricante.nombre)=>
(SELECT COUNT(nombre)
FROM fabricante);
/*No funciona. �Por qu�?--> No se puede poner COUNT despu�s
de WHERE. Va con la expresi�n HAVING*/


/*PRUEBA 3*/
/*Nombre y apellidos de las personas que han comprado como m�nimo un veh�culo de cada fabricante.*/
/*IDEA 16 Y 17*/
/*N�mero de fabricantes a los que les compra cada persona igual al n�mero de fabricantes.*/

/*CONSULTA 1: Personas y el n�mero de fabricantes a los que les han comprado*/
SELECT COUNT( DISTINCT fabricante.nombre),persona.nombre, apellidos
FROM fabricante
JOIN modelo ON fabricante=cif
JOIN vehiculo ON modelo=codigo
JOIN persona ON propietario=nif
GROUP BY persona.nombre, apellidos;

/*CONSULTA 2: N�mero de fabricantes totales que hay*/
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
/*Datos de las personas que han comprado m�s de un veh�culo y todos los veh�culos son del
mismo fabricante.*/

/*COMPROBACI�N 1: Personas y el n�mero de fabricantes a los que les han comprado*/
SELECT COUNT( DISTINCT fabricante.nombre),persona.nombre, apellidos
FROM fabricante
JOIN modelo ON fabricante=cif
JOIN vehiculo ON modelo=codigo
JOIN persona ON propietario=nif
GROUP BY persona.nombre, apellidos;

/*COMPROBACI�N 2:Personas que solo le han comprado a un fabricante*/
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

/*Me suma el mismo fabricante varias veces y la condici�n que he puesto es 
que sea el mismo*/

/*COMPROBACI�N 3:Personas que tienen m�s de un veh�culo*/
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
/*Provincia en la que viven el menor n�mero de personas.*/

/*COMPROBACI�N 1:Provincias y personas en esas provincias*/
SELECT COUNT(provincia), provincia
FROM persona
GROUP BY provincia
ORDER BY 1 ASC;
/*Tiene que salir Albacete*/

/*COMPROBACI�N 2*/
SELECT provincia
FROM persona
GROUP BY provincia 
HAVING COUNT(provincia)= '24';

/*COMPROBACI�N 3:*/
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
/*A pesar de que no aparezcan m�s columnas puedo agrupar en GROUP BY*/

/*�C�mo selecciono la provincia que
menos poblaci�n tiene?*/

/*19*/
/*Nombre del fabricante y n�mero de veh�culos 
vendidos por el fabricante del que se ha
matriculado el mayor n�mero de plazas*/

/*Por partes*/
/*COMPROBACI�N 1:Nombre de los fabricante y n�mero de veh�culos vendidos por ellas*/
SELECT fabricante.nombre, COUNT(matricula)
FROM fabricante
JOIN modelo ON cif=fabricante
JOIN vehiculo ON modelo=codigo
GROUP BY fabricante.nombre
ORDER BY 2 DESC;

/*As� compruebo que es RENAULT 1848 quien tiene m�s veh�culos matriculados*/

/*Saco el fabricante que m�s veh�culos vendidos tiene*/
SELECT fabricante.nombre,MAX(COUNT(matricula))
FROM fabricante
JOIN modelo ON cif=fabricante
JOIN vehiculo ON modelo=codigo
GROUP BY fabricante.nombre;
/*No me sale as� el que tiene m�s veh�culos-->�C�mo lo saco?*/

/*CONSULTA 2:Fabricantes y la suma de su n�mero de plazas*/
/*�Seria lo mismo que las plazas matr�culadas?*/
SELECT fabricante.nombre, SUM(plazas)
FROM fabricante
JOIN modelo ON cif=fabricante
JOIN vehiculo ON modelo=codigo
GROUP BY fabricante.nombre
ORDER BY 2 DESC;
/*Renault es el que m�s plazas tiene 9231*/
SELECT MAX(SUM(plazas))
FROM fabricante, vehiculo, modelo
WHERE modelo=codigo AND fabricante=cif
GROUP BY fabricante.nombre;

/*SALE DIFERENTE A ESTO*/
SELECT fabricante,SUM(plazas) FROM modelo GROUP BY fabricante ORDER BY 2 DESC;

/*Renault es el que m�s plazas tiene 45*/
/*�Cu�l es la diferencia entre ambas?*/

/*Seleccionar el nombre vendedor con m�s plazas*/
SELECT DISTINCT fabricante.nombre 
FROM fabricante 
JOIN modelo ON cif=fabricante
WHERE fabricante=
(SELECT fabricante FROM modelo 
GROUP BY fabricante HAVING SUM(plazas)= 
(SELECT MAX(SUM(plazas))FROM modelo GROUP BY fabricante));
/*Soy la puta ama*/
/*GROUP BY va detr�s de WHERE*/

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
/*En esta no estoy incluyendo los que est�n matriculados*/

SELECT fabricante.nombre, COUNT(matricula)
FROM fabricante
JOIN modelo ON fabricante=cif
JOIN vehiculo ON codigo=modelo
GROUP BY fabricante.nombre
HAVING SUM(plazas) = (SELECT MAX(SUM(plazas))
FROM fabricante, vehiculo, modelo
WHERE modelo=codigo AND fabricante=cif
GROUP BY fabricante.nombre);
/*oL�*/
/*Condicionar al n�mero de plazas y mostrar el n�mero de veh�culos*/
/*N�mero de plazas ser�a la subconsulta que condiciona al n�mero
de veh�culos matriculados a mostrar*/


/*20*/
/*Nombre de los fabricantes, nombre de los modelos y n�mero de provincias en que se ha
vendido un modelo, para aquellos modelos que se ha vendido en el menor n�mero de provincias.*/

/*General*/
SELECT fabricante.nombre, modelo.nombre, COUNT(persona.provincia)
FROM fabricante
JOIN modelo ON fabricante=cif
JOIN vehiculo ON codigo=modelo
JOIN persona ON propietario=nif;

/*COMPROBACI�N 1:Nombre de los modelos que se han vendido en UNA provincia (UNO SOLO)*/
SELECT modelo.nombre
FROM persona
JOIN vehiculo ON nif=propietario
JOIN modelo ON modelo=codigo
GROUP BY persona.provincia, modelo.nombre
HAVING COUNT(persona.provincia)=1
ORDER BY 1 ASC;

/*COMPROBACI�N 2: Modelos que se han vendido en cada provincia*/
/*N�mero de provincias totales*/
SELECT COUNT(DISTINCT provincia)
FROM persona;

SELECT COUNT(DISTINCT provincia), modelo
FROM persona
JOIN vehiculo ON nif=propietario
GROUP BY modelo
ORDER BY 1,2;

/*Salen los modelos 10007,20007 y 70003 que se han vendido en 46 provincias*/

/*COMPROBACI�N 3: Modelos vendidos en menor n�mero de provincias*/
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
/*N�mero de fabricantes a los que les compra cada persona 
igual al n�mero de fabricantes.*/

/*1- Idea principal:''
2- Disgregarla --> Comprobarlas
3- Juntarlo
4- Comprobaciones*/

/*19*/
/*Condicionar al n�mero de plazas y mostrar el n�mero de veh�culos*/

/*20*/
/*Seguir misma din�mica del 18: PACIENCIA*/






