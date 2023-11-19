--******************************************************
--* PARA RELIZAR TESTES POR FAVOR IMPORTAR O BOOTSTRAP *
--******************************************************

--BACK-END
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

--Obter todos os registos da tabela INPUT_HUB
CREATE OR REPLACE FUNCTION fnc_get_input_hub
RETURN SYS_REFCURSOR    
IS  
    input_hub_rows SYS_REFCURSOR;
BEGIN
    open input_hub_rows for
        SELECT INPUT_STRING 
        FROM INPUT_HUB;
    
    RETURN input_hub_rows;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END;
/

--Verificar se o hub existe
CREATE OR REPLACE FUNCTION fnc_check_hub_exist(
    codigo_hub_param IN HUB.CODIGOHUB%TYPE
)
RETURN integer    
IS  
    hub_exist integer;
BEGIN
    SELECT COUNT(*) INTO hub_exist
    FROM HUB
    WHERE CODIGOHUB = codigo_hub_param;
    
    RETURN hub_exist;
EXCEPTION
    WHEN others THEN
        RETURN 1;
END;
/

--Atualizar a tabela HUB baseado na tabela INPUT_HUB
CREATE OR REPLACE PROCEDURE prc_update_hub_table 
IS  
    input_hub_rows SYS_REFCURSOR;
    INPUT_STRING INPUT_HUB.INPUT_STRING%TYPE;
    hub_data sys.odcivarchar2list;
BEGIN
    input_hub_rows := fnc_get_input_hub();
    
    LOOP
        fetch input_hub_rows into INPUT_STRING;
        exit when input_hub_rows%notfound;
        
        hub_data := split_string_to_list_stings(INPUT_STRING);
         
        IF hub_data(4) NOT LIKE 'C%' THEN 
            IF fnc_check_hub_exist(hub_data(1)) = 0 THEN
                Insert into HUB (CODIGOHUB,LATITUDE,LONGITUDE,codigoEP)
                values (hub_data(1), hub_data(2), hub_data(3), hub_data(4));
                
                dbms_output.put_line('HUB ADICIONADO! CODIGO HUB - ' || hub_data(1) || 
                ' | LATITUDE - ' || hub_data(2) || ' | LONGITUDE - ' || hub_data(3) ||
                ' | CODIGO EMPRESAS/PRODUTORES - ' || hub_data(4));
            ELSE
                dbms_output.put_line('O HUB COM LOC ID - ' || hub_data(1) || ' NAO FOI ADICIONADO A TABELA HUB, VISTO QUE JA EXISTE');
            END IF;
        END IF;
        
    END LOOP;
    CLOSE input_hub_rows;
EXCEPTION
    WHEN others THEN
        dbms_output.put_line('NAO FOI POSSIVEL ATUALIZAR A TABELA DOS HUBS!');
        dbms_output.put_line(SQLERRM);
END;
/

--FRONT-END
begin
    prc_update_hub_table();
end;
/

--Verificar
SELECT * 
FROM INPUT_HUB;

SELECT * 
FROM HUB;




--BACK-END
--Atribuir ou atualizar o hub por defeito de um cliente
CREATE OR REPLACE PROCEDURE prc_assign_hub_to_client(
    id_client_param IN CLIENTE.IDCLIENTE %TYPE,
    codigo_hub_param IN CLIENTE.CODIGOHUB%TYPE
)
IS  
    
BEGIN
    IF fnc_check_hub_exist(codigo_hub_param) = 1 THEN     
        UPDATE CLIENTE
        SET CODIGOHUB = codigo_hub_param
        WHERE IDCLIENTE = id_client_param;
        
        dbms_output.put_line('ATRIBUIDO COM SUCESSO! O CLIENTE COM ID - ' || id_client_param || ' TEM COMO HUB POR DEFEITO - ' || codigo_hub_param);
    ELSE
        RAISE_APPLICATION_ERROR(-20000, 'O HUB INDICADO NAO E VALIDO!');
    END IF;
EXCEPTION
    WHEN others THEN
        dbms_output.put_line('NAO FOI POSSIVEL ATRIBUIR/AUALIZAR O HUB AO CLIENTE!');
        dbms_output.put_line(SQLERRM);
END;
/

--FRONT-END
--Atribuir um hub por defeito a um cliente
begin
    prc_assign_hub_to_client('3', 'CT98');
end;
/

--Alterar o hub por defeito de um cliente
begin
    prc_assign_hub_to_client('3', 'CT99');
end;
/

--Verificar
SELECT * 
FROM CLIENTE
WHERE IDCLIENTE = 3;




