------------------------------------------------
-- VARRAYS
------------------------------------------------
SET SERVEROUTPUT ON;

DECLARE 
    TYPE V1 IS VARRAY(50) OF VARCHAR2(100);
    -- Constructor del varray
    -- Se debe inicializar el array 
    var1 v1 := v1('ADIOS','MUNDO');
BEGIN
    var1(1) := 'HOLA';
    DBMS_OUTPUT.PUT_LINE(var1(1) || ' ' ||var1(2));
    -- PARA AGREGAR MÁS VALORES HASTA EL 50 SE DEBE USAR EL EXTEND
    DBMS_OUTPUT.PUT_LINE('Posiciones usadas : ' || var1.count());
    var1.extend();
    DBMS_OUTPUT.PUT_LINE('Posiciones usadas : ' || var1.count());
    var1.extend(10);
    DBMS_OUTPUT.PUT_LINE('Posiciones usadas : ' || var1.count());
    DBMS_OUTPUT.PUT_LINE('Total de posiciones permitidas : '|| var1.limit());
END;
/

-- RECUPERAR DATOS CON VARRAY y BULK COLLECT
DECLARE 
    TYPE tipo_varray IS VARRAY(2) OF MONA_XINA%ROWTYPE;
    monas_xinas tipo_varray := tipo_varray();
BEGIN
    -- Evitamos extender el varray
    SELECT * BULK COLLECT INTO monaS_xinaS FROM MONA_xina FETCH FIRST 2 ROWS ONLY;
    FOR i IN monas_xinas.fiRst .. monas_xinas.last 
    LOOP
        DBMS_OUTPUT.PUT_LINE(monas_xinas(i).id_mona || ' - ' || monas_xinas(i).descripcion);
    END LOOP;
END;
/


-- VARRAY CON CURSOR
DECLARE 
    TYPE tipo_varray IS VARRAY(2) OF MONA_XINA%ROWTYPE;
    monas_xinas tipo_varray := tipo_varray();
    CURSOR C1 IS SELECT * FROM mona_xina FETCH FIRST 2 ROWS ONLY;
    v_contador NUMBER(2) DEFAULT 1;
BEGIN
    FOR x IN C1 
    LOOP
        monas_xinas.extend(1);
        monas_xinas(v_contador) := x;
        v_contador := v_contador + 1;
    END LOOP;
    
    FOR i IN monas_xinas.first .. monas_xinas.last
    LOOP
        DBMS_OUTPUT.PUT_LINE(monas_xinas(i).id_mona || ' - ' || monas_xinas(i).descripcion);
    END LOOP;
END;
/


-- CREAR UN VARRAY EN LA BASE DE DATOS
-- A MODO GLOBAL

CREATE OR REPLACE TYPE TIPO_ARREGLO IS VARRAY(80) OF VARCHAR(100);
/

-- DESCRIBE
DESC TIPO_ARREGLO;


DECLARE
    v1 TIPO_ARREGLO := TIPO_ARREGLO();
BEGIN
    v1.extend(1);
    v1(1) := 'Hola Mundo';
    DBMS_OUTPUT.PUT_LINE(v1(1));
END;
/

-- CREAR UNA TABLA CON UNA COLUMNA DE TIPO VARRAY 
-- SE PUEDE GUARDAR UNA COLECCIÓN EN UNA TABLA
CREATE TABLE TESTING (C1 NUMBER , C2 TIPO_ARREGLO, C3 VARCHAR2(60));

DESC TESTING;


-- VER LAS COLECCIONES
SELECT * FROM USER_TYPES;

-- VER LOS VARRAYS CREADOS A NIVEL DE OBJETO
SELECT * FROM USER_VARRAYS;


-- INSERT EN UNA TABLA CON UNA COLECCIÓN
INSERT INTO TESTING VALUES (100, tipo_arreglo('UNO','DOS'),'EJEMPLO' );
INSERT INTO TESTING VALUES (100, tipo_arreglo('SHINIGAMI','BB','OWOWO'),'EJEMPLO' );

SELECT * FROM TESTING;


-- RECUPERAR LA INFORMACIÓN
-- OPERADOR TABLE

SELECT C1, T2.*, C3
FROM TESTING, TABLE (TESTING.C2) T2;




-- Métodos de los VARRAYS

DECLARE
    TYPE EMPLEADO IS VARRAY(10) OF EMPLOYEES%ROWTYPE; 
    EMPLEADOS EMPLEADO:=EMPLEADO();
BEGIN
    SELECT * BULK COLLECT INTO EMPLEADOS
    FROM EMPLOYEES FETCH FIRST 10 ROWS ONLY;
    FOR I IN EMPLEADOS.FIRST()..EMPLEADOS.LAST() LOOP
        DBMS_OUTPUT.PUT_LINE(EMPLEADOS(I).FIRST_NAME||' '||EMPLEADOS(I).SALARY);
    END LOOP; 
        DBMS_OUTPUT.PUT_LINE(EMPLEADOS.LAST());
        DBMS_OUTPUT.PUT_LINE(EMPLEADOS.FIRST());
        DBMS_OUTPUT.PUT_LINE(EMPLEADOS.NEXT(1));
        DBMS_OUTPUT.PUT_LINE(EMPLEADOS.NEXT(10));
    IF EMPLEADOS.EXISTS(20) THEN
        DBMS_OUTPUT.PUT_LINE('EXISTE');
    ELSE
        DBMS_OUTPUT.PUT_LINE('NO EXISTE');
    END IF;
    -- MÉTODO DELETE NO FUNCIONA EN LOS VARRAY PORQUE SON SECUENCIALES
    --EMPLEADOS.DELETE(2);
END;
/





