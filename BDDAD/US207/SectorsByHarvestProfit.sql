-- backend
CREATE OR REPLACE FUNCTION fnc_get_sectors_by_harvest_profit
(search_idGestorAgricola IN Setor.idGestorAgricola%TYPE,
 search_idSafra IN Safra.idSafra%TYPE) 

RETURN SYS_REFCURSOR

IS
    l_cursor SYS_REFCURSOR;
BEGIN

open l_cursor for 
SELECT s.idSetor, ((sa.lucro/sa.areaSafra)/sa.periodicidade)
FROM Setor s
INNER JOIN Cultura c
    ON s.idSetor = c.idSetor
INNER JOIN Safra sa
    ON c.idCultura = sa.idCultura
WHERE s.idGestorAgricola = search_idGestorAgricola
AND sa.idSafra = search_idSafra
ORDER BY ((sa.lucro/sa.areaSafra)/sa.periodicidade) DESC;

return l_cursor;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nenhum setor encontrado ou safra não cadastrada');
        return NULL;    
END;
/

-- frontend
CREATE OR REPLACE PROCEDURE prc_show_sectors_by_harvest_profit
(search_idGestorAgricola IN Setor.idGestorAgricola%TYPE,
 search_idSafra IN Safra.idSafra%TYPE)

IS
    l_cursor SYS_REFCURSOR;
    cursor_idSetor Setor.idSetor%TYPE;
    cursor_lucro NUMBER;
BEGIN
    l_cursor := fnc_get_sectors_by_harvest_profit(search_idGestorAgricola, search_idSafra);
    IF l_cursor IS NOT NULL THEN
        LOOP
            FETCH l_cursor INTO cursor_idSetor, cursor_lucro;
            EXIT WHEN l_cursor%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE('Setor: ' || cursor_idSetor || ' Lucro: ' || cursor_lucro);
        END LOOP;
    END IF;
END;
/

BEGIN
    prc_show_sectors_by_harvest_profit(8, 1);
END; 
/