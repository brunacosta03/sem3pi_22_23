CREATE OR REPLACE PROCEDURE prc_update_client_level AS
 
BEGIN 
-- if total sells last year was >5000 client becomes level B
UPDATE Cliente c1 
SET c1.nivel = 'B'
WHERE (
        SELECT valorTotalEncomendas
        FROM ClienteEncomendasAnuais cea1
        WHERE cea1.idCliente = c1.idCliente
        ) >= 5000 
AND idCliente = c1.idCliente
AND (
        SELECT count(*) 
        FROM Incidente i1
        WHERE i1.idCliente = c1.idCliente
        AND i1.dataOcorrencia >= ADD_MONTHS(SYSDATE, -12)
        ) = 0; 

-- if total sells last year was >10000 client becomes level A
UPDATE Cliente c2 
SET c2.nivel = 'A'
WHERE (
        SELECT valorTotalEncomendas
        FROM ClienteEncomendasAnuais cea2
        WHERE cea2.idCliente = c2.idCliente
        ) >= 10000 
AND idCliente = c2.idCliente
AND (
        SELECT COUNT(*) 
        FROM Incidente i2
        WHERE i2.idCliente = c2.idCliente
        AND i2.dataOcorrencia >= ADD_MONTHS(SYSDATE, -12)
        ) = 0; 

-- if client has any incident in the last year, client becomes level C
UPDATE Cliente c3
SET c3.nivel = 'C'
WHERE (
        SELECT COUNT(*) 
        FROM Incidente i3
        WHERE i3.idCliente = c3.idCliente
        AND i3.dataOcorrencia >= ADD_MONTHS(SYSDATE, -12)
) > 0;

END;
/
