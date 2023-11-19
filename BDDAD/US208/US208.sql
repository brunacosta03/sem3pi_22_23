--******************************************************
--* PARA RELIZAR TESTES POR FAVOR IMPORTAR O BOOTSTRAP *
--******************************************************

--Criar um uma Ficha Tecnica com os dados de um Fator de Producao que não existe
--Back-END
CREATE OR REPLACE PROCEDURE prc_create_ficha_tecnica (
    nome_comercial_param IN FATORPRODUCAO.NOMECOMERCIAL%TYPE,
    formulacao_param IN FATORPRODUCAO.FORMULACAO%TYPE,
    classificacao_fator_param IN FATORPRODUCAO.CLASSIFICACAOFATOR%TYPE,
    fornecedor_param IN FATORPRODUCAO.FORNECEDOR%TYPE,
    categoria_param IN FICHATECNICA.CATEGORIA%TYPE
)
IS  
    id_fator_producao_inserted FATORPRODUCAO.IDFATORPRODUCAO%TYPE;
    id_ficha_tecnica_inserted FICHATECNICA.IDFICHATECNICA%TYPE;
BEGIN    
    Insert into FATORPRODUCAO (NOMECOMERCIAL,FORMULACAO,CLASSIFICACAOFATOR,FORNECEDOR) values (nome_comercial_param,formulacao_param,classificacao_fator_param,fornecedor_param) returning IDFATORPRODUCAO into id_fator_producao_inserted;
    Insert into FICHATECNICA (IDFATORPRODUCAO,CATEGORIA) values (id_fator_producao_inserted, categoria_param) returning IDFICHATECNICA into id_ficha_tecnica_inserted;
    
    dbms_output.put_line('FICHA TECNICA CRIADA COM O ID - ' || id_ficha_tecnica_inserted);
EXCEPTION
    WHEN others THEN
        dbms_output.put_line('NAO FOI POSSIVEL CRIAR A FICHA TECNICA!');
END;
/


--Front-END
BEGIN
    prc_create_ficha_tecnica(
        'NOME COMERCIAL',
        'liquido',
        'fertilizantes',
        'FORNECEDOR',
        'SUBSTANCIAS ORGANICAS'
    );
END;
/


--Verificar
SELECT FP.IDFATORPRODUCAO, FP.NOMECOMERCIAL, FP.FORMULACAO, FP.CLASSIFICACAOFATOR,
        FP.FORNECEDOR, FT.IDFICHATECNICA, FT.CATEGORIA
FROM FATORPRODUCAO FP
INNER JOIN FICHATECNICA FT
ON FP.IDFATORPRODUCAO = FT.IDFATORPRODUCAO;





--Criar um uma Ficha Tecnica com os dados de um Fator de Producao a partir de um ID de um FATOR de Producao que já existe
--O objetivo será adicionar uma categoria nova para uma Ficha Tecnica de um Fator de Producao que já existe
--Back-END
CREATE OR REPLACE PROCEDURE prc_create_categoria_to_ficha_tecnica (
    id_ficha_tecnica_param IN FICHATECNICA.IDFICHATECNICA%TYPE,
    categoria_param IN FICHATECNICA.CATEGORIA%TYPE
)
IS  
    id_fator_producao_ft FICHATECNICA.IDFATORPRODUCAO%TYPE;
    id_ficha_tecnica_inserted FICHATECNICA.IDFICHATECNICA%TYPE;
BEGIN    
    SELECT IDFATORPRODUCAO INTO id_fator_producao_ft FROM FICHATECNICA WHERE IDFICHATECNICA = id_ficha_tecnica_param;
    
    Insert into FICHATECNICA (IDFATORPRODUCAO,CATEGORIA) values (id_fator_producao_ft, categoria_param) returning IDFICHATECNICA into id_ficha_tecnica_inserted;
    
    dbms_output.put_line('FICHA TECNICA CRIADA COM O ID - ' || id_ficha_tecnica_inserted);
EXCEPTION
    WHEN others THEN
        dbms_output.put_line('NAO FOI POSSIVEL CRIAR A CATEGORIA NA FICHA TECNICA INDICADA!');
