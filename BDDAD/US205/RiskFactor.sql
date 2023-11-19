CREATE OR REPLACE FUNCTION RiskFactor(id_cliente_to_check IN Cliente.idCliente%TYPE)

RETURN NUMBER

IS

    riskFactor NUMBER;
    dataUltimoIncidenteToCheck DATE;
    valorTotalIncidentesCliente NUMBER;
    numeroEncomendasPosIncidente NUMBER;

BEGIN

    SELECT SUM(valorDivida)  
    INTO valorTotalIncidentesCliente
    FROM Incidente
    WHERE idCliente = id_cliente_to_check
    AND dataOcorrencia >= add_months(sysdate, -12);

    SELECT dataUltimoIncidente
    INTO dataUltimoIncidenteToCheck
    FROM ClienteIncidentes
    WHERE idCliente = id_cliente_to_check;

    SELECT COUNT(*)
    INTO numeroEncomendasPosIncidente
    FROM ENCOMENDACLIENTE
    WHERE idCliente = id_cliente_to_check
    AND dataPedido > dataUltimoIncidenteToCheck
    AND dataPagamento = NULL;
    
    IF numeroEncomendasPosIncidente = 0 THEN
        riskFactor := 0;
        DBMS_OUTPUT.PUT_LINE('Fator de risco do cliente ' || id_cliente_to_check || ': ' || riskFactor);
    ELSE
        riskFactor := valorTotalIncidentesCliente / numeroEncomendasPosIncidente;
        DBMS_OUTPUT.PUT_LINE('Fator de risco do cliente ' || id_cliente_to_check || ': ' || riskFactor);
    END IF;

    RETURN riskFactor;

EXCEPTION
    
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Cliente sem incidentes ou não existe.');
        RETURN NULL;

END;
/
