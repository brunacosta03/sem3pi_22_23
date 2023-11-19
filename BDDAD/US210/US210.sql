--******************************************************
--* PARA RELIZAR TESTES POR FAVOR IMPORTAR O BOOTSTRAP *
--******************************************************

--BACK-END
--Separacao de uma string por ponto e virgula a retornar uma lista de numeros
CREATE OR REPLACE FUNCTION split_string_to_list_numbers(
            p_string IN VARCHAR2, 
            p_delimiter IN VARCHAR2 DEFAULT ';'
) 
RETURN sys.odcinumberlist 
IS
    l_string       LONG DEFAULT p_string || p_delimiter;
    l_numbers      sys.odcinumberlist := sys.odcinumberlist();
BEGIN
    LOOP
        EXIT WHEN l_string IS NULL;
        l_numbers.EXTEND;
        l_numbers(l_numbers.LAST) := LTRIM(RTRIM(SUBSTR(l_string, 1, INSTR(l_string, p_delimiter) - 1)));
        l_string := SUBSTR(l_string, INSTR(l_string, p_delimiter) + 1);
    END LOOP;
    RETURN l_numbers;
END;
/

--Separacao de uma string por ponto e virgula a retornar uma lista de strings
CREATE OR REPLACE FUNCTION split_string_to_list_stings(
            p_string IN VARCHAR2, 
            p_delimiter IN VARCHAR2 DEFAULT ';'
) 
RETURN sys.odcivarchar2list 
IS
    l_string       LONG DEFAULT p_string || p_delimiter;
    l_strings      sys.odcivarchar2list := sys.odcivarchar2list();
BEGIN
    LOOP
        EXIT WHEN l_string IS NULL;
        l_strings.EXTEND;
        l_strings(l_strings.LAST) := LTRIM(RTRIM(SUBSTR(l_string, 1, INSTR(l_string, p_delimiter) - 1)));
        l_string := SUBSTR(l_string, INSTR(l_string, p_delimiter) + 1);
    END LOOP;
    RETURN l_strings;
END;
/


--Verificar se nao vai contra as restricoes
CREATE OR REPLACE FUNCTION fnc_check_restrictions (
        id_setor_param IN RESTRICOESSETORFATORPRODUCAO.IDSETOR%TYPE,
        id_fator_producao_param IN RESTRICOESSETORFATORPRODUCAO.IDFATORPRODUCAO%TYPE,
        data_realizacao_param IN OperacoesAgricolas.DATAREALIZACAO%TYPE
)
RETURN RESTRICOESSETORFATORPRODUCAO.IDRESTRICAO%TYPE
IS  
    id_restricao RESTRICOESSETORFATORPRODUCAO.IDRESTRICAO%TYPE;
    data_inicio_restricao RESTRICOESSETORFATORPRODUCAO.DATAINICIORESTRICAO%TYPE;
    data_fim_restricao RESTRICOESSETORFATORPRODUCAO.DATAFIMRESTRICAO%TYPE;
BEGIN
    SELECT IDRESTRICAO, DATAINICIORESTRICAO, DATAFIMRESTRICAO INTO id_restricao, data_inicio_restricao, data_fim_restricao 
    FROM RESTRICOESSETORFATORPRODUCAO
    WHERE IDSETOR = id_setor_param AND IDFATORPRODUCAO = id_fator_producao_param
    AND DATAINICIORESTRICAO <= data_realizacao_param AND DATAFIMRESTRICAO >= data_realizacao_param;
    
    RETURN id_restricao;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END;
/

--Registar operacao no calendario a ser realizada uma determinada data, verificando se nao vai contra as restricoes
CREATE OR REPLACE PROCEDURE prc_create_calendar_operation (
    id_setor_param IN OPERACOESAGRICOLAS.IDSETOR %TYPE,
    tipo_operacao_param IN OPERACOESAGRICOLAS.TIPOOPERACAO%TYPE,
    data_realizacao_param IN OPERACOESAGRICOLAS.DATAREALIZACAO%TYPE,
    fatores_producao_param IN VARCHAR2,
    quantidades_fatores_producao_param IN VARCHAR2,
    aplicacao_fatores_producao_param IN VARCHAR2
)
IS  
    id_operacao_inserted OPERACOESAGRICOLAS.IDOPERACAO%TYPE;
    id_restricao RESTRICOESSETORFATORPRODUCAO.IDRESTRICAO%TYPE;
    fatores_producao sys.odcinumberlist;
    quantidades_fatores_producao sys.odcinumberlist;
    aplicacao_fatores_producao sys.odcivarchar2list;
    valores_errados INTEGER;
