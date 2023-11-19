--******************************************************************
--* BOOTSTRAP JÁ EXECUTADO PARA MAIOR EFICIÊNCIA DA EXECUÇÃO DA US *
--* EXECUTAR ESTE FICHEIRO NA SESSÃO SNOWFLAKE2                     *
--******************************************************************

/*
    Cria uma view que mostra o total de vendas por tipo de cultura e hub de distribuição.
*/

CREATE OR REPLACE VIEW vendasPorTipoCulturaEHub AS
SELECT c.tipoCultura, h.codigoHub, t.mes, t.ano, SUM(s.vendas) as total_vendas
FROM Stats s
INNER JOIN Tempo t ON s.idTempo = t.idTempo
INNER JOIN Cultura c ON s.idSetor = c.idSetor
INNER JOIN Hub h ON s.codigoHub = h.codigoHub
GROUP BY c.tipoCultura, h.codigoHub, t.mes, t.ano
ORDER BY c.tipoCultura ASC, h.codigoHub ASC, t.ano ASC, t.mes ASC;

-- Mostra a view criada.
SELECT * FROM vendasPorTipoCulturaEHub;