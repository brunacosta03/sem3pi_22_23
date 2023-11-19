--******************************************************
--* PARA RELIZAR TESTES POR FAVOR IMPORTAR O BOOTSTRAP *
--******************************************************

--Criar um Setor com uma determinada Cultura especificando as caracteristicas por parametro
--Back-END
CREATE OR REPLACE FUNCTION fnc_create_setor_with_cultura (
    designacao_param IN SETOR.DESIGNACAO%TYPE,
    area_param IN SETOR.AREA%TYPE,
    id_gestor_agricola_param IN SETOR.IDGESTORAGRICOLA%TYPE,
    nome_cultura_param IN CULTURA.NOMECULTURA%TYPE,
    tipo_cultura_param IN CULTURA.TIPOCULTURA%TYPE,
    designacao_cultura_param IN CULTURA.DESIGNACAO%TYPE
)
RETURN CULTURA.IDCULTURA%TYPE
IS  
    id_setor_inserted SETOR.IDSETOR%TYPE;
BEGIN
    Insert into SETOR (DESIGNACAO,AREA,IDGESTORAGRICOLA) values (designacao_param,area_param,id_gestor_agricola_param) returning IDSETOR into id_setor_inserted;
    
    Insert into CULTURA (NOMECULTURA,TIPOCULTURA,DESIGNACAO,IDSETOR) values (nome_cultura_param,tipo_cultura_param,designacao_cultura_param,id_setor_inserted);
    
    RETURN id_setor_inserted;
EXCEPTION
    WHEN others THEN
        dbms_output.put_line('NAO FOI POSSIVEL CRIAR O SETOR!');
        RETURN NULL;
END;
/


--Front-END
DECLARE
      id_setor_inserted NUMBER;
BEGIN
      id_setor_inserted := fnc_create_setor_with_cultura(
        'Campo de Abobora com possibilidade para cebolas',
        '138',
        '10',
        'Abobora',
        'permanente',
        'Especie Vegetal'
    );
    IF id_setor_inserted IS NOT NULL THEN
        dbms_output.put_line('ID DO SETOR INSERIDO - ' || id_setor_inserted);
    END IF;
END;
/

--Verificar
SELECT C.IDCULTURA, C.NOMECULTURA, C.TIPOCULTURA, C.DESIGNACAO, C.IDSETOR, S.DESIGNACAO, S.AREA  
FROM CULTURA C
INNER JOIN SETOR S
ON C.IDSETOR = S.IDSETOR
WHERE S.IDGESTORAGRICOLA = 10;






--Adicionar uma cultura a um determinado setor
--Back-END
CREATE OR REPLACE PROCEDURE prc_create_cultura_to_setor (
    id_setor_param IN SETOR.IDSETOR%TYPE,
    nome_cultura_param IN CULTURA.NOMECULTURA%TYPE,
    tipo_cultura_param IN CULTURA.TIPOCULTURA%TYPE,
    designacao_cultura_param IN CULTURA.DESIGNACAO%TYPE
)
IS  
    id_cultura_inserted CULTURA.IDCULTURA%TYPE;
BEGIN
    Insert into CULTURA (NOMECULTURA,TIPOCULTURA,DESIGNACAO,IDSETOR) values (nome_cultura_param,tipo_cultura_param,designacao_cultura_param,id_setor_param) returning IDCULTURA into id_cultura_inserted;
    
    dbms_output.put_line('ID DA CULTURA INSERIDA - ' || id_cultura_inserted);
EXCEPTION
    WHEN others THEN
        dbms_output.put_line('NAO FOI POSSIVEL INSERIR A CULTURA PEDIDA!');
END;
/

--Front-END
BEGIN
    prc_create_cultura_to_setor(
        '11',
        'Cebolas',
        'permanente',
        'Espécie Vegetal'
    );
END;
/

--Verificar
SELECT *
FROM CULTURA C
INNER JOIN SETOR S
ON C.IDSETOR = S.IDSETOR
WHERE S.IDGESTORAGRICOLA = 10;