BEGIN
    valores_errados := 0;
    fatores_producao := split_string_to_list_numbers(fatores_producao_param);
    quantidades_fatores_producao := split_string_to_list_numbers(quantidades_fatores_producao_param);
    aplicacao_fatores_producao := split_string_to_list_stings(aplicacao_fatores_producao_param);
    
    --Verificar se temos o mesmo numero de campos para fatores de producao, quantidade e aplicacao
    IF fatores_producao.COUNT = quantidades_fatores_producao.COUNT AND quantidades_fatores_producao.COUNT = aplicacao_fatores_producao.COUNT THEN
        FOR i IN 1..fatores_producao.COUNT LOOP
            id_restricao := fnc_check_restrictions(id_setor_param, fatores_producao(i), data_realizacao_param);
            
            IF id_restricao IS NOT NULL THEN
                valores_errados := 1;
            
                dbms_output.put_line('A OPERACAO NO SETOR COM O ID - ' || id_setor_param || 
                ' DO FATOR DE PRODUCAO COM ID - ' || fatores_producao(i) || ' NO DIA - ' || data_realizacao_param 
                || ' NAO PODE SER REALIZADA, POIS INFRINGE A RESTRICAO COM ID - ' || id_restricao);
            END IF;
            
        END LOOP;
    ELSE
        RAISE_APPLICATION_ERROR(-20000, 'O NUMERO DE FATORES DE PRODUCAO, QUANTIDADE DOS FATORES DE PRODUCAO E APLICACAO DOS FATORES DE PRODUCAO PRECISA DE SER IGUAL!');
    END IF;
    
    IF valores_errados = 0 THEN
        Insert into OPERACOESAGRICOLAS (IDSETOR,TIPOOPERACAO,DATAREALIZACAO,ESTADOOPERACAO) 
        values (id_setor_param, tipo_operacao_param, data_realizacao_param, 'agendada') returning IDOPERACAO into id_operacao_inserted;
        
        dbms_output.put_line('OPERACAO AGENDADA COM O ID - ' || id_operacao_inserted);
        
        FOR i IN 1..fatores_producao.COUNT LOOP
            Insert into OPERACAOFATORESPRODUCAOAPLICADOS (IDOPERACAO,IDFATORPRODUCAO,QUANTIDADEAPLICADA,FORMAAPLICACAO) 
            values (id_operacao_inserted, fatores_producao(i), quantidades_fatores_producao(i), aplicacao_fatores_producao(i));
            
            dbms_output.put_line('ADICIONADO O FATOR DE PRODUCAO A SER APLICADO - ' || fatores_producao(i)
            || ' COM A QUANTIDADE - ' || quantidades_fatores_producao(i) || ' A FORMA DE APLICACAO E - ' || aplicacao_fatores_producao(i));
        END LOOP;
    ELSE    
        RAISE_APPLICATION_ERROR(-20000, 'ALTERE OS FATORES DE PRODUCAO E TENTE NOVAMENTE');
    END IF;

EXCEPTION
    WHEN others THEN
        dbms_output.put_line('NAO FOI POSSIVEL AGENDAR A OPERACAO!');
        dbms_output.put_line(SQLERRM);
END;
/

--Front-END
--Nao existe restricao para este fator de producao nestas datas, logo vai ser inserido
BEGIN
    prc_create_calendar_operation(
        '10',
        'adubação',
        '23.02.02',
        '5;2;1',
        '11,3;5,8;7,2',
        'no solo;no solo;no solo'
    );
END;
/

--Apresenta erro, pois existe uma restricao para este fator de producao no setor indicado para data pedida
BEGIN
    prc_create_calendar_operation(
        '10',
        'adubação',
        '23.01.10',
        '2',
        '11,3',
        'no solo'
    );
END;
/

--Verificar
SELECT * FROM OPERACOESAGRICOLAS OA
INNER JOIN OPERACAOFATORESPRODUCAOAPLICADOS OFPA ON
OA.IDOPERACAO = OFPA.IDOPERACAO
WHERE OA.IDOPERACAO = 14;

SELECT * FROM RESTRICOESSETORFATORPRODUCAO
WHERE IDSETOR = 10 AND IDFATORPRODUCAO = 2;



