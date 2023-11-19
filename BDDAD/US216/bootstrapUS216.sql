
-- Bootstrap script for US216

-- Bootstrap tabela SETOR (ID RANGE = (1, 10))
INSERT INTO SETOR(IDSETOR, DESIGNACAO)
SELECT IDSETOR, DESIGNACAO
FROM DATAMODEL.SETOR;

-- Bootstrap tabela CULTURA (ID RANGE = (1, 11))
INSERT INTO CULTURA(IDCULTURA, TIPOCULTURA, DESIGNACAO, IDSETOR)
SELECT IDCULTURA, TIPOCULTURA, DESIGNACAO, IDSETOR
FROM DATAMODEL.CULTURA;

-- Bootstrap tabela PRODUTOAGRICOLA (ID RANGE = (1, 6))
INSERT INTO PRODUTOAGRICOLA(IDPRODUTO, DESIGNACAO)
SELECT IDPRODUTO, DESIGNACAO
FROM DATAMODEL.PRODUTOAGRICOLA;

-- Bootstrap tabela CULTURAPRODUTO
INSERT INTO CULTURAPRODUTO(IDCULTURA, IDPRODUTO)
SELECT IDCULTURA, IDPRODUTO
FROM DATAMODEL.CULTURAPRODUTO;

-- Bootstrap tabela CLIENTE (ID RANGE = (1, 7))
INSERT INTO CLIENTE(IDCLIENTE, NOME, NIF, EMAIL)
SELECT IDPESSOA, NOME, NIF, EMAIL
FROM DATAMODEL.PESSOA P
INNER JOIN DATAMODEL.CLIENTE C ON P.IDPESSOA = C.IDCLIENTE;

-- Bootstrap tabela HUB (ID RANGE = (CT99, CT98))
INSERT INTO HUB(CODIGOHUB, LATITUDE, LONGITUDE, CODIGOEP)
SELECT CODIGOHUB, LATITUDE, LONGITUDE, CODIGOEP
FROM DATAMODEL.HUB;

-- depois de inserir os hubs, atualizar a coluna tipoHub (primeiro caracter do codigoEP é o tipo do hub)
CREATE OR REPLACE PROCEDURE update_hub_tipoHub AS
BEGIN
    FOR r IN (SELECT codigoHub, codigoEP FROM Hub) LOOP
        UPDATE Hub
        SET tipoHub = SUBSTR(r.codigoEP, 1, 1)
        WHERE codigoHub = r.codigoHub;
    END LOOP;
END;
/

-- executar a procedure
BEGIN
    update_hub_tipoHub;
END;
/

-- Bootstrap tabela tempo(ano & mes) (ID RANGE = (1, 84))
INSERT INTO Tempo (idTempo, ano, mes) VALUES (1, 2016, 1);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (2, 2016, 2);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (3, 2016, 3);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (4, 2016, 4);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (5, 2016, 5);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (6, 2016, 6);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (7, 2016, 7);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (8, 2016, 8);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (9, 2016, 9);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (10, 2016, 10);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (11, 2016, 11);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (12, 2016, 12);

INSERT INTO Tempo (idTempo, ano, mes) VALUES (13, 2017, 1);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (14, 2017, 2);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (15, 2017, 3);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (16, 2017, 4);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (17, 2017, 5);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (18, 2017, 6);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (19, 2017, 7);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (20, 2017, 8);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (21, 2017, 9);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (22, 2017, 10);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (23, 2017, 11);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (24, 2017, 12);

INSERT INTO Tempo (idTempo, ano, mes) VALUES (25, 2018, 1);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (26, 2018, 2);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (27, 2018, 3);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (28, 2018, 4);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (29, 2018, 5);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (30, 2018, 6);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (31, 2018, 7);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (32, 2018, 8);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (33, 2018, 9);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (34, 2018, 10);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (35, 2018, 11);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (36, 2018, 12);

INSERT INTO Tempo (idTempo, ano, mes) VALUES (37, 2019, 1);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (38, 2019, 2);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (39, 2019, 3);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (40, 2019, 4);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (41, 2019, 5);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (42, 2019, 6);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (43, 2019, 7);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (44, 2019, 8);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (45, 2019, 9);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (46, 2019, 10);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (47, 2019, 11);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (48, 2019, 12);

INSERT INTO Tempo (idTempo, ano, mes) VALUES (49, 2020, 1);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (50, 2020, 2);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (51, 2020, 3);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (52, 2020, 4);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (53, 2020, 5);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (54, 2020, 6);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (55, 2020, 7);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (56, 2020, 8);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (57, 2020, 9);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (58, 2020, 10);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (59, 2020, 11);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (60, 2020, 12);

