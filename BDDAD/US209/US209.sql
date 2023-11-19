--******************************************************
--* PARA RELIZAR TESTES POR FAVOR IMPORTAR O BOOTSTRAP *
--******************************************************

--Back-END
-- Obter o ID da morada atraves do endereco e codigo postal
CREATE OR REPLACE FUNCTION fnc_get_id_morada_by_endereco (
        morada_endereco_param IN MORADA.ENDERECO%TYPE,
        codigo_postal_param IN MORADA.CODIGOPOSTAL%TYPE
)
RETURN MORADA.IDMORADA%TYPE 
IS  id_morada_find MORADA.IDMORADA%TYPE;

BEGIN
    SELECT IDMORADA INTO id_morada_find FROM MORADA WHERE MORADA.ENDERECO = morada_endereco_param and MORADA.CODIGOPOSTAL = codigo_postal_param;
    
    RETURN id_morada_find;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END;
/

-- Obter o Id da morada de entrega do cliente atraves do ID do cliente
CREATE OR REPLACE FUNCTION fnc_get_id_morada_by_cliente (
        id_cliente_param IN ENCOMENDACLIENTE.IDCLIENTE%TYPE
)
RETURN CLIENTE.IDMORADAENTREGA%TYPE 
IS  id_morada_find CLIENTE.IDMORADAENTREGA%TYPE;

BEGIN
    SELECT IDMORADAENTREGA INTO id_morada_find FROM CLIENTE WHERE IDCLIENTE = id_cliente_param;
    
    RETURN id_morada_find;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END;
/

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

-- REGISTAR PEDIDOS DE UM CLIENTE COM A ENTREGA NUMA DETERMINADA MORADA
-- MORADA POR DEFEITO --> MORADA ENTREGA
-- VERIFICAR PLAFOND CLIENTE
CREATE OR REPLACE PROCEDURE prc_create_pedido_cliente (
    id_cliente_param IN ENCOMENDACLIENTE.IDCLIENTE%TYPE,
    morada_endereco_param IN MORADA.ENDERECO%TYPE,
    codigo_postal_param IN MORADA.CODIGOPOSTAL%TYPE,
    data_pedido_param IN ENCOMENDACLIENTE.DATAPEDIDO%TYPE,
    valor_total_param IN ENCOMENDACLIENTE.VALORTOTAL%TYPE,
    produtos_encomendados_param IN VARCHAR2,
    quantidade_produtos_encomendados_param IN VARCHAR2
)
IS  
    id_encomenda_inserted ENCOMENDACLIENTE.IDENCOMENDA%TYPE;
    id_morada MORADA.IDMORADA%TYPE;
    produtos_encomendados sys.odcivarchar2list;
    quantidade_produtos_encomendados sys.odcivarchar2list;
BEGIN
    IF morada_endereco_param IS NOT NULL THEN
        id_morada := fnc_get_id_morada_by_endereco(morada_endereco_param, codigo_postal_param);
        
        IF id_morada IS NULL THEN
            Insert into MORADA (ENDERECO,CODIGOPOSTAL) 
            values (morada_endereco_param,codigo_postal_param) returning IDMORADA into id_morada;
        END IF;
    ELSE
        id_morada := fnc_get_id_morada_by_cliente(id_cliente_param);
    END IF;
    
    IF fnc_get_check_plafond_by_id_cliente(id_cliente_param, valor_total_param) >= 0 THEN
        Insert into ENCOMENDACLIENTE (IDCLIENTE,DATAPEDIDO,DATAVENCIMENTO,DATAPAGAMENTO,DATAENTREGA,ESTADOPEDIDO,VALORTOTAL,IDMORADAENTREGA) 
        values (id_cliente_param,data_pedido_param,add_months(data_pedido_param, +12),null,null,'registada',valor_total_param,id_morada) returning IDENCOMENDA into id_encomenda_inserted;
        
        produtos_encomendados := split_string_to_list_stings(produtos_encomendados_param);
        quantidade_produtos_encomendados := split_string_to_list_stings(quantidade_produtos_encomendados_param);
        
        FOR i IN 1..produtos_encomendados.COUNT LOOP
            Insert into ENCOMENDAPRODUTO (IDENCOMENDA,IDPRODUTO,QUANTIDADE) 
            values (id_encomenda_inserted, produtos_encomendados(i), quantidade_produtos_encomendados(i));
        END LOOP;
        
        dbms_output.put_line('PEDIDO DO CLIENTE CRIADO COM O ID - ' || id_encomenda_inserted);
    ELSE
        dbms_output.put_line('NAO FOI POSSIVEL INSERIR PORQUE O PLAFON FOI ULTRAPASSADO ');
    END IF;
EXCEPTION
    WHEN others THEN
        dbms_output.put_line('NAO FOI POSSIVEL CRIAR O PEDIDO!');
END;
/

--Front-END
BEGIN
    prc_create_pedido_cliente(
        '1',
        'RUA DO ISEP',
        '4444-333',
        '22.11.18',
        '100',
        '1;3;6',
        '5;10;8'
    );
END;
/

--Verificar
SELECT *
FROM ENCOMENDACLIENTE
INNER JOIN ENCOMENDAPRODUTO ON
ENCOMENDACLIENTE.IDENCOMENDA = ENCOMENDAPRODUTO.IDENCOMENDA
WHERE IDCLIENTE = 1;



