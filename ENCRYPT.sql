-----------------------------------------------------------------------------------------------
-- PACKAGE DE ENCRIPTACIÓN Y DESENCRIPTACIÓN
-----------------------------------------------------------------------------------------------

-- Hay que otorgar estos permisos desde el usuario sys
grant execute on dbms_crypto to "nombre_usuario";
  
-- Ver el package de DBMS_CRYPTO
select * from dba_objects
where object_name = 'DBMS_CRYPTO'
           
SET DEFINE OFF;
CREATE TABLE ENC_DATA
(
  USER_ID  VARCHAR2(20 BYTE),
  ENC_PSW  RAW(2000)
)
/

ALTER TABLE ENC_DATA ADD (
  CONSTRAINT ENC_DATA_PK
 PRIMARY KEY
 (USER_ID))
/



DECLARE
   l_user_id    enc_data.USER_ID%TYPE := 'x4leqxinn';
   l_user_psw   VARCHAR2 (2000) := 'monaxinauwu';

   l_key        VARCHAR2 (2000) := '1234567890999999';
   l_mod NUMBER
         :=   DBMS_CRYPTO.ENCRYPT_AES128
            + DBMS_CRYPTO.CHAIN_CBC
            + DBMS_CRYPTO.PAD_PKCS5;
   l_enc        RAW (2000);
BEGIN
   l_user_psw :=
      encrypt (UTL_I18N.string_to_raw (l_user_psw, 'AL32UTF8'),
                           l_mod,
                           UTL_I18N.string_to_raw (l_key, 'AL32UTF8'));
   
      DBMS_OUTPUT.put_line ('Encrypted=' || l_user_psw);

   INSERT INTO enc_data (user_id, enc_psw)
       VALUES (l_user_id, l_user_psw);

   COMMIT;
END;
/


DECLARE
   l_user_id    enc_data.user_id%TYPE := 'x4leqxinn';
   l_user_psw   RAW (2000);

   l_key        VARCHAR2 (2000) := '1234567890999999';
   l_mod NUMBER
         :=   DBMS_CRYPTO.ENCRYPT_AES128
            + DBMS_CRYPTO.CHAIN_CBC
            + DBMS_CRYPTO.PAD_PKCS5;
   l_dec        RAW (2000);
BEGIN
   SELECT enc_psw
     INTO l_user_psw
     FROM enc_data
    WHERE user_id = l_user_id;

   l_dec :=
      DBMS_CRYPTO.decrypt (l_user_psw,
                           l_mod,
                           UTL_I18N.STRING_TO_RAW (l_key, 'AL32UTF8'));
   DBMS_OUTPUT.put_line ('Decrypted=' || UTL_I18N.raw_to_char (l_dec));
END;
/




CREATE OR REPLACE PACKAGE MY_ENCRYPTION_PKG
----  Customized and prepared by Mohsen Ali ..................................
AS
   FUNCTION encrypt_f (p_plainText VARCHAR2,p_key_length number,p_key varchar2) RETURN RAW DETERMINISTIC;
   FUNCTION decrypt_f (p_encryptedText RAW,p_key_length number ,p_key varchar2) RETURN VARCHAR2 DETERMINISTIC;
   FUNCTION hash_f (p_plainText VARCHAR2,p_type varchar2 ) RETURN RAW DETERMINISTIC;
END;
/
 CREATE OR REPLACE PACKAGE BODY MY_ENCRYPTION_PKG
