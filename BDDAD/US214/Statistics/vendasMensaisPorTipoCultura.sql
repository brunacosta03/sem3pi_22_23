/*
    Cria uma view que mostra o total de vendas por tipo de cultura.
*/

CREATE OR REPLACE VIEW vendasPorTipoCultura AS
SELECT c.tipoCultura, t.mes, t.ano, SUM(s.vendas) AS vendas
FROM Stats s
INNER JOIN Tempo t ON s.idTempo = t.idTempo
INNER JOIN Cultura c ON s.idSetor = c.idSetor
GROUP BY c.tipoCultura, t.mes, t.ano
ORDER BY c.tipoCultura ASC, t.ano ASC, t.mes ASC; -- Vai mostrar um tipo de cultura por vez, em ordem alfabética, de forma a poder avaliar a evolução mensal de cada tipo de cultura.

SELECT * FROM vendasPorTipoCultura;