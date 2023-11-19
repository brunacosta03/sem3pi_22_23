--******************************************************
--* PARA RELIZAR TESTES POR FAVOR IMPORTAR O BOOTSTRAP *
--******************************************************

--BACK-END
--Devolver o N-esimo elemento de cada tuplo do input_sensor
CREATE OR REPLACE FUNCTION fnc_n_tuplo_input_sensor (
    input_string IN VARCHAR2,
    item_number IN NUMBER
)
RETURN VARCHAR2
AS
   idSensor VARCHAR2(5);
   tipoSensor VARCHAR2(2);
   valorLido VARCHAR2(3);
   valorReferencia VARCHAR2(10);
   instanteLeitura VARCHAR2(5);
BEGIN
    CASE item_number
        WHEN 1 THEN
            idSensor := SUBSTR(input_string, 1, 5);
            RETURN idSensor;
        WHEN 2 THEN
            tipoSensor := SUBSTR(input_string, 6, 2);
            RETURN tipoSensor;
        WHEN 3 THEN
            valorLido := SUBSTR(input_string, 8, 3);
            RETURN valorLido;
        WHEN 4 THEN
            valorReferencia := SUBSTR(input_string, 11, 10);
            RETURN valorReferencia;
        WHEN 5 THEN
            instanteLeitura := SUBSTR(input_string, 21, 5);
            RETURN instanteLeitura;
        ELSE
          RETURN NULL;
    END CASE;
END;
/

--Verificar
SELECT fnc_n_tuplo_input_sensor('62943HS078783897638710:35',1) FROM DUAL;
SELECT fnc_n_tuplo_input_sensor('62943HS078783897638710:35',2) FROM DUAL;
SELECT fnc_n_tuplo_input_sensor('62943HS078783897638710:35',3) FROM DUAL;
SELECT fnc_n_tuplo_input_sensor('62943HS078783897638710:35',4) FROM DUAL;
SELECT fnc_n_tuplo_input_sensor('62943HS078783897638710:35',5) FROM DUAL;


--Obter todos os registos da tabela INPUT_SENSOR
CREATE OR REPLACE FUNCTION fnc_get_input_sensor
RETURN SYS_REFCURSOR    
IS  
    input_sensor_rows SYS_REFCURSOR;
BEGIN
    open input_sensor_rows for
        SELECT INPUT_STRING 
        FROM INPUT_SENSOR;
    
    RETURN input_sensor_rows;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END;
/

--Verificar se o sensor ja existe
CREATE OR REPLACE FUNCTION fnc_check_sensor_exist(
    id_sensor_param IN SENSOR.IDSENSOR%TYPE
)
RETURN integer    
IS  
    sensor_exist integer;
BEGIN
    SELECT COUNT(*) INTO sensor_exist
    FROM SENSOR
    WHERE IDSENSOR = id_sensor_param;
    
    RETURN sensor_exist;
END;
/

--Verificar se o valor de referencia ja existe
CREATE OR REPLACE FUNCTION fnc_check_sensor_reference_exist(
    valor_referencia_param IN SENSOR.VALORREFERENCIA%TYPE
)
RETURN integer    
IS  
    valor_referencia_exist integer;
BEGIN
    SELECT COUNT(*) INTO valor_referencia_exist
    FROM SENSOR
    WHERE VALORREFERENCIA = valor_referencia_param;
    
    RETURN valor_referencia_exist;
END;
/

--Verificar se o sensor que ja existe e o mesmo
CREATE OR REPLACE FUNCTION fnc_is_same_sensor(
    id_sensor_param IN SENSOR.IDSENSOR%TYPE,
    tipo_sensor_param IN SENSOR.TIPOSENSOR%TYPE,
    valor_referencia_param IN SENSOR.VALORREFERENCIA%TYPE
)
RETURN integer    
IS  
    is_same_sensor integer;