AS


      FUNCTION encrypt_f (p_plainText VARCHAR2,p_key_length number,p_key varchar2) RETURN RAW DETERMINISTIC
     IS
        encrypted_raw      RAW (2000);
		encryption_key     RAW (128) := UTL_RAW.cast_to_raw(p_key);
		encryption_type    PLS_INTEGER;
     BEGIN
				 if p_key_length=8 then
							 encryption_type     :=    DBMS_CRYPTO.encrypt_des+ DBMS_CRYPTO.chain_cbc+ DBMS_CRYPTO.pad_pkcs5;
				  elsif p_key_length=16 THEN
							  encryption_type     :=    DBMS_CRYPTO.encrypt_aes128+ DBMS_CRYPTO.chain_cbc+ DBMS_CRYPTO.pad_pkcs5;
				  elsif p_key_length=32 THEN
							   encryption_type     :=    DBMS_CRYPTO.encrypt_aes256 + DBMS_CRYPTO.chain_cbc+ DBMS_CRYPTO.pad_pkcs5;
				  end if;
				  encrypted_raw := DBMS_CRYPTO.ENCRYPT
					(
					   src => UTL_RAW.CAST_TO_RAW (p_plainText),
					   typ => encryption_type,
					   key => encryption_key
					);
				   RETURN encrypted_raw;
	 END encrypt_f;

     FUNCTION decrypt_f (p_encryptedText RAW,p_key_length number,p_key varchar2 ) RETURN VARCHAR2 DETERMINISTIC
     IS
        decrypted_raw      RAW (2000);
		encryption_key     RAW (128) := UTL_RAW.cast_to_raw(p_key);
		encryption_type    PLS_INTEGER;
     BEGIN
				if p_key_length=8     then
						 encryption_type     :=    DBMS_CRYPTO.encrypt_des + DBMS_CRYPTO.chain_cbc + DBMS_CRYPTO.pad_pkcs5;
				elsif p_key_length=16 THEN
						  encryption_type     :=    DBMS_CRYPTO.encrypt_aes128 + DBMS_CRYPTO.chain_cbc+ DBMS_CRYPTO.pad_pkcs5;
				elsif p_key_length=32 THEN
						   encryption_type     :=    DBMS_CRYPTO.encrypt_aes256+ DBMS_CRYPTO.chain_cbc + DBMS_CRYPTO.pad_pkcs5;
				end if;
				decrypted_raw := DBMS_CRYPTO.DECRYPT
				(
					src => p_encryptedText,
					typ => encryption_type,
					key => encryption_key
				);
				RETURN (UTL_RAW.CAST_TO_VARCHAR2 (decrypted_raw));
     END decrypt_f;
FUNCTION hash_f (p_plainText VARCHAR2,p_type varchar2) RETURN RAW DETERMINISTIC
     IS
			l_ccn_raw RAW(128) := utl_raw.cast_to_raw(p_plainText);
            encrypted_raw RAW (2000);
BEGIN
					 if p_type='hash_md4' then 
								encrypted_raw := dbms_crypto.hash(l_ccn_raw, dbms_crypto.hash_md4);
					  elsif   p_type='hash_md5' then 
								encrypted_raw := dbms_crypto.hash(l_ccn_raw, dbms_crypto.hash_md5);
					  elsif p_type='hash_sh1' then 
						encrypted_raw := dbms_crypto.hash(l_ccn_raw, dbms_crypto.hash_sh1);
					  elsif p_type='hash_sh256' then 
							encrypted_raw := dbms_crypto.hash(l_ccn_raw, dbms_crypto.hash_sh256);
					  elsif     p_type='hash_sh384' then 
							encrypted_raw := dbms_crypto.hash(l_ccn_raw, dbms_crypto.hash_md4);
					  elsif p_type='hash_sh512' then 
							 encrypted_raw := dbms_crypto.hash(l_ccn_raw, dbms_crypto.hash_sh512);
					  end if;
		  		     RETURN encrypted_raw;

 END hash_f;

END;
/



SELECT my_encryption_pkg.encrypt_f('Jorge',8,'teamobbuwu') FROM DUAL;


SELECT my_encryption_pkg.decrypt_f('A72C16D6FC8A5D1C',8,'teamobbuwu') FROM DUAL;


SELECT my_encryption_pkg.encrypt_f(my_encryption_pkg.hash_f('JORGE','hash_sh256') ,8,'love-egy')FROM DUAL;
SELECT my_encryption_pkg.decrypt_f(my_encryption_pkg.hash_f('62A84BF1A51FB27DCC52ED8F05D9811E9FCFC683ED0BA2C29696AD3741ABDDE8C3FB08AB50B98CF3A2AE5CD67CA6AB6DBD100AC0D721E220FFCF8F57EA5FBD25F11CF6F9BB2FAAB4','hash_sh256') ,8,'love-egy')FROM DUAL;

SELECT my_encryption_pkg.decrypt_f('9E88D6BF54DEA68B003C9878922C4305','hash_md4') FROM DUAL;



SET SERVEROUTPUT ON;

DECLARE
    v_p VARCHAR2(200);
BEGIN
    SELECT my_encryption_pkg.encrypt_f('Jorge',8,'teamobbuwu') INTO v_p  FROM DUAL;
    IF V_P = 'A72C16D6FC8A5D1C' THEN
        DBMS_OUTPUT.PUT_LINE('Sesión iniciada');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Usuario o contraseña no válidos');
    END IF;
END;
