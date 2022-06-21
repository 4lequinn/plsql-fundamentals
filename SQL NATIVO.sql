
--------------------------------------------------
-- PLSQL NATIVO
--------------------------------------------------

-- Mejora el rendimiento y la velocidad de procedimientos PLSQL

-- COMPILACIÓN INTERPRETADA => ES LA POR DEFECTO

-- CÓDIGO COMPILADO EN MODO NATIVO, ES MÁS RÁPIDO PERO SÓLO CON PL/SQL


----------------------------------------------------------------------------------------------------

SET SERVEROUTPUT ON;

-- ALTERAMOS LA SESIÓN 
ALTER SESSION SET PLSQL_CODE_TYPE = 'INTERPRETED';
/

CREATE OR REPLACE PROCEDURE SP_EJEMPLO AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('EJEMPLO');
END;

SELECT * FROM USER_PLSQL_OBJECT_SETTINGS WHERE NAME LIKE 'SP_EJEMPLO';

ALTER SESSION SET PLSQL_CODE_TYPE = 'NATIVE';
/

-------------------------------------------------------------------------------------------------------------------------
-- COMPARACIÓN PROCESO EN MODO INTERPRETADO Y MODO NATIVO
-------------------------------------------------------------------------------------------------------------------------

create or replace PROCEDURE N1  AS
V VARCHAR2(1000):='A';    
X DATE;
Z varchar2(1000);
BEGIN
     DBMS_OUTPUT.PUT_LINE(to_char(sysdate,'mi:ss'));
    FOR I IN 1..100000000 LOOP
        FOR X IN 1..15 LOOP
            V:='A'||SUBSTR('AAAAAA',1,5);
        end loop;
    END LOOP;  

         DBMS_OUTPUT.PUT_LINE(to_char(sysdate,'mi:ss'));

END;
/

set serveroutput on
execute n1;

ALTER SESSION SET PLSQL_CODE_TYPE='NATIVE';
ALTER SESSION SET PLSQL_CODE_TYPE='INTERPRETED';
/

SELECT * FROM USER_PLSQL_OBJECT_SETTINGS WHERE NAME LIKE 'N1';