--BACK-END
--Obter as operacoes que estao agendadas para a semana pedida
CREATE OR REPLACE FUNCTION fnc_get_week_operations (
        start_week_data_param IN OPERACOESAGRICOLAS.DATAREALIZACAO%TYPE
)
RETURN SYS_REFCURSOR
IS  
    calendar_operations SYS_REFCURSOR;
BEGIN
    open calendar_operations for
        SELECT OA.IDOPERACAO, OA.IDSETOR, OFPA.IDFATORPRODUCAO, OA.DATAREALIZACAO 
        FROM OPERACOESAGRICOLAS OA
        INNER JOIN OPERACAOFATORESPRODUCAOAPLICADOS OFPA ON
        OA.IDOPERACAO = OFPA.IDOPERACAO
        WHERE start_week_data_param <= OA.DATAREALIZACAO AND (to_date(start_week_data_param) + 7) >= start_week_data_param
        AND OA.ESTADOOPERACAO = 'agendada';
    
    RETURN calendar_operations;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END;
/


--Verificar as operacoes que estao agendadas mas violam as restricoes na semana pedida
CREATE OR REPLACE PROCEDURE prc_show_operations_with_restriction(
    start_week_data_param IN OperacoesAgricolas.DATAREALIZACAO%TYPE
)
IS
    calendar_operations SYS_REFCURSOR;
    IDOPERACAO OPERACOESAGRICOLAS.IDOPERACAO%type;
    IDSETOR OPERACOESAGRICOLAS.IDSETOR%type;
    IDFATORPRODUCAO OPERACAOFATORESPRODUCAOAPLICADOS.IDFATORPRODUCAO%type;
    DATAREALIZACAO OPERACOESAGRICOLAS.DATAREALIZACAO%type;
    id_restricao RESTRICOESSETORFATORPRODUCAO.IDRESTRICAO%TYPE;
BEGIN
    calendar_operations := fnc_get_week_operations(start_week_data_param);
    
    LOOP
        fetch calendar_operations into IDOPERACAO, IDSETOR, IDFATORPRODUCAO, DATAREALIZACAO ;
        exit when calendar_operations%notfound;
        
        id_restricao := fnc_check_restrictions(IDSETOR, IDFATORPRODUCAO, DATAREALIZACAO);
        
        
        IF id_restricao IS NOT NULL THEN
            dbms_output.put_line('A OPERACAO COM ID - ' || IDOPERACAO || 
            ' A REALIZAR NO SETOR COM O ID - ' || IDSETOR || 
            ' DO FATOR DE PRODUCAO COM ID - ' || IDFATORPRODUCAO || ' NO DIA - ' || DATAREALIZACAO 
            || ' NAO PODE SER REALIZADA, POIS INFRINGE A RESTRICAO COM ID - ' || id_restricao);
        END IF;
        
    END LOOP;
    CLOSE calendar_operations;
END;
/

--FRONT-END
begin
    prc_show_operations_with_restriction('22.12.20');
end;
/



--Verificar
SELECT OA.IDOPERACAO, OA.ESTADOOPERACAO, OA.IDSETOR, OA.TIPOOPERACAO, OFPA.IDFATORPRODUCAO, 
        OFPA.FORMAAPLICACAO, OFPA.QUANTIDADEAPLICADA, OA.DATAREALIZACAO,
        RSFP.IDRESTRICAO, RSFP.DATAINICIORESTRICAO, RSFP.DATAFIMRESTRICAO
FROM OPERACOESAGRICOLAS OA
INNER JOIN OPERACAOFATORESPRODUCAOAPLICADOS OFPA ON
OA.IDOPERACAO = OFPA.IDOPERACAO
INNER JOIN RESTRICOESSETORFATORPRODUCAO RSFP ON
RSFP.IDSETOR = OA.IDSETOR 
AND RSFP.IDFATORPRODUCAO = OFPA.IDFATORPRODUCAO
WHERE '22.12.20' <= OA.DATAREALIZACAO AND (to_date('22.12.20') + 7) >= OA.DATAREALIZACAO
AND RSFP.DATAINICIORESTRICAO <= OA.DATAREALIZACAO AND RSFP.DATAFIMRESTRICAO >= OA.DATAREALIZACAO
AND OA.ESTADOOPERACAO = 'agendada';