BEGIN
    SELECT COUNT(*) INTO is_same_sensor
    FROM SENSOR
    WHERE IDSENSOR = id_sensor_param AND TIPOSENSOR = tipo_sensor_param AND VALORREFERENCIA = valor_referencia_param;
    
    RETURN is_same_sensor;
END;
/

--Verificar se o valor lido esta entre 0 e 100
CREATE OR REPLACE FUNCTION fnc_validate_valor_lido(
    valor_lido_param IN SENSORMEDICOES.VALORLIDO%TYPE
)
RETURN integer    
IS  
    is_same_sensor integer;
BEGIN
    IF to_number(valor_lido_param) >= 0 AND to_number(valor_lido_param) <= 100 THEN
        return 1;
    END IF;
    
    RETURN NULL;
EXCEPTION
    WHEN others THEN
        RETURN NULL;
END;
/

--Verificar se o tipo de sensor e valido
CREATE OR REPLACE FUNCTION fnc_check_tipo_sensor (
    tipo_sensor_param IN SENSOR.TIPOSENSOR%TYPE
)
RETURN integer
AS

BEGIN
    IF lower(tipo_sensor_param) IN ('hs', 'pl', 'ts', 'vv', 'ta', 'ha', 'pa') THEN
        RETURN 1;
    END IF;

    RETURN 0;
END;
/

--Inserir ou atualizar o numero de erros de um sensor num processo
CREATE OR REPLACE PROCEDURE prc_insert_update_error_sensor (
    id_processo_leitura_param IN PROCESSOLEITURASENSOR.IDPROCESSOLEITURA%TYPE,
    id_sensor_param IN SENSOR.IDSENSOR%TYPE
)
AS
    sensor_already_have_error integer;
    n_errors_sensor PROCESSOLEITURASENSOR.NUMERROS%TYPE;
BEGIN
    SELECT COUNT(*) INTO sensor_already_have_error
    FROM PROCESSOLEITURASENSOR
    WHERE IDPROCESSOLEITURA = id_processo_leitura_param AND IDSENSOR = id_sensor_param;
    
    IF sensor_already_have_error = 0 THEN
        Insert into PROCESSOLEITURASENSOR (IDPROCESSOLEITURA,IDSENSOR,NUMERROS) 
        values (id_processo_leitura_param,id_sensor_param,1);
    ELSE
        UPDATE PROCESSOLEITURASENSOR
        SET NUMERROS = NUMERROS + 1
        WHERE IDPROCESSOLEITURA = id_processo_leitura_param AND IDSENSOR = id_sensor_param;
    END IF;
END;
/

--Atualizar a tabela Sensor e SensorMedicoes baseado na tabela INPUT_SENSOR
CREATE OR REPLACE PROCEDURE prc_update_tables_by_input_sensor(
    id_processo_leitura IN PROCESSOLEITURA.IDPROCESSOLEITURA%TYPE
) 
IS  
    input_sensor_rows SYS_REFCURSOR;
    INPUT_STRING_VAR INPUT_SENSOR.INPUT_STRING%TYPE;
    idSensor_var VARCHAR2(5);
    tipoSensor_var VARCHAR2(2);
    valorReferencia_var VARCHAR2(10);
    valorLido_var VARCHAR2(3);
    instanteLeitura_var VARCHAR2(5);
    id_medicao_inserted SENSORMEDICOES.IDMEDICAO%TYPE;
