/*
    Backend (PL/SQL) para a função obter_resultados
*/

CREATE OR REPLACE FUNCTION fnc_obter_resultados (
    p_idSetor IN Setor.idSetor%TYPE,
    p_idCultura IN Cultura.idCultura%TYPE
    )

RETURN SYS_REFCURSOR AS

  resultado SYS_REFCURSOR;

BEGIN

  OPEN resultado FOR
    SELECT t.ano, SUM(s.producao) AS producao -- produção de um certo ano...
    FROM Stats s
    INNER JOIN Tempo t ON s.idTempo = t.idTempo
    INNER JOIN Setor st ON s.idSetor = st.idSetor
    INNER JOIN Cultura c ON s.idSetor = c.idSetor
    WHERE c.idCultura = p_idCultura -- de uma certa cultura
    AND st.idSetor = p_idSetor -- de um certo setor
    AND t.ano BETWEEN EXTRACT(YEAR FROM SYSDATE) - 5 AND EXTRACT(YEAR FROM SYSDATE) -- desde 5 anos atras
    GROUP BY t.ano -- agrupar por ano (produção/ano)
    ORDER BY t.ano ASC; -- desde há 5 anos até agora
  RETURN resultado; -- devolver o cursor a ser imprimido

EXCEPTION
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('Nao foi possivel avaliar a evolucao da cultura ' || p_idCultura || ' no setor ' || p_idSetor || '.');
      RETURN NULL;
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLERRM);
      RETURN NULL;
END;
/

/*
    Frontend (PL/SQL) para a função obter_resultados
*/

CREATE OR REPLACE PROCEDURE prc_imprimir_resultados
(
    p_idSetor IN Setor.idSetor%TYPE,
    p_idCultura IN Cultura.idCultura%TYPE
) AS

  c_resultados SYS_REFCURSOR;
  ano_print Tempo.ano%TYPE;
  producao_print float;

BEGIN
    c_resultados := fnc_obter_resultados(p_idSetor, p_idCultura);

    IF c_resultados IS NOT NULL THEN
        LOOP
            FETCH c_resultados into ano_print, producao_print;
            EXIT WHEN c_resultados%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE('Ano: ' || ano_print || ', ' || 'Producao: ' || producao_print || ' toneladas');
        END LOOP;
    END IF;

END;
/

/*
    Resultado por bloco anonimo
*/
BEGIN
    prc_imprimir_resultados(2, 2);
END;
/

-- hardcoded select for proof testing
SELECT t.ano, SUM(s.producao) AS producao
    FROM Stats s
    INNER JOIN Tempo t ON s.idTempo = t.idTempo
    INNER JOIN Setor st ON s.idSetor = st.idSetor
    INNER JOIN Cultura c ON s.idSetor = c.idSetor
    WHERE c.idCultura = 2
    AND st.idSetor = 2
    AND t.ano BETWEEN EXTRACT(YEAR FROM SYSDATE) - 5 AND EXTRACT(YEAR FROM SYSDATE) -- desde 5 anos atras
    GROUP BY t.ano
    ORDER BY t.ano ASC;