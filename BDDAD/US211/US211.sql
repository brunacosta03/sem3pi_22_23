--**
--* PARA REALIZAR TESTES POR FAVOR IMPORTAR O BOOTSTRAP *
--**

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
CREATE OR REPLACE FUNCTION SPLIT_STRING_TO_LIST_STRINGS(
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

CREATE OR REPLACE PROCEDURE prc_cancel_operation(
    idOperacao_param IN OPERACOESAGRICOLAS.IDOPERACAO%TYPE
)
IS
    estado OPERACOESAGRICOLAS.ESTADOOPERACAO%TYPE;
BEGIN
    SELECT ESTADOOPERACAO INTO estado FROM OPERACOESAGRICOLAS WHERE IDOPERACAO = idOperacao_param;

    IF lower(estado) != 'realizada' THEN
        UPDATE OPERACOESAGRICOLAS SET ESTADOOPERACAO = 'cancelada' WHERE idOperacao = idOperacao_param;
        dbms_output.put_line('Operação cancelada com sucesso!');
    ELSE
        dbms_output.put_line('Operação já realizada, não é possível cancelar!');
    END IF;
END;
/

-- Executar função
begin
    prc_cancel_operation(3);
end;
/

-- Verificar
SELECT *
FROM OPERACOESAGRICOLAS
WHERE IDOPERACAO = 3;

CREATE OR REPLACE PROCEDURE prc_update_operation(
idOperacao_param IN OPERACOESAGRICOLAS.IDOPERACAO%TYPE,
dataRealizacao_param IN OPERACOESAGRICOLAS.DATAREALIZACAO%TYPE,
tipoOperacao_param IN OPERACOESAGRICOLAS.TIPOOPERACAO%TYPE,
idFatorProducao_param IN OPERACAOFATORESPRODUCAOAPLICADOS.IDFATORPRODUCAO%TYPE,
quantidadeAplicacao_param IN OPERACAOFATORESPRODUCAOAPLICADOS.QUANTIDADEAPLICADA%TYPE,
formaAplicacao_param IN OPERACAOFATORESPRODUCAOAPLICADOS.FORMAAPLICACAO%TYPE
) IS
    estado OPERACOESAGRICOLAS.ESTADOOPERACAO%TYPE;

BEGIN
    SELECT estadoOperacao INTO estado FROM OPERACOESAGRICOLAS WHERE idOperacao = idOperacao_param;
    IF lower(estado) != 'realizada' OR lower(estado) != 'cancelada' THEN
        UPDATE OPERACOESAGRICOLAS SET dataRealizacao = dataRealizacao_param, tipoOperacao = tipoOperacao_param WHERE idOperacao = idOperacao_param;
        UPDATE OPERACAOFATORESPRODUCAOAPLICADOS SET quantidadeAplicada = quantidadeAplicacao_param, formaAplicacao = formaAplicacao_param WHERE idOperacao = idOperacao_param AND idFatorProducao = idFatorProducao_param;
        dbms_output.put_line('Operação atualizada com sucesso!');
    ELSE
        dbms_output.put_line('Operação já realizada, não é possível atualizar!');
    END IF;
END;
/
--Executar função
begin
    prc_update_operation(
        3,
        '2022-12-16',
        'adubação',
        1,
        10,
        'no solo'
    );
end;
/

--Verificar
SELECT *
FROM OPERACOESAGRICOLAS
INNER JOIN OPERACAOFATORESPRODUCAOAPLICADOS ON
OPERACOESAGRICOLAS.IDOPERACAO = OPERACAOFATORESPRODUCAOAPLICADOS.IDOPERACAO
WHERE OPERACOESAGRICOLAS.IDOPERACAO = 4;


CREATE OR REPLACE PROCEDURE prc_update_operation_date(
    idOperacao_param IN OPERACOESAGRICOLAS.IDOPERACAO%TYPE,
    dataRealizacao_param IN OPERACOESAGRICOLAS.DATAREALIZACAO%TYPE
) IS
   estado OPERACOESAGRICOLAS.ESTADOOPERACAO%TYPE;
BEGIN
    SELECT estadoOperacao INTO estado FROM OPERACOESAGRICOLAS WHERE idOperacao = idOperacao_param;
    IF lower(estado) != 'realizada' OR lower(estado) != 'cancelada' THEN
        UPDATE OPERACOESAGRICOLAS SET dataRealizacao = dataRealizacao_param WHERE idOperacao = idOperacao_param;
        dbms_output.put_line('Data da operação atualizada com sucesso!');
    ELSE
        dbms_output.put_line('Não é possível atualizar a data porque a operação foi cancelada ou já foi realizada!');
    END IF;
END;
/
-- Executar função
begin
    prc_update_operation_date(4, '2022-12-26');
end;
/

-- Verificar
SELECT *
FROM OPERACOESAGRICOLAS
WHERE IDOPERACAO = 4;


CREATE OR REPLACE PROCEDURE prc_update_operation_type(
    idOperacao_param IN OPERACOESAGRICOLAS.IDOPERACAO%TYPE,
    tipoOperacao_param IN OPERACOESAGRICOLAS.TIPOOPERACAO%TYPE
) IS
    estado OPERACOESAGRICOLAS.ESTADOOPERACAO%TYPE;
BEGIN
    SELECT estadoOperacao INTO estado FROM OPERACOESAGRICOLAS WHERE idOperacao = idOperacao_param;
    IF lower(estado) != 'realizada' OR lower(estado) != 'cancelada' THEN
        UPDATE OPERACOESAGRICOLAS SET tipoOperacao = tipoOperacao_param WHERE idOperacao = idOperacao_param;
        dbms_output.put_line('Tipo da operação atualizada com sucesso!');
    ELSE
        dbms_output.put_line('Não é possível atualizar o tipo da operação porque a operação foi cancelada ou já foi realizada!');
    END IF;
END;
/

-- Executar função
begin
    prc_update_operation_type(4, 'adubação');
end;
/

-- Verificar

SELECT *
FROM OPERACOESAGRICOLAS
WHERE IDOPERACAO = 4;


CREATE OR REPLACE PROCEDURE prc_update_operation_quantity(
    idOperacao_param IN OPERACOESAGRICOLAS.IDOPERACAO%TYPE,
    idFatorProducao_param IN OPERACAOFATORESPRODUCAOAPLICADOS.IDFATORPRODUCAO%TYPE,
    quantidade_param IN OPERACAOFATORESPRODUCAOAPLICADOS.QUANTIDADEAPLICADA%TYPE
) IS
    estado OPERACOESAGRICOLAS.ESTADOOPERACAO%TYPE;
BEGIN
    SELECT estadoOperacao INTO estado FROM OPERACOESAGRICOLAS WHERE idOperacao = idOperacao_param;
    IF lower(estado) != 'realizada' OR lower(estado) != 'cancelada' THEN
        UPDATE OPERACAOFATORESPRODUCAOAPLICADOS SET quantidadeAplicada = quantidade_param WHERE idOperacao = idOperacao_param AND idFatorProducao = idFatorProducao_param;
        dbms_output.put_line('Quantidade da operação atualizada com sucesso!');
    ELSE
        dbms_output.put_line('Não é possível atualizar a quantidade da operação porque a operação foi cancelada ou já foi realizada!');
    END IF;
END;
/

-- Executar função
begin
    prc_update_operation_quantity(4, '7', '12');
end;
/

-- Verificar
SELECT *
FROM OPERACOESAGRICOLAS
INNER JOIN OPERACAOFATORESPRODUCAOAPLICADOS ON
OPERACOESAGRICOLAS.IDOPERACAO = OPERACAOFATORESPRODUCAOAPLICADOS.IDOPERACAO
WHERE OPERACOESAGRICOLAS.IDOPERACAO = 4;

CREATE OR REPLACE PROCEDURE prc_update_operation_application(
    idOperacao_param IN OPERACOESAGRICOLAS.IDOPERACAO%TYPE,
    idFatorProducao_param IN OPERACAOFATORESPRODUCAOAPLICADOS.IDFATORPRODUCAO%TYPE,
    formaAplicacao_param IN OPERACAOFATORESPRODUCAOAPLICADOS.FORMAAPLICACAO%TYPE
) IS
    estado OPERACOESAGRICOLAS.ESTADOOPERACAO%TYPE;
BEGIN
    SELECT estadoOperacao INTO estado FROM OPERACOESAGRICOLAS WHERE idOperacao = idOperacao_param;
    IF lower(estado) != 'realizada' OR lower(estado) != 'cancelada' THEN
        UPDATE OPERACAOFATORESPRODUCAOAPLICADOS SET formaAplicacao = formaAplicacao_param WHERE idOperacao = idOperacao_param AND idFatorProducao = idFatorProducao_param;
        dbms_output.put_line('Forma de aplicação da operação atualizada com sucesso!');
    ELSE
        dbms_output.put_line('Não é possível atualizar a forma de aplicação da operação porque a operação foi cancelada ou já foi realizada!');
    END IF;
END;
/

-- Executar função
begin
    prc_update_operation_application(4, '7', 'pulverização');
end;
/

-- Verificar
SELECT *
FROM OPERACOESAGRICOLAS
INNER JOIN OPERACAOFATORESPRODUCAOAPLICADOS ON
OPERACOESAGRICOLAS.IDOPERACAO = OPERACAOFATORESPRODUCAOAPLICADOS.IDOPERACAO
WHERE OPERACOESAGRICOLAS.IDOPERACAO = 4;

CREATE OR REPLACE PROCEDURE prc_update_operation_factors_production(
    idOperacao_param IN OPERACOESAGRICOLAS.IDOPERACAO%TYPE,
    fatores_producao_param IN VARCHAR2,
    quantidades_fatores_producao_param IN VARCHAR2,
    aplicacao_fatores_producao_param IN VARCHAR2,
    delete_fatores_producao_before IN NUMBER
) IS
    datar OPERACOESAGRICOLAS.DATAREALIZACAO%TYPE;
    setor OPERACOESAGRICOLAS.IDSETOR%TYPE;
    fatores_producao sys.odcinumberlist;
    quantidades_fatores_producao sys.odcinumberlist;
    aplicacao_fatores_producao sys.odcivarchar2list;
    id_restricao RESTRICOESSETORFATORPRODUCAO.IDRESTRICAO%TYPE;
BEGIN
    SELECT idSetor, dataRealizacao INTO setor, datar FROM OPERACOESAGRICOLAS WHERE idOperacao = idOperacao_param;

    IF delete_fatores_producao_before = 1 THEN
        DELETE FROM OPERACAOFATORESPRODUCAOAPLICADOS WHERE idOperacao = idOperacao_param;
    END IF;

    fatores_producao := split_string_to_list_numbers(fatores_producao_param);
    quantidades_fatores_producao := split_string_to_list_numbers(quantidades_fatores_producao_param);
    aplicacao_fatores_producao := split_string_to_list_strings(aplicacao_fatores_producao_param);

    FOR i IN 1..fatores_producao.COUNT LOOP
        id_restricao := fnc_check_restrictions(setor, fatores_producao(i), datar);
        IF id_restricao IS NULL THEN
            INSERT INTO OPERACAOFATORESPRODUCAOAPLICADOS (IDOPERACAO, IDFATORPRODUCAO, QUANTIDADEAPLICADA, FORMAAPLICACAO)
            VALUES (idOperacao_param, fatores_producao(i), quantidades_fatores_producao(i), aplicacao_fatores_producao(i));

            dbms_output.put_line('ADICIONADO O FATOR DE PRODUCAO A SER APLICADO - ' || fatores_producao(i)
            || ' COM A QUANTIDADE - ' || quantidades_fatores_producao(i) || ' A FORMA DE APLICACAO - ' || aplicacao_fatores_producao(i));
        ELSE
            dbms_output.put_line('NAO FOI POSSIVEL ADICIONAR O FATOR DE PRODUCAO - ' || fatores_producao(i) || ' POIS EXISTE UMA RESTRICAO A SER VIOLADA COM O ID - ' || id_restricao);
        END IF;
    END LOOP;
END;
/

-- Executar função
begin
    prc_update_operation_factors_production(
        4,
        '5;2;1',
        '12;13;14',
        'no solo;no solo;no solo',
        1
    );
end;
/

-- Verificar
SELECT *
FROM OPERACOESAGRICOLAS
INNER JOIN OPERACAOFATORESPRODUCAOAPLICADOS ON
OPERACOESAGRICOLAS.IDOPERACAO = OPERACAOFATORESPRODUCAOAPLICADOS.IDOPERACAO
WHERE OPERACOESAGRICOLAS.IDOPERACAO = 4;