BEGIN
    input_sensor_rows := fnc_get_input_sensor();
    
    LOOP
        fetch input_sensor_rows into INPUT_STRING_VAR;
        exit when input_sensor_rows%notfound;
        
        idSensor_var := fnc_n_tuplo_input_sensor(INPUT_STRING_VAR,1);
        
        IF fnc_check_sensor_exist(idSensor_var) = 0 THEN
            valorReferencia_var := fnc_n_tuplo_input_sensor(INPUT_STRING_VAR,4);
            
            IF fnc_check_sensor_reference_exist(valorReferencia_var) = 0 THEN
                tipoSensor_var := fnc_n_tuplo_input_sensor(INPUT_STRING_VAR,2);
                
                IF fnc_check_tipo_sensor(tipoSensor_var) = 1 THEN
                    Insert into SENSOR (IDSENSOR,TIPOSENSOR,VALORREFERENCIA) 
                    values (idSensor_var,tipoSensor_var,valorReferencia_var);
                    
                    valorLido_var := fnc_n_tuplo_input_sensor(INPUT_STRING_VAR,3);
                    
                    
                    IF fnc_validate_valor_lido(valorLido_var) = 1 THEN
                        instanteLeitura_var := fnc_n_tuplo_input_sensor(INPUT_STRING_VAR,5);
                        
                        Insert into SENSORMEDICOES (IDSENSOR,VALORLIDO,INSTANTELEITURA) 
                        values (idSensor_var, valorLido_var,to_date(instanteLeitura_var,'HH24:MI')) returning IDMEDICAO into id_medicao_inserted;
                        
                        
                        --DELETE 
                        --FROM INPUT_SENSOR
                        --WHERE INPUT_STRING = INPUT_STRING_VAR;
                        
                        dbms_output.put_line('SUCESSO| MEDICAO NO SENSOR COM O ID - ' || idSensor_var || ' ADICIONADA! ID MEDICAO - ' || id_medicao_inserted);
                    ELSE
                        prc_insert_update_error_sensor(id_processo_leitura, idSensor_var);
                        dbms_output.put_line('ERRO| SENSOR COM ID - ' || idSensor_var || ' LEU UM VALOR QUE NAO ESTA ENTRE 0 e 100');
                    END IF;
                ELSE
                    dbms_output.put_line('ERRO| NAO FOI POSSIVEL CRIAR O SENSOR COM ID - ' || idSensor_var || ' PORQUE O TIPO DE SENSOR E INVALIDO');
                END IF;
                
            ELSE
                dbms_output.put_line('ERRO| NAO FOI POSSIVEL CRIAR O SENSOR COM ID - ' || idSensor_var || ' PORQUE JA EXISTE O VALOR DE REFERENCIA DESTE SENSOR | VALOR DE REFERENCIA - ' || ' (' || valorReferencia_var || ')');
            END IF;
        
        ELSE
            tipoSensor_var := fnc_n_tuplo_input_sensor(INPUT_STRING_VAR,2);
            valorReferencia_var := fnc_n_tuplo_input_sensor(INPUT_STRING_VAR,4);
            
            IF fnc_is_same_sensor(idSensor_var, tipoSensor_var, valorReferencia_var) = 1 THEN
                valorLido_var := fnc_n_tuplo_input_sensor(INPUT_STRING_VAR,3);
                
                IF fnc_validate_valor_lido(valorLido_var) = 1 THEN
                    instanteLeitura_var := fnc_n_tuplo_input_sensor(INPUT_STRING_VAR,5);
                    
                    Insert into SENSORMEDICOES (IDSENSOR,VALORLIDO,INSTANTELEITURA) 
                    values (idSensor_var, valorLido_var,to_date(instanteLeitura_var,'HH24:MI')) returning IDMEDICAO into id_medicao_inserted;
                    
                        --DELETE 
                        --FROM INPUT_SENSOR
                        --WHERE INPUT_STRING = INPUT_STRING_VAR;
                    
                    dbms_output.put_line('SUCESSO| COMO O SENSOR COM O ID - ' || idSensor_var || ' JA EXISTE, APENAS FOI ADICIONADA UMA MEDICAO COM O ID - ' || id_medicao_inserted);           
                ELSE
                    prc_insert_update_error_sensor(id_processo_leitura, idSensor_var);
                    dbms_output.put_line('ERRO| SENSOR COM ID - ' || idSensor_var || ' LEU UM VALOR QUE NAO ESTA ENTRE 0 e 100');
                END IF;
                
            ELSE
                prc_insert_update_error_sensor(id_processo_leitura, idSensor_var);
                dbms_output.put_line('ERRO| SENSOR COM O MESMO ID - ' || idSensor_var || ' MAS COM VALOR DE REFERENCIA OU TIPO DE SENSOR DIFERENTES');
            END IF;
        
        END IF;
        
    END LOOP;
    CLOSE input_sensor_rows;