--Listar os Setores ordernados por ordem alfabetica
--Back-END
CREATE OR REPLACE FUNCTION fnc_get_setor_order_by_designacao (
    search_id_gestor_agricola IN SETOR.IDGESTORAGRICOLA%TYPE
)
RETURN SYS_REFCURSOR 
IS  setores SYS_REFCURSOR;

BEGIN
    open setores for
        SELECT IDSETOR, DESIGNACAO, AREA, IDGESTORAGRICOLA
        FROM SETOR 
        WHERE IDGESTORAGRICOLA = search_id_gestor_agricola
        order by DESIGNACAO;

    RETURN setores;
END;
/

--Front-END
CREATE OR REPLACE PROCEDURE prc_show_setor_order_by_designacao(
    search_id_gestor_agricola IN SETOR.IDGESTORAGRICOLA%TYPE
)
IS
    setores SYS_REFCURSOR;
    IDSETOR SETOR.IDSETOR%type;
    DESIGNACAO SETOR.DESIGNACAO%type;
    AREA SETOR.AREA%type;
    IDGESTORAGRICOLA SETOR.IDGESTORAGRICOLA%type;
BEGIN
    setores := fnc_get_setor_order_by_designacao(search_id_gestor_agricola);
    
    LOOP
        fetch setores into IDSETOR, DESIGNACAO, AREA, IDGESTORAGRICOLA;
        exit when setores%notfound;
        
        dbms_output.put_line('ID SETOR - ' || idSetor || ' | DESIGNACAO - ' || DESIGNACAO || ' | AREA - ' || AREA || ' | ID GESTOR AGRICOLA - ' || IDGESTORAGRICOLA);
    END LOOP;
    CLOSE setores;
END;
/

begin
    prc_show_setor_order_by_designacao(10);
end;
/

--Verificar
SELECT * 
FROM SETOR 
WHERE IDGESTORAGRICOLA = 10
order by DESIGNACAO;








--Listar os Setores ordenados por tamanho em ordem decrescente ou crescente
--Back-END (Ordernar por ordem Decrescente)
CREATE OR REPLACE FUNCTION fnc_get_setor_order_by_asc_tamanho (
    search_id_gestor_agricola IN SETOR.IDGESTORAGRICOLA%TYPE
)
RETURN SYS_REFCURSOR 
IS  setores SYS_REFCURSOR;

BEGIN
    open setores for
        SELECT IDSETOR, DESIGNACAO, AREA, IDGESTORAGRICOLA
        FROM SETOR 
        WHERE IDGESTORAGRICOLA = search_id_gestor_agricola
        order by area ASC;

    RETURN setores;
END;
/

--Back-END (Ordernar por ordem Crescente)
CREATE OR REPLACE FUNCTION fnc_get_setor_order_by_desc_tamanho (
    search_id_gestor_agricola IN SETOR.IDGESTORAGRICOLA%TYPE
)
RETURN SYS_REFCURSOR 
IS  setores SYS_REFCURSOR;

BEGIN
    open setores for
        SELECT IDSETOR, DESIGNACAO, AREA, IDGESTORAGRICOLA
        FROM SETOR 
        WHERE IDGESTORAGRICOLA = search_id_gestor_agricola
        order by area DESC;

    RETURN setores;
END;
/


--Front-END
CREATE OR REPLACE PROCEDURE fnc_show_setor_order_by_tamanho(
    search_id_gestor_agricola IN SETOR.IDGESTORAGRICOLA%TYPE,
    orderType IN String
)
IS
    setores SYS_REFCURSOR;
    IDSETOR SETOR.IDSETOR%type;
    DESIGNACAO SETOR.DESIGNACAO%type;
    AREA SETOR.AREA%type;
    IDGESTORAGRICOLA SETOR.IDGESTORAGRICOLA%type;
