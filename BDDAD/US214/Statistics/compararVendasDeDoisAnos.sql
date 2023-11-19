/*
    Backend (PL/SQL) para a função obter_vendas_por_ano
*/
CREATE OR REPLACE FUNCTION obter_vendas_por_ano
(
    p_ano_referencia IN Tempo.ano%TYPE,
    p_ano_comparacao IN Tempo.idTempo%TYPE
)

RETURN SYS_REFCURSOR AS

  resultado SYS_REFCURSOR;

BEGIN

  OPEN resultado FOR
    SELECT t.ano, SUM(s.vendas) AS vendas
    FROM Stats s
    INNER JOIN Tempo t ON s.idTempo = t.idTempo
    WHERE t.ano IN (p_ano_referencia, p_ano_comparacao)
    GROUP BY t.ano
    ORDER BY t.ano ASC;

  RETURN resultado;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('Não foi possível avaliar as vendas de ' || p_ano_referencia || ' e ' || p_ano_comparacao || '.');
      RETURN NULL;
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLERRM);
      RETURN NULL;
END;
/

/*
    Frontend (PL/SQL) para a função obter_vendas_por_ano
*/
CREATE OR REPLACE PROCEDURE imprimir_vendas_por_ano
(
    p_ano_referencia IN Tempo.ano%TYPE,
    p_ano_comparacao Tempo.idTempo%TYPE
) AS

  c_resultados SYS_REFCURSOR;
  ano_print Tempo.ano%TYPE;
  vendas_print float;

BEGIN
  c_resultados := obter_vendas_por_ano(p_ano_referencia, p_ano_comparacao);

    IF c_resultados IS NOT NULL THEN
        LOOP
            FETCH c_resultados INTO ano_print, vendas_print;
            EXIT WHEN c_resultados%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE('Ano: ' || ano_print || ', Vendas: ' || vendas_print || 'K€.');
        END LOOP;
    END IF;

END;
/

/*
    Resultado por bloco anonimo
*/
BEGIN
  imprimir_vendas_por_ano(2020, 2021);
END;
/

-- hardcoded select for proof testing
SELECT t.ano, SUM(s.vendas) AS vendas
    FROM Stats s
    INNER JOIN Tempo t ON s.idTempo = t.idTempo
    WHERE t.ano IN (2020, 2021)
    GROUP BY t.ano
    ORDER BY t.ano ASC;