--Listar as restricoes de fatores de producao de um determinado Setor numa Determinada Data
--BACK-END
CREATE OR REPLACE FUNCTION fnc_get_restrictions_by_setor_and_day(
        id_setor_param IN RESTRICOESSETORFATORPRODUCAO.IDSETOR%TYPE,
        id_gestor_agricola_param IN SETOR.IDGESTORAGRICOLA%TYPE,
        date_param IN RESTRICOESSETORFATORPRODUCAO.DATAINICIORESTRICAO%TYPE
)
RETURN SYS_REFCURSOR
IS  
    fator_producao_restrictions SYS_REFCURSOR;
BEGIN
    open fator_producao_restrictions for
        SELECT RSFP.IDRESTRICAO, RSFP.IDSETOR, RSFP.IDFATORPRODUCAO, RSFP.DATAINICIORESTRICAO, RSFP.DATAFIMRESTRICAO
        FROM RESTRICOESSETORFATORPRODUCAO RSFP
        INNER JOIN SETOR S ON
        RSFP.IDSETOR = S.IDSETOR
        WHERE RSFP.IDSETOR = id_setor_param AND S.IDGESTORAGRICOLA = id_gestor_agricola_param
        AND date_param BETWEEN RSFP.DATAINICIORESTRICAO AND RSFP.DATAFIMRESTRICAO;
    
    RETURN fator_producao_restrictions;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END;
/


CREATE OR REPLACE PROCEDURE prc_show_restrictions_by_setor_and_day(
        id_setor_param IN RESTRICOESSETORFATORPRODUCAO.IDSETOR%TYPE,
        id_gestor_agricola_param IN SETOR.IDGESTORAGRICOLA%TYPE,
        date_param IN RESTRICOESSETORFATORPRODUCAO.DATAINICIORESTRICAO%TYPE
)
IS
    fator_producao_restrictions SYS_REFCURSOR;
    IDRESTRICAO RESTRICOESSETORFATORPRODUCAO.IDRESTRICAO%type;
    IDSETOR RESTRICOESSETORFATORPRODUCAO.IDSETOR%type;
    IDFATORPRODUCAO RESTRICOESSETORFATORPRODUCAO.IDFATORPRODUCAO%type;
    DATAINICIORESTRICAO RESTRICOESSETORFATORPRODUCAO.DATAINICIORESTRICAO%type;
    DATAFIMRESTRICAO RESTRICOESSETORFATORPRODUCAO.DATAFIMRESTRICAO%type;
BEGIN
    fator_producao_restrictions := fnc_get_restrictions_by_setor_and_day(id_setor_param, id_gestor_agricola_param, date_param);
    
    LOOP
        fetch fator_producao_restrictions into IDRESTRICAO, IDSETOR, IDFATORPRODUCAO, DATAINICIORESTRICAO, DATAFIMRESTRICAO;
        exit when fator_producao_restrictions%notfound;
        

        dbms_output.put_line('RESTRICAO COM O ID - ' || IDRESTRICAO || 
        ' NO SETOR COM O ID - ' || IDSETOR || ' DO FATOR DE PRODUCAO COM ID - ' || 
        IDFATORPRODUCAO || ' ENTRE OS DIAS - (' || DATAINICIORESTRICAO || ' - ' || DATAFIMRESTRICAO || ')');
        
    END LOOP;
    CLOSE fator_producao_restrictions;
END;
/

--FRONT-END
BEGIN
    prc_show_restrictions_by_setor_and_day(
        '10',
        '10',
        '22.12.27'
    );
END;
/


--Verificar
SELECT * 
FROM RESTRICOESSETORFATORPRODUCAO RSFP
INNER JOIN SETOR S ON
RSFP.IDSETOR = S.IDSETOR
WHERE RSFP.IDSETOR = 10 AND S.IDGESTORAGRICOLA = 10
AND '22.12.27' BETWEEN RSFP.DATAINICIORESTRICAO AND RSFP.DATAFIMRESTRICAO;




--Listar por ordem cronologica todas as operacoes de uma exploracao agricola dado um SETOR, um PERIODO de tempo
--BACK-END
CREATE OR REPLACE FUNCTION fnc_get_agricultural_operations(
        id_setor_param IN OPERACOESAGRICOLAS.IDSETOR%TYPE,
        id_gestor_agricola_param IN SETOR.IDGESTORAGRICOLA%TYPE,
        start_date_param IN OPERACOESAGRICOLAS.DATAREALIZACAO%TYPE,
        end_date_param IN OPERACOESAGRICOLAS.DATAREALIZACAO%TYPE
)
RETURN SYS_REFCURSOR
IS  
    agricultural_operations SYS_REFCURSOR;