INSERT INTO Tempo (idTempo, ano, mes) VALUES (61, 2021, 1);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (62, 2021, 2);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (63, 2021, 3);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (64, 2021, 4);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (65, 2021, 5);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (66, 2021, 6);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (67, 2021, 7);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (68, 2021, 8);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (69, 2021, 9);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (70, 2021, 10);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (71, 2021, 11);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (72, 2021, 12);

INSERT INTO Tempo (idTempo, ano, mes) VALUES (73, 2022, 1);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (74, 2022, 2);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (75, 2022, 3);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (76, 2022, 4);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (77, 2022, 5);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (78, 2022, 6);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (79, 2022, 7);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (80, 2022, 8);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (81, 2022, 9);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (82, 2022, 10);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (83, 2022, 11);
INSERT INTO Tempo (idTempo, ano, mes) VALUES (84, 2022, 12);

-- Bootstrap de dados para a tabela de factos (Stats)

INSERT INTO STATS(VENDAS, PRODUCAO, IDTEMPO, IDCLIENTE, IDPRODUTO, IDSETOR, CODIGOHUB) VALUES (8.40, 1.62, 53, 1, 1, 1, 'CT99');
INSERT INTO STATS(VENDAS, PRODUCAO, IDTEMPO, IDCLIENTE, IDPRODUTO, IDSETOR, CODIGOHUB) VALUES (2.91, 1.26, 36, 4, 5, 7, 'CT98');
INSERT INTO STATS(VENDAS, PRODUCAO, IDTEMPO, IDCLIENTE, IDPRODUTO, IDSETOR, CODIGOHUB) VALUES (6.86, 1.01, 24, 4, 5, 7, 'CT98');
INSERT INTO STATS(VENDAS, PRODUCAO, IDTEMPO, IDCLIENTE, IDPRODUTO, IDSETOR, CODIGOHUB) VALUES (1.18, 2.01, 18, 5, 6, 7, 'CT98');
INSERT INTO STATS(VENDAS, PRODUCAO, IDTEMPO, IDCLIENTE, IDPRODUTO, IDSETOR, CODIGOHUB) VALUES (6.26, 1.89, 1, 2, 1, 5, 'CT98');
INSERT INTO STATS(VENDAS, PRODUCAO, IDTEMPO, IDCLIENTE, IDPRODUTO, IDSETOR, CODIGOHUB) VALUES (2.01, 1.76, 43, 5, 1, 5, 'CT99');
INSERT INTO STATS(VENDAS, PRODUCAO, IDTEMPO, IDCLIENTE, IDPRODUTO, IDSETOR, CODIGOHUB) VALUES (5.29, 0.25, 60, 3, 5, 7, 'CT99');
INSERT INTO STATS(VENDAS, PRODUCAO, IDTEMPO, IDCLIENTE, IDPRODUTO, IDSETOR, CODIGOHUB) VALUES (1.46, 2.38, 49, 3, 5, 7, 'CT99');
INSERT INTO STATS(VENDAS, PRODUCAO, IDTEMPO, IDCLIENTE, IDPRODUTO, IDSETOR, CODIGOHUB) VALUES (1.56, 2.39, 4, 7, 5, 7, 'CT98');
INSERT INTO STATS(VENDAS, PRODUCAO, IDTEMPO, IDCLIENTE, IDPRODUTO, IDSETOR, CODIGOHUB) VALUES (8.45, 1.12, 17, 7, 3, 3, 'CT98');
INSERT INTO STATS(VENDAS, PRODUCAO, IDTEMPO, IDCLIENTE, IDPRODUTO, IDSETOR, CODIGOHUB) VALUES (3.53, 1.32, 84, 4, 5, 7, 'CT99');
INSERT INTO STATS(VENDAS, PRODUCAO, IDTEMPO, IDCLIENTE, IDPRODUTO, IDSETOR, CODIGOHUB) VALUES (2.31, 1.42, 43, 1, 1, 1, 'CT99');
INSERT INTO STATS(VENDAS, PRODUCAO, IDTEMPO, IDCLIENTE, IDPRODUTO, IDSETOR, CODIGOHUB) VALUES (3.80, 2.78, 55, 3, 1, 1, 'CT99');
INSERT INTO STATS(VENDAS, PRODUCAO, IDTEMPO, IDCLIENTE, IDPRODUTO, IDSETOR, CODIGOHUB) VALUES (2.72, 0.97, 47, 5, 6, 7, 'CT98');
INSERT INTO STATS(VENDAS, PRODUCAO, IDTEMPO, IDCLIENTE, IDPRODUTO, IDSETOR, CODIGOHUB) VALUES (8.07, 0.28, 6, 5, 2, 2, 'CT98');
INSERT INTO STATS(VENDAS, PRODUCAO, IDTEMPO, IDCLIENTE, IDPRODUTO, IDSETOR, CODIGOHUB) VALUES (5.24, 2.70, 53, 6, 2, 2, 'CT98');
INSERT INTO STATS(VENDAS, PRODUCAO, IDTEMPO, IDCLIENTE, IDPRODUTO, IDSETOR, CODIGOHUB) VALUES (6.31, 1.51, 70, 7, 6, 7, 'CT99');
INSERT INTO STATS(VENDAS, PRODUCAO, IDTEMPO, IDCLIENTE, IDPRODUTO, IDSETOR, CODIGOHUB) VALUES (5.85, 1.65, 65, 1, 1, 1, 'CT99');
INSERT INTO STATS(VENDAS, PRODUCAO, IDTEMPO, IDCLIENTE, IDPRODUTO, IDSETOR, CODIGOHUB) VALUES (0.75, 2.28, 22, 5, 2, 2, 'CT98');
INSERT INTO STATS(VENDAS, PRODUCAO, IDTEMPO, IDCLIENTE, IDPRODUTO, IDSETOR, CODIGOHUB) VALUES (2.18, 2.93, 20, 2, 6, 7, 'CT98');
INSERT INTO STATS(VENDAS, PRODUCAO, IDTEMPO, IDCLIENTE, IDPRODUTO, IDSETOR, CODIGOHUB) VALUES (2.49, 1.18, 37, 3, 6, 7, 'CT98');
INSERT INTO STATS(VENDAS, PRODUCAO, IDTEMPO, IDCLIENTE, IDPRODUTO, IDSETOR, CODIGOHUB) VALUES (1.15, 2.38, 29, 5, 5, 7, 'CT98');
INSERT INTO STATS(VENDAS, PRODUCAO, IDTEMPO, IDCLIENTE, IDPRODUTO, IDSETOR, CODIGOHUB) VALUES (5.35, 1.69, 84, 5, 1, 1, 'CT98');
INSERT INTO STATS(VENDAS, PRODUCAO, IDTEMPO, IDCLIENTE, IDPRODUTO, IDSETOR, CODIGOHUB) VALUES (4.23, 1.30, 29, 2, 6, 7, 'CT99');
INSERT INTO STATS(VENDAS, PRODUCAO, IDTEMPO, IDCLIENTE, IDPRODUTO, IDSETOR, CODIGOHUB) VALUES (0.29, 2.43, 54, 3, 1, 5, 'CT99');
INSERT INTO STATS(VENDAS, PRODUCAO, IDTEMPO, IDCLIENTE, IDPRODUTO, IDSETOR, CODIGOHUB) VALUES (6.47, 3.02, 55, 3, 3, 3, 'CT99');
INSERT INTO STATS(VENDAS, PRODUCAO, IDTEMPO, IDCLIENTE, IDPRODUTO, IDSETOR, CODIGOHUB) VALUES (1.99, 2.01, 7, 5, 2, 2, 'CT99');
INSERT INTO STATS(VENDAS, PRODUCAO, IDTEMPO, IDCLIENTE, IDPRODUTO, IDSETOR, CODIGOHUB) VALUES (2.55, 2.87, 75, 4, 3, 3, 'CT98');
INSERT INTO STATS(VENDAS, PRODUCAO, IDTEMPO, IDCLIENTE, IDPRODUTO, IDSETOR, CODIGOHUB) VALUES (3.35, 2.33, 6, 2, 3, 3, 'CT98');
INSERT INTO STATS(VENDAS, PRODUCAO, IDTEMPO, IDCLIENTE, IDPRODUTO, IDSETOR, CODIGOHUB) VALUES (4.26, 0.51, 68, 3, 2, 2, 'CT98');
INSERT INTO STATS(VENDAS, PRODUCAO, IDTEMPO, IDCLIENTE, IDPRODUTO, IDSETOR, CODIGOHUB) VALUES (8.50, 1.38, 76, 6, 1, 1, 'CT98');
INSERT INTO STATS(VENDAS, PRODUCAO, IDTEMPO, IDCLIENTE, IDPRODUTO, IDSETOR, CODIGOHUB) VALUES (1.38, 0.18, 49, 1, 5, 7, 'CT99');
INSERT INTO STATS(VENDAS, PRODUCAO, IDTEMPO, IDCLIENTE, IDPRODUTO, IDSETOR, CODIGOHUB) VALUES (7.34, 2.73, 4, 6, 4, 4, 'CT98');
INSERT INTO STATS(VENDAS, PRODUCAO, IDTEMPO, IDCLIENTE, IDPRODUTO, IDSETOR, CODIGOHUB) VALUES (1.85, 1.79, 75, 1, 1, 1, 'CT99');
INSERT INTO STATS(VENDAS, PRODUCAO, IDTEMPO, IDCLIENTE, IDPRODUTO, IDSETOR, CODIGOHUB) VALUES (0.27, 2.66, 14, 3, 4, 4, 'CT98');
INSERT INTO STATS(VENDAS, PRODUCAO, IDTEMPO, IDCLIENTE, IDPRODUTO, IDSETOR, CODIGOHUB) VALUES (2.99, 2.14, 23, 3, 6, 7, 'CT98');
INSERT INTO STATS(VENDAS, PRODUCAO, IDTEMPO, IDCLIENTE, IDPRODUTO, IDSETOR, CODIGOHUB) VALUES (3.85, 0.98, 18, 6, 1, 1, 'CT99');
INSERT INTO STATS(VENDAS, PRODUCAO, IDTEMPO, IDCLIENTE, IDPRODUTO, IDSETOR, CODIGOHUB) VALUES (10.06, 0.48, 66, 2, 1, 5, 'CT99');
INSERT INTO STATS(VENDAS, PRODUCAO, IDTEMPO, IDCLIENTE, IDPRODUTO, IDSETOR, CODIGOHUB) VALUES (9.57, 2.83, 17, 6, 6, 7, 'CT99');
INSERT INTO STATS(VENDAS, PRODUCAO, IDTEMPO, IDCLIENTE, IDPRODUTO, IDSETOR, CODIGOHUB) VALUES (3.80, 0.63, 31, 5, 2, 2, 'CT98');
INSERT INTO STATS(VENDAS, PRODUCAO, IDTEMPO, IDCLIENTE, IDPRODUTO, IDSETOR, CODIGOHUB) VALUES (6.57, 1.75, 12, 4, 6, 7, 'CT99');
INSERT INTO STATS(VENDAS, PRODUCAO, IDTEMPO, IDCLIENTE, IDPRODUTO, IDSETOR, CODIGOHUB) VALUES (4.89, 3.09, 78, 7, 3, 3, 'CT99');
INSERT INTO STATS(VENDAS, PRODUCAO, IDTEMPO, IDCLIENTE, IDPRODUTO, IDSETOR, CODIGOHUB) VALUES (0.93, 0.64, 15, 2, 3, 3, 'CT98');
INSERT INTO STATS(VENDAS, PRODUCAO, IDTEMPO, IDCLIENTE, IDPRODUTO, IDSETOR, CODIGOHUB) VALUES (3.71, 1.05, 20, 2, 1, 5, 'CT98');
INSERT INTO STATS(VENDAS, PRODUCAO, IDTEMPO, IDCLIENTE, IDPRODUTO, IDSETOR, CODIGOHUB) VALUES (2.32, 2.79, 6, 5, 3, 3, 'CT99');
INSERT INTO STATS(VENDAS, PRODUCAO, IDTEMPO, IDCLIENTE, IDPRODUTO, IDSETOR, CODIGOHUB) VALUES (3.49, 1.30, 75, 7, 6, 7, 'CT98');
INSERT INTO STATS(VENDAS, PRODUCAO, IDTEMPO, IDCLIENTE, IDPRODUTO, IDSETOR, CODIGOHUB) VALUES (1.18, 2.19, 50, 7, 5, 7, 'CT98');
INSERT INTO STATS(VENDAS, PRODUCAO, IDTEMPO, IDCLIENTE, IDPRODUTO, IDSETOR, CODIGOHUB) VALUES (9.07, 1.29, 30, 3, 4, 4, 'CT99');
INSERT INTO STATS(VENDAS, PRODUCAO, IDTEMPO, IDCLIENTE, IDPRODUTO, IDSETOR, CODIGOHUB) VALUES (2.94, 2.04, 52, 5, 5, 7, 'CT99');
INSERT INTO STATS(VENDAS, PRODUCAO, IDTEMPO, IDCLIENTE, IDPRODUTO, IDSETOR, CODIGOHUB) VALUES (1.92, 1.70, 38, 4, 5, 7, 'CT98');