--Registar entrega de uma encomenda numa determinada data
--Back-END
CREATE OR REPLACE PROCEDURE prc_update_entrega_pedido_by_id_pedido(
    id_pedido_param IN ENCOMENDACLIENTE.IDENCOMENDA%TYPE,
    data_entrega_param IN ENCOMENDACLIENTE.DATAENTREGA%TYPE
)
IS

BEGIN
    UPDATE ENCOMENDACLIENTE SET DATAENTREGA = data_entrega_param, ESTADOPEDIDO = 'entregue' WHERE IDENCOMENDA = id_pedido_param;
    
    IF SQL%ROWCOUNT = 0 THEN
        dbms_output.put_line('ERRO! PROVAVELMENTE O ID DO PEDIDO NAO EXISTE');
    ELSE
        dbms_output.put_line('DATA DE ENTREGA MODIFICADA E ESTADO DO PEDIDO MODIFICADO!');
    END IF;
END;
/

--Front-END
BEGIN
    prc_update_entrega_pedido_by_id_pedido(
        '12',
        SYSDATE
    );
END;
/

--Verificar
SELECT *
FROM ENCOMENDACLIENTE
WHERE IDENCOMENDA = 12;





--Registar pagamentos de uma encomenda numa determinada data
--Back-END
CREATE OR REPLACE PROCEDURE prc_update_pagamento_pedido_by_id_pedido(
    id_pedido_param IN ENCOMENDACLIENTE.IDENCOMENDA%TYPE,
    data_pagamento_param IN ENCOMENDACLIENTE.DATAPAGAMENTO%TYPE
)
IS

BEGIN
    UPDATE ENCOMENDACLIENTE SET DATAPAGAMENTO = data_pagamento_param, ESTADOPEDIDO = 'paga' WHERE IDENCOMENDA = id_pedido_param;
    
    IF SQL%ROWCOUNT = 0 THEN
        dbms_output.put_line('ERRO! PROVAVELMENTE O ID DO PEDIDO NAO EXISTE');
    ELSE
        dbms_output.put_line('DATA DE PAGAMENTO MODIFICADA E ESTADO DO PEDIDO MODIFICADO!');
    END IF;
END;
/

--Front-END
BEGIN
    prc_update_pagamento_pedido_by_id_pedido(
        '12',
        SYSDATE
    );
END;
/

--Verificar
SELECT *
FROM ENCOMENDACLIENTE
WHERE IDENCOMENDA = 12;




--Listar Encomendas por estado
--Back-END
CREATE OR REPLACE FUNCTION fnc_get_encomendas_by_estado (
    estado_pedido_param IN ENCOMENDACLIENTE.ESTADOPEDIDO%TYPE
)
RETURN SYS_REFCURSOR 
IS  
    encomendas SYS_REFCURSOR;
BEGIN
    open encomendas for
        SELECT EC.DATAPEDIDO, EC.IDCLIENTE, EC.IDENCOMENDA, EC.VALORTOTAL, 
                EC.ESTADOPEDIDO, P.NOME, P.NIF, P.EMAIL
        FROM ENCOMENDACLIENTE EC
        INNER JOIN PESSOA P
        ON P.IDPESSOA = EC.IDCLIENTE
        WHERE EC.ESTADOPEDIDO = estado_pedido_param;

    RETURN encomendas;
END;
/


--Front-END
CREATE OR REPLACE PROCEDURE prc_show_encomendas_by_estado(
    estado_pedido_param IN ENCOMENDACLIENTE.ESTADOPEDIDO%TYPE
)
IS
    encomendas SYS_REFCURSOR;
    DATAPEDIDO ENCOMENDACLIENTE.DATAPEDIDO%type;
    IDCLIENTE ENCOMENDACLIENTE.IDCLIENTE%type;
    IDENCOMENDA ENCOMENDACLIENTE.IDENCOMENDA%type;
    VALORTOTAL ENCOMENDACLIENTE.VALORTOTAL%type;
    ESTADOPEDIDO ENCOMENDACLIENTE.ESTADOPEDIDO%type;
    NOME PESSOA.NOME%type;
    NIF PESSOA.NIF%type;
    EMAIL PESSOA.EMAIL%type;
BEGIN
    encomendas := fnc_get_encomendas_by_estado(estado_pedido_param);
    
    LOOP
        fetch encomendas into DATAPEDIDO, IDCLIENTE, IDENCOMENDA, VALORTOTAL, 
                              ESTADOPEDIDO, NOME, NIF, EMAIL;
        exit when encomendas%notfound;
        
        dbms_output.put_line('DATA DE REGISTO DA ENCOMENDA - ' || DATAPEDIDO || 
            ' | ID DO CLIENTE - ' || IDCLIENTE || ' | NUMERO DA ENCOMENDA - ' || 
            IDENCOMENDA || ' | VALOR TOTAL - ' || VALORTOTAL || ' | ESTADO - ' || 
            ESTADOPEDIDO || ' | NOME CLIENTE - ' || NOME || ' | NIF CLIENTE - ' || NIF
            || ' | EMAIL CLIENTE - ' || EMAIL);
    END LOOP;
    CLOSE encomendas;
END;
/

begin
    prc_show_encomendas_by_estado('paga');
end;
/

--Verificar        
SELECT EC.DATAPEDIDO, EC.IDCLIENTE, EC.IDENCOMENDA, EC.VALORTOTAL, EC.ESTADOPEDIDO, P.NOME, P.NIF, P.EMAIL
FROM ENCOMENDACLIENTE EC
INNER JOIN PESSOA P
ON P.IDPESSOA = EC.IDCLIENTE
WHERE EC.ESTADOPEDIDO = 'paga';