BEGIN
    open agricultural_operations for
        SELECT OA.IDOPERACAO, OA.IDSETOR, OA.TIPOOPERACAO, OA.DATAREALIZACAO, OA.ESTADOOPERACAO, 
                OFPA.IDFATORPRODUCAO, OFPA.QUANTIDADEAPLICADA, OFPA.FORMAAPLICACAO
        FROM OPERACOESAGRICOLAS OA
        INNER JOIN SETOR S ON
        OA.IDSETOR = S.IDSETOR
        INNER JOIN OPERACAOFATORESPRODUCAOAPLICADOS OFPA ON
        OA.IDOPERACAO = OFPA.IDOPERACAO
        WHERE S.IDGESTORAGRICOLA = id_gestor_agricola_param AND OA.IDSETOR = id_setor_param
        AND start_date_param <= OA.DATAREALIZACAO AND end_date_param >= OA.DATAREALIZACAO
        ORDER BY OA.DATAREALIZACAO ASC, OA.IDSETOR ASC;
    
    RETURN agricultural_operations;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END;
/


CREATE OR REPLACE PROCEDURE prc_show_restrictions_by_setor_and_day(
        id_setor_param IN OPERACOESAGRICOLAS.IDSETOR%TYPE,
        id_gestor_agricola_param IN SETOR.IDGESTORAGRICOLA%TYPE,
        start_date_param IN OPERACOESAGRICOLAS.DATAREALIZACAO%TYPE,
        end_date_param IN OPERACOESAGRICOLAS.DATAREALIZACAO%TYPE
)
IS
    agricultural_operations SYS_REFCURSOR;
    IDOPERACAO OPERACOESAGRICOLAS.IDOPERACAO%type;
    IDSETOR OPERACOESAGRICOLAS.IDSETOR%type;
    TIPOOPERACAO OPERACOESAGRICOLAS.TIPOOPERACAO%type;
    DATAREALIZACAO OPERACOESAGRICOLAS.DATAREALIZACAO%type;
    ESTADOOPERACAO OPERACOESAGRICOLAS.ESTADOOPERACAO%type;
    IDFATORPRODUCAO OPERACAOFATORESPRODUCAOAPLICADOS.IDFATORPRODUCAO%type;
    QUANTIDADEAPLICADA OPERACAOFATORESPRODUCAOAPLICADOS.QUANTIDADEAPLICADA%type;
    FORMAAPLICACAO OPERACAOFATORESPRODUCAOAPLICADOS.FORMAAPLICACAO%type;
BEGIN
    agricultural_operations := fnc_get_agricultural_operations(id_setor_param, id_gestor_agricola_param, start_date_param, end_date_param);
    
    LOOP
        fetch agricultural_operations into IDOPERACAO, IDSETOR, TIPOOPERACAO, DATAREALIZACAO, ESTADOOPERACAO, IDFATORPRODUCAO, QUANTIDADEAPLICADA, FORMAAPLICACAO;
        exit when agricultural_operations%notfound;
        

        dbms_output.put_line('ID DA OPERACAO - ' || IDOPERACAO || 
        ' | ID DO SETOR - ' || IDSETOR || ' | TIPO DE OPERACAO - ' || 
        TIPOOPERACAO || ' | DATA REALIZACAO - ' || DATAREALIZACAO || ' | ESTADOOPERACAO - ' || ESTADOOPERACAO
        || ' | ID FATOR DE PRODUCAO - ' || IDFATORPRODUCAO || ' | QUANTIDADE APLICADA - ' || QUANTIDADEAPLICADA
        || ' | FORMA DE APLICACAO - ' || FORMAAPLICACAO);
        
    END LOOP;
    CLOSE agricultural_operations;
END;
/

--FRONT-END
BEGIN
    prc_show_restrictions_by_setor_and_day(
        '10',
        '10',
        '22.10.10',
        '23.02.10'
    );
END;
/


--Verificar
SELECT * 
FROM OPERACOESAGRICOLAS OA
INNER JOIN SETOR S ON
OA.IDSETOR = S.IDSETOR
INNER JOIN OPERACAOFATORESPRODUCAOAPLICADOS OFPA ON
OA.IDOPERACAO = OFPA.IDOPERACAO
WHERE S.IDGESTORAGRICOLA = 10 AND OA.IDSETOR = 10
AND '22.10.10' <= OA.DATAREALIZACAO AND '23.02.10' >= OA.DATAREALIZACAO
ORDER BY OA.DATAREALIZACAO ASC, OA.IDSETOR ASC;