BEGIN
    IF orderType = 'ASC' THEN
        setores := fnc_get_setor_order_by_asc_tamanho(search_id_gestor_agricola);
    ELSE
        setores := fnc_get_setor_order_by_desc_tamanho(search_id_gestor_agricola);
    END IF;
    
    LOOP
        fetch setores into IDSETOR, DESIGNACAO, AREA, IDGESTORAGRICOLA;
        exit when setores%notfound;
        
        dbms_output.put_line('ID SETOR - ' || idSetor || ' | DESIGNACAO - ' || DESIGNACAO || ' | AREA - ' || AREA || ' | ID GESTOR AGRICOLA - ' || IDGESTORAGRICOLA);
    END LOOP;
    CLOSE setores;
END;
/

begin
    fnc_show_setor_order_by_tamanho(8, 'ASC');
end;
/

begin
    fnc_show_setor_order_by_tamanho(8, 'DESC');
end;
/

--Verificar ordem Crescente
SELECT * 
FROM SETOR 
WHERE IDGESTORAGRICOLA = 8
order by area ASC;

--Verificar ordem Decrescente
SELECT * 
FROM SETOR 
WHERE IDGESTORAGRICOLA = 8
order by area DESC;









--Listar os Setores exploracao agricola ordenados por tipo de cultura e cultura
--Back-END
CREATE OR REPLACE FUNCTION fnc_get_setor_order_by_tipocultura_and_cultura(
    search_id_gestor_agricola IN SETOR.IDGESTORAGRICOLA%TYPE
)
RETURN SYS_REFCURSOR 
IS  setores_cultura SYS_REFCURSOR;

BEGIN
    open setores_cultura for
        SELECT C.IDCULTURA, C.NOMECULTURA, C.TIPOCULTURA, C.DESIGNACAO, C.IDSETOR, S.DESIGNACAO, S.AREA  
        FROM CULTURA C
        INNER JOIN SETOR S
        ON C.IDSETOR = S.IDSETOR
        WHERE S.IDGESTORAGRICOLA = search_id_gestor_agricola
        order by C.TIPOCULTURA, C.NOMECULTURA;

    RETURN setores_cultura;
END;
/


--Front-END
CREATE OR REPLACE PROCEDURE fnc_show_setor_order_by_tipocultura_and_cultura(
    search_id_gestor_agricola IN SETOR.IDGESTORAGRICOLA%TYPE
)
IS
    setores_cultura SYS_REFCURSOR;
    IDCULTURA CULTURA.IDCULTURA%type;
    NOMECULTURA CULTURA.NOMECULTURA%type;
    TIPOCULTURA CULTURA.TIPOCULTURA%type;
    DESIGNACAO CULTURA.DESIGNACAO%type;
    IDSETOR CULTURA.IDSETOR%type;
    DESIGNACAO_SETOR SETOR.DESIGNACAO%type;
    AREA SETOR.AREA%type;
BEGIN
    setores_cultura := fnc_get_setor_order_by_tipocultura_and_cultura(search_id_gestor_agricola);
    
    LOOP
        fetch setores_cultura into IDCULTURA, NOMECULTURA, TIPOCULTURA, DESIGNACAO, IDSETOR, DESIGNACAO_SETOR, AREA;
        exit when setores_cultura%notfound;
        
        dbms_output.put_line('ID CULTURA - ' || IDCULTURA || ' | NOME CULTURA - ' || NOMECULTURA || 
                         ' | TIPO CULTURA - ' || TIPOCULTURA || ' | DESIGNACAO - ' || DESIGNACAO ||
                         ' | IDSETOR - ' || IDSETOR || ' | DESIGNACAO_SETOR - ' || DESIGNACAO_SETOR || ' | AREA - ' || AREA);
    END LOOP;
    CLOSE setores_cultura;
END;
/


begin
    fnc_show_setor_order_by_tipocultura_and_cultura(8);
end;
/

--Verificar
SELECT C.IDCULTURA, C.NOMECULTURA, C.TIPOCULTURA, C.DESIGNACAO, C.IDSETOR, S.DESIGNACAO, S.AREA  
FROM CULTURA C
INNER JOIN SETOR S
ON C.IDSETOR = S.IDSETOR
WHERE S.IDGESTORAGRICOLA = 8
order by C.TIPOCULTURA, C.NOMECULTURA;