EXCEPTION
    WHEN others THEN
        dbms_output.put_line('NAO FOI POSSIVEL ATUALIZAR A TABELA DOS SENSOR, NEM A TABELA SENSOR MEDICOES!');
        dbms_output.put_line(SQLERRM);
END;
/


--Registar o processo da leitura de dados
CREATE OR REPLACE PROCEDURE prc_register_read_process 
IS  
    n_registos_lidos integer;
    n_registos_before_processo integer;
    n_registos_after_processo integer;
    n_registos_inseridos integer;
    n_erros integer;
    id_processo_leitura_inserted PROCESSOLEITURA.IDPROCESSOLEITURA%TYPE;
BEGIN
    SELECT COUNT(*) INTO n_registos_lidos
    FROM INPUT_SENSOR;
    
    SELECT COUNT(*) INTO n_registos_before_processo
    FROM SENSORMEDICOES;
    
    Insert into PROCESSOLEITURA (DATAHORA,NUMREGISTOSLIDOS) 
    values (to_date(SYSDATE,'YYYY-MM-DD HH24:MI'),n_registos_lidos) returning IDPROCESSOLEITURA into id_processo_leitura_inserted;
    
    prc_update_tables_by_input_sensor(id_processo_leitura_inserted);
    
    SELECT COUNT(*) INTO n_registos_after_processo
    FROM SENSORMEDICOES;
    
    n_registos_inseridos := n_registos_after_processo - n_registos_before_processo;
    n_erros := n_registos_lidos - n_registos_inseridos;
    
    UPDATE PROCESSOLEITURA
    SET NUMREGISTOSINSERIDOS = n_registos_inseridos, NUMERROS = n_erros
    WHERE IDPROCESSOLEITURA = id_processo_leitura_inserted;
    
    --Non breaking space
    dbms_output.put_line('');
    
    dbms_output.put_line('|----RESUMO DO PROCESSO----|');
    dbms_output.put_line('NUMERO TOTAL DE REGISTOS LIDOS - ' || n_registos_lidos);
    dbms_output.put_line('NUMERO DE REGISTOS TRANSFERIDOS - ' || n_registos_inseridos);
    dbms_output.put_line('NUMERO DE REGISTOS NAO TRANSFERIDOS - ' || n_erros);
EXCEPTION
    WHEN others THEN
        dbms_output.put_line('NAO FOI POSSIVEL REGISTAR O PROCESSO DE LEITURA DE DADOS!');
        dbms_output.put_line(SQLERRM);
END;
/



--FRONT-END
begin
    prc_register_read_process();
end;
/

--Verificar a tabela de sensores e as medicoes dos sensores
SELECT SENSOR.IDSENSOR, SENSOR.TIPOSENSOR, SENSOR.VALORREFERENCIA, 
        SENSORMEDICOES.VALORLIDO, TO_CHAR(SENSORMEDICOES.INSTANTELEITURA,'HH24:MI') AS "INSTANTELEITURA", SENSORMEDICOES.IDMEDICAO
FROM SENSOR
INNER JOIN SENSORMEDICOES ON
SENSOR.IDSENSOR = SENSORMEDICOES.IDSENSOR;

--Verificar a tabela de proocesso leitura
SELECT *
FROM PROCESSOLEITURA;

--Verificar numero de erros por sensor
SELECT *
FROM PROCESSOLEITURASENSOR;