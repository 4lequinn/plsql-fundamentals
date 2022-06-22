

-----------------------------------------------------------
--  Colecciones y Tipos Compuestos
-----------------------------------------------------------

-----------------------------------------------------------------------------------------------
-- ARRAYS ASOCIATIVOS - NESTED TABLES - VARRAYS
-----------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------
-- Associative arrays (INDEX BY TABLES)
-- * ES UN ARRAY DINÁMICO

-----------------------------------------------------------------------------------------------

/*
    Son colecciones PL/SQL con dos columnas 
    Clave primaria de tipo entero o cadena 
    Valores: Un tipo puede ser escalar o un record
*/

-- TYPE nombre IS TABLE OF TIPO columna INDEX BY PLS_INTEGER | BINARY_INTEGER | VARCHAR2(X);
-- VARIABLE TIPO


-- ARRAY(N)
-- ARRAY(N).CAMPO

-- MÉTODOS DE LOS ARRAYS 
-- EXISTS(N) DETECTA SI EXISTE UN ELEMENTO
-- COUNT: NÚMERO DE ELEMENTOS
-- FIRST: DEVUELVE EL ÍNDICE MÁS PEQUEÑO
-- LAST: DEVUELVE EL ÍNDICE MÁS ALTO
-- PRIOR(N): DEVUELVE EL ÍNDICE ANTERIOR A N 
-- NEXT(N): DEVUELVE EL ÍNDICE POSTERIOR A N
-- DELETE: BORRA TODO
-- DELETE(N): BORRAR EL ÍNDICE N
-- DELETE(M,N): BORRAR LOS ÍNDICES M A N


SET SERVEROUTPUT ON;

DECLARE 
    TYPE TIPO_TABLA  IS TABLE OF MONA_XINA.DESCRIPCION%TYPE INDEX BY PLS_INTEGER;
    monas_xinas TIPO_TABLA;
    
    TYPE TIPO_TABLA2 IS TABLE OF POKEMON%ROWTYPE INDEX BY PLS_INTEGER;
    pokemones TIPO_TABLA2;
    
    TYPE TIPO_NOMBRE IS TABLE OF MONA_XINA.DESCRIPCION%TYPE INDEX BY VARCHAR2(2);
    nombres tipo_nombre;
BEGIN
    monas_xinas(1) := 'uwu';
    monas_xinas(2) := 'oppai';
    monas_xinas(50) := 'shinigami';
    
    nombres('AA') := 'Liissuwu';
    
    
    pokemones(10).DESCRIPCION := 'RAICHU';
    
    DBMS_OUTPUT.PUT_LINE(monas_xinas(50));
    DBMS_OUTPUT.PUT_LINE(nombres('AA'));
    DBMS_OUTPUT.PUT_LINE(pokemones(10).DESCRIPCION);
END;
/

-- SPARSE - NO TIENE LAS CLAVES DE FORMA SECUENCIAL


-- CARGAR UN ARRAY INDEX BY ESCALAR CON  
DECLARE
    TYPE tipo_tabla IS TABLE OF MONA_XINA.descripcion%TYPE INDEX BY PLS_INTEGER;
    monas_xinas tipo_tabla;
    CURSOR C1 IS SELECT * FROM MONA_XINA;
    x PLS_INTEGER := 1;
BEGIN
    FOR mona IN C1 
    LOOP
        monas_xinas(X) := mona.descripcion;
        X := X + 1;
    END LOOP;
    
    FOR i IN 1..X-1
    LOOP
        DBMS_OUTPUT.PUT_LINE(monas_xinas(i));
    END LOOP;
END;
/


-- CARGAR UN ARRAY INDEX BY CON DATOS COMPUESTOS

DECLARE
  TYPE TIPO_TABLA IS TABLE OF MONA_XINA%ROWTYPE INDEX BY PLS_INTEGER;
  CURSOR CUR_MONA IS SELECT * FROM  MONA_XINA WHERE id_mona > 0;
  Z PLS_INTEGER:=1;
  MONAS_XINAS TIPO_TABLA;
BEGIN
    -- ENTREGO LOS DATOS A MI ARRAY
    FOR x IN CUR_MONA 
    LOOP
        MONAS_XINAS(Z):= x;
        Z:=Z+1;
    END LOOP;
  
    -- IMPRIMO LOS DATOS
    FOR I IN 1..Z-1 LOOP
        DBMS_OUTPUT.PUT_LINE(monas_xinas(I).id_mona||' '||monas_xinas(I).descripcion);
    END LOOP;  
END;
/


-- CLAÚSULA BULK COLLECT 
-- ES MÁS RÁPIDO QUE UTILIZAR UN CURSOR PARA PASARLE LOS DATOS A UN TIPO TABLA

DECLARE 
  TYPE TIPO_TABLA IS TABLE OF MONA_XINA%ROWTYPE INDEX BY PLS_INTEGER;
  Z PLS_INTEGER:=1;
  MONAS_XINAS TIPO_TABLA;
BEGIN
    -- ENTREGO LOS DATOS A MI ARRAY
    SELECT * BULK COLLECT INTO monas_xinas FROM mona_xina WHERE id_mona > 0;
    
    -- IMPRIMO LOS DATOS
    FOR I IN 1..monas_xinas.count() LOOP
        DBMS_OUTPUT.PUT_LINE(monas_xinas(I).id_mona||' '||monas_xinas(I).descripcion);
    END LOOP;  
END;
/

-- MÉTODOS DE LOS INDEX TABLE

-- SQUEMA HR

DECLARE
  
   TYPE SUMA_SALARIOS IS RECORD 
      (
         NOMBRE DEPARTMENTS.DEPARTMENT_NAME%TYPE,
         SUMA_SALARIOS NUMBER
      );

  TYPE SUMA_SAL IS TABLE OF SUMA_SALARIOS INDEX BY PLS_INTEGER;
 
  
  SALARIOS SUMA_SAL;
  
BEGIN
     SELECT DEPARTMENT_NAME,SUM(SALARY)
     BULK COLLECT INTO SALARIOS
     FROM EMPLOYEES JOIN DEPARTMENTS USING (DEPARTMENT_ID)
     GROUP BY DEPARTMENT_NAME;
    
     FOR I IN 1..SALARIOS.COUNT() LOOP
        DBMS_OUTPUT.PUT_LINE(SALARIOS(I).NOMBRE||' '||SALARIOS(I).SUMA_SALARIOS);
     END LOOP;
     
     DBMS_OUTPUT.PUT_LINE('NÚMERO EMPLEADOS:'||SALARIOS.COUNT());
     DBMS_OUTPUT.PUT_LINE('PRIMER REGISTRO:'||SALARIOS.FIRST());
     DBMS_OUTPUT.PUT_LINE('ULTIMO REGISTRO:'||SALARIOS.LAST());
     IF SALARIOS.EXISTS(20) THEN
        DBMS_OUTPUT.PUT_LINE('EXISTE');
    ELSE
        DBMS_OUTPUT.PUT_LINE('NO EXISTE');
    END IF;
    SALARIOS.DELETE(1);
    DBMS_OUTPUT.PUT_LINE('PRIMER REGISTRO:'||SALARIOS.FIRST());
    DBMS_OUTPUT.PUT_LINE(SALARIOS.PRIOR(3));
	DBMS_OUTPUT.PUT_LINE(SALARIOS.NEXT(3));
    SALARIOS.DELETE(4);
	DBMS_OUTPUT.PUT_LINE(SALARIOS.PRIOR(3));
	DBMS_OUTPUT.PUT_LINE(SALARIOS.NEXT(3));
END;
/