--BACK-END
--Verificar se o plafond ja foi ultrapassado
CREATE OR REPLACE FUNCTION fnc_get_check_plafond_by_id_cliente (
    id_cliente_param IN ENCOMENDACLIENTE.IDCLIENTE%TYPE,
    valor_total_param IN ENCOMENDACLIENTE.VALORTOTAL%TYPE
)
RETURN CLIENTE.plafond%TYPE 
IS  max_plafond_find CLIENTE.plafond%TYPE;
    encomendas_por_pagar ENCOMENDACLIENTE.VALORTOTAL%TYPE;

BEGIN
    SELECT plafond INTO max_plafond_find FROM CLIENTE WHERE IDCLIENTE = id_cliente_param;
    
    SELECT SUM(VALORTOTAL) INTO encomendas_por_pagar FROM ENCOMENDACLIENTE where IDCLIENTE = id_cliente_param and ESTADOPEDIDO != 'paga';
    
    IF encomendas_por_pagar IS NULL THEN
        return max_plafond_find;
    END IF;
    
    max_plafond_find := max_plafond_find - (encomendas_por_pagar + valor_total_param);
    
    RETURN max_plafond_find;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END;
/

--Obter o ID do HUB por defeito do cliente
CREATE OR REPLACE FUNCTION fnc_get_default_hub_by_client (
    id_cliente_param IN CLIENTE.IDCLIENTE%TYPE
)
RETURN CLIENTE.CODIGOHUB%TYPE 
IS  
    codigo_hub_find CLIENTE.CODIGOHUB%TYPE;
BEGIN
    SELECT CODIGOHUB INTO codigo_hub_find
    FROM CLIENTE
    WHERE IDCLIENTE = id_cliente_param;
    
    IF codigo_hub_find IS NULL THEN
        RAISE_APPLICATION_ERROR(-20000, 'E NECESSARIO ATRIBUIR UM HUB POR DEFEITO AO UTILIZADOR!');
    END IF;
    
    RETURN codigo_hub_find;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20000, 'O CLIENTE MENCIONADO NAO EXISTE!');
END;
/

--Criar uma encomenda com uma nota de encomenda que indica o hub
CREATE OR REPLACE PROCEDURE prc_create_encomenda_client_with_note (
    id_cliente_param IN ENCOMENDACLIENTE.IDCLIENTE%TYPE,
    data_pedido_param IN ENCOMENDACLIENTE.DATAPEDIDO%TYPE,
    valor_total_param IN ENCOMENDACLIENTE.VALORTOTAL%TYPE,
    codigo_hub_param IN CLIENTE.CODIGOHUB%TYPE,
    produtos_encomendados_param IN VARCHAR2,
    quantidade_produtos_encomendados_param IN VARCHAR2
)
IS  
    id_encomenda_inserted ENCOMENDACLIENTE.IDENCOMENDA%TYPE;
    id_hub CLIENTE.CODIGOHUB%TYPE;
    produtos_encomendados sys.odcivarchar2list;
    quantidade_produtos_encomendados sys.odcivarchar2list;
BEGIN
    IF codigo_hub_param IS NULL THEN
        id_hub := fnc_get_default_hub_by_client(id_cliente_param);
    ELSE
        id_hub := codigo_hub_param;
    END IF;

    IF fnc_check_hub_exist(id_hub) = 1 THEN
        IF fnc_get_check_plafond_by_id_cliente(id_cliente_param, valor_total_param) >= 0 THEN
            Insert into ENCOMENDACLIENTE (IDCLIENTE,DATAPEDIDO,DATAVENCIMENTO,DATAPAGAMENTO,DATAENTREGA,ESTADOPEDIDO,VALORTOTAL,CODIGOHUBENTREGA) 
            values (id_cliente_param,data_pedido_param,add_months(data_pedido_param, +12),null,null,'registada',valor_total_param, id_hub) returning IDENCOMENDA into id_encomenda_inserted;
        
            produtos_encomendados := split_string_to_list_stings(produtos_encomendados_param);
            quantidade_produtos_encomendados := split_string_to_list_stings(quantidade_produtos_encomendados_param);
            
            FOR i IN 1..produtos_encomendados.COUNT LOOP
                Insert into ENCOMENDAPRODUTO (IDENCOMENDA,IDPRODUTO,QUANTIDADE) 
                values (id_encomenda_inserted, produtos_encomendados(i), quantidade_produtos_encomendados(i));
            END LOOP;
        
            dbms_output.put_line('ENCOMENDA DO CLIENTE CRIADA COM O ID - ' || id_encomenda_inserted);
        ELSE
            RAISE_APPLICATION_ERROR(-20000, 'NAO FOI POSSIVEL INSERIR PORQUE O PLAFON FOI ULTRAPASSADO');
        END IF;
    ELSE
        RAISE_APPLICATION_ERROR(-20000, 'O HUB INDICADO NAO E VALIDO!');
    END IF;
    