END;
/


--Front-END
BEGIN
    prc_create_categoria_to_ficha_tecnica(
        '9',
        'ELEMENTOS NUTRITIVOS ORGANICOS'
    );
END;
/

--Verificar
SELECT FP.IDFATORPRODUCAO, FP.NOMECOMERCIAL, FP.FORMULACAO, FP.CLASSIFICACAOFATOR,
        FP.FORNECEDOR, FT.IDFICHATECNICA, FT.CATEGORIA
FROM FATORPRODUCAO FP
INNER JOIN FICHATECNICA FT
ON FP.IDFATORPRODUCAO = FT.IDFATORPRODUCAO;




--Adicionar elementos à ficha tecnica respetiva
--Back-END
CREATE OR REPLACE FUNCTION fnc_get_elemento_by_substancia_quantidade_unidade (
    substancia_param IN ELEMENTO.SUBSTANCIA%TYPE,
    quantidade_param IN ELEMENTO.QUANTIDADE%TYPE,
    unidade_param IN ELEMENTO.UNIDADE%TYPE
)
RETURN ELEMENTO.IDELEMENTO%TYPE 
IS  id_elemento_find ELEMENTO.IDELEMENTO%TYPE;

BEGIN
    SELECT IDELEMENTO INTO id_elemento_find FROM ELEMENTO WHERE lower(SUBSTANCIA) = lower(substancia_param) and QUANTIDADE = quantidade_param and lower(UNIDADE) = lower(unidade_param);
    
    RETURN id_elemento_find;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END;
/

CREATE OR REPLACE PROCEDURE prc_create_elemento_to_ficha_tecnica (
    id_ficha_tecnica_param IN FICHATECNICA.IDFICHATECNICA%TYPE,
    substancia_param IN ELEMENTO.SUBSTANCIA%TYPE,
    quantidade_param IN ELEMENTO.QUANTIDADE%TYPE,
    unidade_param IN ELEMENTO.UNIDADE%TYPE
)
IS  
    id_elemento_inserted ELEMENTO.IDELEMENTO%TYPE;
BEGIN
    id_elemento_inserted := fnc_get_elemento_by_substancia_quantidade_unidade(substancia_param,quantidade_param,unidade_param);
    
    IF id_elemento_inserted IS NULL THEN
        Insert into ELEMENTO (SUBSTANCIA,QUANTIDADE,UNIDADE) values (substancia_param,quantidade_param,unidade_param) returning IDELEMENTO into id_elemento_inserted;
    END IF;
    
    Insert into FICHATECNICAELEMENTO (IDFICHATECNICA,IDELEMENTO) values (id_ficha_tecnica_param,id_elemento_inserted);
    
    dbms_output.put_line('FOI ADICIONADO O ELEMENTO COM O ID - ' || id_elemento_inserted || ' A FICHA TECNICA COM O ID - ' || id_ficha_tecnica_param);
EXCEPTION
    WHEN others THEN
        dbms_output.put_line('NAO FOI POSSIVEL CRIAR O ELEMENTO NA FICHA TECNICA PEDIDA!');
END;
/

--Front-END
BEGIN
    prc_create_elemento_to_ficha_tecnica(
        '9',
        'Peso especifico',
        '0,82',
        'kg/L'
    );
END;
/

--Verificar
SELECT  FT.IDFICHATECNICA, FTE.IDELEMENTO, FP.IDFATORPRODUCAO, FP.CLASSIFICACAOFATOR, FP.NOMECOMERCIAL, FP.FORMULACAO,
        FP.FORNECEDOR, FT.CATEGORIA, E.SUBSTANCIA, E.QUANTIDADE, E.UNIDADE
FROM FATORPRODUCAO FP
INNER JOIN FICHATECNICA FT
ON FP.IDFATORPRODUCAO = FT.IDFATORPRODUCAO
INNER JOIN FICHATECNICAELEMENTO FTE
ON FTE.IDFICHATECNICA = FT.IDFICHATECNICA
INNER JOIN ELEMENTO E
ON E.IDELEMENTO = FTE.IDELEMENTO;