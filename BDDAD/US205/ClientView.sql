CREATE OR REPLACE VIEW ClientView AS
SELECT idCliente AS "Id Cliente" ,
(
    SELECT COUNT(pc.idCliente) 
	FROM ENCOMENDACLIENTE pc
	WHERE pc.idCliente = c1.idCliente 
	AND pc.dataPagamento IS NOT NULL 
	AND pc.dataPedido >= ADD_MONTHS(SYSDATE, -12)
) AS "Total Vendas Ultimos 12 Meses",  
(    
    SELECT COUNT(idCliente) 
	FROM ENCOMENDACLIENTE pc2 
	WHERE pc2.idCliente = c1.idCliente 
	AND pc2.dataPagamento IS NULL 
	AND pc2.estadoPedido = 'entregue'
) AS "Encomendas Entregues Mas Nao Pagas",
(
    SELECT nvl( TO_CHAR(dataUltimoIncidente, 'DD-MM-YYYY'),'Sem incidentes à data' )
    FROM ClienteIncidentes ci
    WHERE ci.idCliente = c1.idCliente
) AS "Data Ultimo Incidente", 
nivel AS "Nivel"
FROM Cliente c1;