EXCEPTION
    WHEN others THEN
        dbms_output.put_line('NAO FOI POSSIVEL CRIAR A ENCOMENDA!');
        dbms_output.put_line(SQLERRM);
END;
/

--Front-END
--Criar uma encomenda para um HUB DIFERENTE DO DEFAULT
BEGIN
    prc_create_encomenda_client_with_note(
        '3',
        SYSDATE,
        '1000',
        'CT10',
        '1;3;6',
        '5;10;8'
    );
END;
/

--Criar uma encomenda para o HUB DEFAULT
BEGIN
    prc_create_encomenda_client_with_note(
        '3',
        SYSDATE,
        '500',
        null,
        '2;4;5',
        '8;5;20'
    );
END;
/

--Verificar
SELECT *
FROM ENCOMENDACLIENTE
INNER JOIN ENCOMENDAPRODUTO ON
ENCOMENDACLIENTE.IDENCOMENDA = ENCOMENDAPRODUTO.IDENCOMENDA
WHERE ENCOMENDACLIENTE.IDENCOMENDA = 14;

SELECT *
FROM ENCOMENDACLIENTE
INNER JOIN ENCOMENDAPRODUTO ON
ENCOMENDACLIENTE.IDENCOMENDA = ENCOMENDAPRODUTO.IDENCOMENDA
WHERE ENCOMENDACLIENTE.IDENCOMENDA = 15;




--BACK-END
--Obter o ID do cliente que fez a encomenda
CREATE OR REPLACE FUNCTION fnc_get_client_by_encomenda (
    id_encomenda_param IN ENCOMENDACLIENTE.IDENCOMENDA%TYPE
)
RETURN ENCOMENDACLIENTE.IDCLIENTE%TYPE 
IS  
    id_cliente ENCOMENDACLIENTE.IDCLIENTE%TYPE;
BEGIN
    SELECT IDCLIENTE INTO id_cliente 
    FROM ENCOMENDACLIENTE 
    WHERE IDENCOMENDA = id_encomenda_param;
    
    RETURN id_cliente;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20000, 'NAO EXISTE NENHUMA ENCOMENDA COM ESTE ID');
END;
/

--Adicionar a uma ENCOMENDA que ja existe uma nota de encomenda que indica o hub
CREATE OR REPLACE PROCEDURE prc_create_note_to_encomenda (
    id_encomenda_param IN ENCOMENDACLIENTE.IDENCOMENDA%TYPE,
    codigo_hub_param IN ENCOMENDACLIENTE.CODIGOHUBENTREGA%TYPE
)
IS  
    id_cliente ENCOMENDACLIENTE.IDCLIENTE%TYPE;
    id_hub ENCOMENDACLIENTE.CODIGOHUBENTREGA%TYPE;
BEGIN
    id_cliente := fnc_get_client_by_encomenda(id_encomenda_param);

    IF codigo_hub_param IS NULL THEN
        id_hub := fnc_get_default_hub_by_client(id_cliente);
    ELSE
        id_hub := codigo_hub_param;
    END IF;

    IF fnc_check_hub_exist(id_hub) = 1 THEN
        UPDATE ENCOMENDACLIENTE
        SET CODIGOHUBENTREGA = id_hub
        WHERE IDENCOMENDA = id_encomenda_param;

        dbms_output.put_line('NOTA DA ENCOMENDA FOI ADICIONADO COM SUCESSO! ID ENCOMENDA - ' || id_encomenda_param || ' CODIGO DO HUB - ' || id_hub);
    ELSE
        RAISE_APPLICATION_ERROR(-20000, 'O HUB INDICADO NAO E VALIDO!');
    END IF;
    
EXCEPTION
    WHEN others THEN
        dbms_output.put_line('NAO FOI POSSIVEL CRIAR A NOTA DA ENCOMENDA!');
        dbms_output.put_line(SQLERRM);
END;
/

--Front-END
--Criar uma nota de encomenda para um HUB DIFERENTE DO DEFAULT
BEGIN
    prc_create_note_to_encomenda(
        '12',
        'CT14'
    );
END;
/

--Criar uma nota de encomenda para o HUB DEFAULT
BEGIN
    prc_create_note_to_encomenda(
        '13',
        null
    );
END;
/

--Verificar
SELECT *
FROM ENCOMENDACLIENTE
INNER JOIN ENCOMENDAPRODUTO ON
ENCOMENDACLIENTE.IDENCOMENDA = ENCOMENDAPRODUTO.IDENCOMENDA
WHERE ENCOMENDACLIENTE.IDENCOMENDA = 12;

SELECT *
FROM ENCOMENDACLIENTE
INNER JOIN ENCOMENDAPRODUTO ON
ENCOMENDACLIENTE.IDENCOMENDA = ENCOMENDAPRODUTO.IDENCOMENDA
WHERE ENCOMENDACLIENTE.IDENCOMENDA = 13;