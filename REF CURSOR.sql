
------------------------------------------------------
-- VARIABLES REF CURSOR
------------------------------------------------------

-- Son referencias a otros cursores
-- es un puntero a un cursor
-- se comportan como cursores casi normales, pero pueden cambiar de forma dinámica al cursor al que apuntan


SET SERVEROUTPUT ON;

DROP TABLE mona_xina;

CREATE TABLE mona_xina 
(
    id_mona NUMBER(9) PRIMARY KEY,
    descripcion VARCHAR2(100)
);

INSERT INTO mona_xina VALUES (1,'Jorge');
INSERT INTO mona_xina VALUES (2,'Lissette');
COMMIT;

DROP TABLE pokemon;

CREATE TABLE pokemon 
(
    id_pokemon NUMBER(9) PRIMARY KEY,
    descripcion VARCHAR2(100)
);

INSERT INTO pokemon VALUES (1,'Pikachu');
INSERT INTO pokemon VALUES (2,'Charmander');
COMMIT;


DECLARE
    -- CREAREMOS UNA PLANTILLA DE TIPO CURSOR
    TYPE cursor_variable IS REF CURSOR;
    v1 cursor_variable;
    x1 cursor_variable;
    monas_xinas mona_xina%rowtype;
    pokemones pokemon%rowtype;
BEGIN
    
    OPEN v1 FOR SELECT * FROM mona_xina;
    FETCH v1 INTO monas_xinas;
    -- ME RETORNA EL VALOR DEL PRIMER REGISTRO
    dbms_output.put_line(monas_xinas.descripcion);
    CLOSE v1;
    
    OPEN v1 FOR SELECT * FROM pokemon;
    FETCH v1 INTO pokemones;
    dbms_output.put_line(pokemones.descripcion);
    CLOSE v1;
    
    -- SYSREFCURSOR CON BUCLE WHILE
    OPEN v1 FOR SELECT * FROM pokemon;
    FETCH v1 INTO pokemones;
    WHILE v1%found 
    LOOP
        dbms_output.put_line(pokemones.descripcion);
        FETCH v1 INTO pokemones;
    END LOOP;
    
    -- SYSREFCURSOR CON CICLO LOOP 
    OPEN v1 FOR SELECT * FROM mona_xina;
    LOOP
        FETCH v1 INTO monas_xinas;
        EXIT WHEN v1%notfound;
        dbms_output.put_line(monas_xinas.descripcion);
    END LOOP;
    
END;
/



DECLARE 
    -- Le indico a C1 un tipado, obligamos al cursor que trabaje con ese tipo
    TYPE c1 IS REF CURSOR RETURN mona_xina%rowtype;
    v1 c1;
    monas_xinas mona_xina%rowtype;
BEGIN

    OPEN v1 FOR SELECT * FROM mona_xina WHERE id_mona > 1;
    FETCH v1 INTO monas_xinas;
    WHILE v1%found
    LOOP
        dbms_output.put_line(monas_xinas.descripcion);
        FETCH v1 INTO monas_xinas;
    END LOOP;
    CLOSE v1;
    
    OPEN v1 FOR SELECT * FROM mona_xina;
    FETCH v1 INTO monas_xinas;
    WHILE v1%found
    LOOP
        dbms_output.put_line(monas_xinas.descripcion);
        FETCH v1 INTO monas_xinas;
    END LOOP;
    CLOSE v1;
        
END;
/


------------------------------------------------
-- REF CURSORS EN FUNCIONES
------------------------------------------------

CREATE OR REPLACE PACKAGE pkg_cursor IS
    TYPE c_variable IS REF CURSOR;
    FUNCTION fn_devolver_data (c1 IN OUT c_variable, X NUMBER) RETURN VARCHAR2;
END;
/


CREATE OR REPLACE PACKAGE BODY pkg_cursor IS
    FUNCTION fn_devolver_data (c1 IN OUT c_variable, X NUMBER) RETURN VARCHAR2 IS
        pokemones pokemon%rowtype;
        monas_xinas mona_xina%rowtype;
    BEGIN
        IF X =1 THEN
            OPEN c1 FOR SELECT * FROM mona_xina;
            FETCH c1 INTO monas_xinas;
            RETURN monas_xinas.descripcion;
        ELSE
            OPEN c1 FOR SELECT * FROM pokemon;
            FETCH c1 INTO pokemones;
            RETURN pokemones.descripcion;
        END IF;
    END;
END;
/


DECLARE
    datos pkg_cursor.c_variable;
BEGIN
    dbms_output.put_line(pkg_cursor.fn_devolver_data(datos,1));
END;
/


-- COMPARTIR CURSORES


DECLARE
    TYPE cursor_variable IS REF CURSOR RETURN mona_xina%rowtype;
    v1 cursor_variable;
    v2 cursor_variable;
    
    monas_xinas mona_xina%rowtype;
BEGIN
    -- ABRIMOS EL CURSOR CON LA PRIMERA VARIABLE
    OPEN v1 FOR SELECT * FROM mona_xina ORDER BY descripcion ASC;
    FETCH v1 INTO monas_xinas;
    dbms_output.put_line(monas_xinas.id_mona || ' - ' || monas_xinas.descripcion); 
    
    -- ASIGNAMOS V1 A V2
    v2 := v1;
    FETCH v2 INTO monas_xinas;
    dbms_output.put_line(monas_xinas.id_mona || ' - ' || monas_xinas.descripcion); 
    CLOSE v1;
END;


-----------------------------------------------------
-- TIPO SYS REF CURSOR
-----------------------------------------------------
-- Variable ya predefinida en la base de datos para los SYS REF CURSOR GENÉRICOS
DECLARE
    -- A excepcion de un REF CURSOR con return
    v1 SYS_REFCURSOR;
    monas_xinas mona_xina%rowtype;
BEGIN
    OPEN v1 FOR SELECT * FROM mona_xina;
    FETCH v1 INTO monas_xinas;
    WHILE v1%found
    LOOP
        dbms_output.put_line(monas_xinas.descripcion);
        FETCH v1 INTO monas_xinas;
    END LOOP;
    CLOSE v1;
END;

