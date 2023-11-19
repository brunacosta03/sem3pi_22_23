--*****************************************************
--* PARA RELIZAR TESTES POR FAVOR USAR TABELAS VAZIAS *
--*****************************************************

--Table MORADA
Insert into MORADA (ENDERECO,CODIGOPOSTAL) values ('RUA DO ISEP','4444-333');/* Aprovado */
Insert into MORADA (ENDERECO,CODIGOPOSTAL) values ('RUA DO ISEP 2','ERROR'); /* Rejeitado (check constraint cod postal) */
Insert into MORADA (ENDERECO,CODIGOPOSTAL) values (NULL,'1233-123'); /* Rejeitado (not null constraint) */
Insert into MORADA (ENDERECO,CODIGOPOSTAL) values ('Rua das Flores',NULL); /* Rejeitado (not null constraint) */

--Table PESSOA
Insert into PESSOA (NOME,NIF,EMAIL) values ('Samuel','111222333','samuel83a@gmail.com'); /* Aprovado */
Insert into PESSOA (NOME,NIF,EMAIL) values ('EXAMPLE','ERROR','example@gmail.com'); /* Rejeitado (check constraint nif)(9 digits) */
Insert into PESSOA (NOME,NIF,EMAIL) values ('Henrique','123456789','ERROR'); /* Rejeitado (check constraint email)(text@text.text) */
Insert into PESSOA (NOME,NIF,EMAIL) values (NULL,'987654321','bruna@gmail.com'); /* Rejeitado (not null constraint) */
Insert into PESSOA (NOME,NIF,EMAIL) values ('Pedro Alves',NULL,'pedro@gmail.com'); /* Rejeitado (not null constraint) */
Insert into PESSOA (NOME,NIF,EMAIL) values ('Maria','456456456',NULL); /* Rejeitado (not null constraint) */
Insert into PESSOA (NOME,NIF,EMAIL) values ('Fabio','111222333','fabio@gmail.com'); /* Rejeitado (unique constraint)(nif) */
Insert into PESSOA (NOME,NIF,EMAIL) values ('Daniela','731253123','samuel83a@gmail.com'); /* Rejeitado (unique constraint)(email) */
Insert into PESSOA (NOME,NIF,EMAIL) values ('Ana','888765123','ana@gmail.com'); /* Aprovado */
Insert into PESSOA (NOME,NIF,EMAIL) values ('Priscila','999777123','priscila@gmail.com'); /* Aprovado */
Insert into PESSOA (NOME,NIF,EMAIL) values ('Mário','949747124','mario@gmail.com'); /* Aprovado */
Insert into PESSOA (NOME,NIF,EMAIL) values ('Filipe','545745124','filipe@gmail.com'); /* Aprovado */
Insert into PESSOA (NOME,NIF,EMAIL) values ('Miguel','443247199','miguel@gmail.com'); /* Aprovado */
Insert into PESSOA (NOME,NIF,EMAIL) values ('Gabriel','145735188','gabriel@gmail.com'); /* Aprovado */
Insert into PESSOA (NOME,NIF,EMAIL) values ('Bernardo','998811189','bernardo@gmail.com'); /* Aprovado */

--Table CLIENTE
Insert into CLIENTE (IDCLIENTE,NIVEL,plafond,IDMORADAENTREGA,IDMORADA) values ('1','C','1000','1','1'); /* Aprovado */
Insert into CLIENTE (IDCLIENTE,NIVEL,plafond,IDMORADAENTREGA,IDMORADA) values ('2','C','-5','2','2'); /* Rejeitado (check constraint plafond) */
Insert into CLIENTE (IDCLIENTE,NIVEL,plafond,IDMORADAENTREGA,IDMORADA) values ('3','C','2500',NULL,'3'); /* Rejeitado (not null constraint) */
Insert into CLIENTE (IDCLIENTE,NIVEL,plafond,IDMORADAENTREGA,IDMORADA) values ('4','C','10000','4',NULL); /* Rejeitado (not null constraint) */
Insert into CLIENTE (IDCLIENTE,NIVEL,plafond,IDMORADAENTREGA,IDMORADA) values (NULL,'C','750','2','5'); /* Rejeitado (primary key constraint) */
Insert into CLIENTE (IDCLIENTE,NIVEL,plafond,IDMORADAENTREGA,IDMORADA) values ('6','ERROR','20000','2','5'); /* Rejeitado (check constraint nivel) */
Insert into CLIENTE (IDCLIENTE,NIVEL,plafond,IDMORADAENTREGA,IDMORADA) values ('7',NULL,'20000','1','5'); /* Rejeitado (not null constraint) */
Insert into CLIENTE (IDCLIENTE,NIVEL,plafond,IDMORADAENTREGA,IDMORADA) values ('8','C',NULL,'1','5'); /* Rejeitado (not null constraint) */

--Table GESTORAGRICOLA
Insert into GESTORAGRICOLA (IDGESTORAGRICOLA) values ('9'); /* Aprovado */
Insert into GESTORAGRICOLA (IDGESTORAGRICOLA) values (NULL); /* Rejeitado (primary key constraint) */

--Table SETOR
Insert into SETOR (DESIGNACAO,AREA,IDGESTORAGRICOLA) values ('Campo de Batatas','25','9'); /* Aprovado */
Insert into SETOR (DESIGNACAO,AREA,IDGESTORAGRICOLA) values (NULL,'30','9'); /* Rejeitado (not null constraint) */
Insert into SETOR (DESIGNACAO,AREA,IDGESTORAGRICOLA) values ('Campo de Cenouras','-27','9'); /* Rejeitado (check constraint area) */
Insert into SETOR (DESIGNACAO,AREA,IDGESTORAGRICOLA) values ('Campo de Feijao','22',NULL); /* Rejeitado (not null constraint) */
Insert into SETOR (DESIGNACAO,AREA,IDGESTORAGRICOLA) values ('Campo de Batatas/Cebolas',NULL,'9'); /* Rejeitado (not null constraint) */
Insert into SETOR (DESIGNACAO,AREA,IDGESTORAGRICOLA) values ('Campo de Macieiras','33','9'); /* Aprovado */
Insert into SETOR (DESIGNACAO,AREA,IDGESTORAGRICOLA) values ('Campo de Laranjeiras','32','9'); /* Aprovado */
Insert into SETOR (DESIGNACAO,AREA,IDGESTORAGRICOLA) values ('Campo de Trigo','50','9'); /* Aprovado */
Insert into SETOR (DESIGNACAO,AREA,IDGESTORAGRICOLA) values ('Campo de Ervilhaca ','34','9'); /* Aprovado */
Insert into SETOR (DESIGNACAO,AREA,IDGESTORAGRICOLA) values ('Campo de Inhame','31','9'); /* Aprovado */

--Table CULTURA
Insert into CULTURA (NOMECULTURA,TIPOCULTURA,DESIGNACAO,IDSETOR) values (NULL,'permanente','Espécie Vegetal','1'); /* Rejeitado (not null constraint) */
Insert into CULTURA (NOMECULTURA,TIPOCULTURA,DESIGNACAO,IDSETOR) values ('Cebolas',NULL,'Espécie Vegetal','2'); /* Rejeitado (not null constraint) */
Insert into CULTURA (NOMECULTURA,TIPOCULTURA,DESIGNACAO,IDSETOR) values ('Cenouras','permanente',NULL,'3'); /* Rejeitado (not null constraint) */
Insert into CULTURA (NOMECULTURA,TIPOCULTURA,DESIGNACAO,IDSETOR) values ('Feijao','temporario','Espécie Vegetal',NULL); /* Rejeitado (not null constraint) */
Insert into CULTURA (NOMECULTURA,TIPOCULTURA,DESIGNACAO,IDSETOR) values ('Batatas','temporario','Espécie Vegetal','6'); /* Aprovado */
Insert into CULTURA (NOMECULTURA,TIPOCULTURA,DESIGNACAO,IDSETOR) values ('Cebolas','temporario','Espécie Vegetal','7'); /* Aprovado */
Insert into CULTURA (NOMECULTURA,TIPOCULTURA,DESIGNACAO,IDSETOR) values ('Macieiras','permanente','Espécie Vegetal','8'); /* Aprovado */
Insert into CULTURA (NOMECULTURA,TIPOCULTURA,DESIGNACAO,IDSETOR) values ('Laranjeiras','permanente','Produzir Adubação Verde','8'); /* Aprovado */
Insert into CULTURA (NOMECULTURA,TIPOCULTURA,DESIGNACAO,IDSETOR) values ('Trigo','temporario','Produzir Adubação Verde','6'); /* Aprovado */
Insert into CULTURA (NOMECULTURA,TIPOCULTURA,DESIGNACAO,IDSETOR) values ('Ervilhaca','temporario','Espécie Vegetal','6'); /* Aprovado */
Insert into CULTURA (NOMECULTURA,TIPOCULTURA,DESIGNACAO,IDSETOR) values ('Inhame','temporario','Espécie Vegetal','10'); /* Aprovado */
Insert into CULTURA (NOMECULTURA,TIPOCULTURA,DESIGNACAO,IDSETOR) values ('Batatas','temporario','Espécie Vegetal','9'); /* Aprovado */

--Table SAFRA
Insert into SAFRA (IDCULTURA,LUCRO,QUANTIDADE,PERIODICIDADE,AREASAFRA) values (NULL,'1500','100','10','30'); /* Rejeitado (not null constraint) */
Insert into SAFRA (IDCULTURA,LUCRO,QUANTIDADE,PERIODICIDADE,AREASAFRA) values ('2',NULL,'40','12','50'); /* Rejeitado (not null constraint) */
Insert into SAFRA (IDCULTURA,LUCRO,QUANTIDADE,PERIODICIDADE,AREASAFRA) values ('3','567',NULL,'7','20'); /* Rejeitado (not null constraint) */
Insert into SAFRA (IDCULTURA,LUCRO,QUANTIDADE,PERIODICIDADE,AREASAFRA) values ('4','867','123',NULL,'30'); /* Rejeitado (not null constraint) */
Insert into SAFRA (IDCULTURA,LUCRO,QUANTIDADE,PERIODICIDADE,AREASAFRA) values ('5','123','50','4',NULL); /* Rejeitado (not null constraint) */
Insert into SAFRA (IDCULTURA,LUCRO,QUANTIDADE,PERIODICIDADE,AREASAFRA) values ('6','400','67','20','-40'); /* Rejeitado (check constraint area) */
Insert into SAFRA (IDCULTURA,LUCRO,QUANTIDADE,PERIODICIDADE,AREASAFRA) values ('8','467','1234','-12','80'); /* Rejeitado (check constraint periodicidade) */
Insert into SAFRA (IDCULTURA,LUCRO,QUANTIDADE,PERIODICIDADE,AREASAFRA) values ('8','567','-123','12','80'); /* Rejeitado (check constraint quantidade) */
Insert into SAFRA (IDCULTURA,LUCRO,QUANTIDADE,PERIODICIDADE,AREASAFRA) values ('7','-567','123','12','80'); /* Rejeitado (check constraint lucro) */
Insert into SAFRA (IDCULTURA,LUCRO,QUANTIDADE,PERIODICIDADE,AREASAFRA) values ('8','567','123','12','80'); /* Aprovado */
Insert into SAFRA (IDCULTURA,LUCRO,QUANTIDADE,PERIODICIDADE,AREASAFRA) values ('8','567','123','12','80'); /* Aprovado */

--Table FATORPRODUCAO
Insert into FATORPRODUCAO (NOMECOMERCIAL,FORMULACAO,CLASSIFICACAOFATOR,FORNECEDOR) values ('Florlis Energy Azul','liquido','fertilizantes','Florlis'); /* Aprovado */
Insert into FATORPRODUCAO (NOMECOMERCIAL,FORMULACAO,CLASSIFICACAOFATOR,FORNECEDOR) values (NULL,'liquido','adubo','Florlis'); /* Rejeitado (not null constraint) */
Insert into FATORPRODUCAO (NOMECOMERCIAL,FORMULACAO,CLASSIFICACAOFATOR,FORNECEDOR) values ('Florlis Energy Laranja',NULL,'correctivos','Florlis'); /* Rejeitado (not null constraint) */
Insert into FATORPRODUCAO (NOMECOMERCIAL,FORMULACAO,CLASSIFICACAOFATOR,FORNECEDOR) values ('Florlis Eco','liquido',NULL,'Florlis'); /* Rejeitado (not null constraint) */
Insert into FATORPRODUCAO (NOMECOMERCIAL,FORMULACAO,CLASSIFICACAOFATOR,FORNECEDOR) values ('Bio Nova Azul','ERROR','fertilizantes','Bio Nova'); /* Rejeitado (check constraint formulacao) */
Insert into FATORPRODUCAO (NOMECOMERCIAL,FORMULACAO,CLASSIFICACAOFATOR,FORNECEDOR) values ('Bio Nova Verde','po','ERROR','Bio Nova'); /* Rejeitado (check constraint) */
Insert into FATORPRODUCAO (NOMECOMERCIAL,FORMULACAO,CLASSIFICACAOFATOR,FORNECEDOR) values ('Bio Nova Eco','granulado','correctivos','Bio Nova'); /* Aprovado */
Insert into FATORPRODUCAO (NOMECOMERCIAL,FORMULACAO,CLASSIFICACAOFATOR,FORNECEDOR) values ('Bio Nova Laranja','po','adubo','Bio Nova'); /* Aprovado */
Insert into FATORPRODUCAO (NOMECOMERCIAL,FORMULACAO,CLASSIFICACAOFATOR,FORNECEDOR) values ('Bio Nova Azul','liquido','fertilizantes',NULL); /* Rejeitado (not null constraint) */


--Table FICHATECNICA
Insert into FICHATECNICA (IDFATORPRODUCAO,CATEGORIA) values ('1',NULL); /* Rejeitado (not null constraint) */
Insert into FICHATECNICA (IDFATORPRODUCAO,CATEGORIA) values (NULL,'Ficha Técnica do adubo Florlis Energy Verde'); /* Rejeitado (primary key constraint) */
Insert into FICHATECNICA (IDFATORPRODUCAO,CATEGORIA) values ('1','Ficha Técnica do correctivo Florlis Energy Laranja'); /* Aprovado */
Insert into FICHATECNICA (IDFATORPRODUCAO,CATEGORIA) values ('7','Ficha Técnica do fitofarmaco Florlis Eco'); /* Aprovado */


--Table ELEMENTO
Insert into ELEMENTO (SUBSTANCIA,QUANTIDADE,UNIDADE) values ('Azoto','6','exemplo'); /* Aprovado */
Insert into ELEMENTO (SUBSTANCIA,QUANTIDADE,UNIDADE) values ('Pentóxido de fósforo','15','exemplo'); /* Aprovado */
Insert into ELEMENTO (SUBSTANCIA,QUANTIDADE,UNIDADE) values ('Óxido de potássio','2','exemplo'); /* Aprovado */
Insert into ELEMENTO (SUBSTANCIA,QUANTIDADE,UNIDADE) values ('Óxido de cálcio','10','exemplo'); /* Aprovado */
Insert into ELEMENTO (SUBSTANCIA,QUANTIDADE,UNIDADE) values ('Óxido de magnésio','2','exemplo');    /* Aprovado */
Insert into ELEMENTO (SUBSTANCIA,QUANTIDADE,UNIDADE) values ('Carbono de origem biológica','35','exemplo'); /* Aprovado */
Insert into ELEMENTO (SUBSTANCIA,QUANTIDADE,UNIDADE) values ('Matéria Orgânica','60','exemplo'); /* Aprovado */
Insert into ELEMENTO (SUBSTANCIA,QUANTIDADE,UNIDADE) values ('Ácidos húmicos',NULL,'exemplo'); /* Rejeitado (not null constraint) */
Insert into ELEMENTO (SUBSTANCIA,QUANTIDADE,UNIDADE) values (NULL,'8','exemplo'); /* Rejeitado (not null constraint) */
Insert into ELEMENTO (SUBSTANCIA,QUANTIDADE,UNIDADE) values ('Azoto','6',NULL); /* Rejeitado (not null constraint) */

--Table FICHATECNICAELEMENTO
Insert into FICHATECNICAELEMENTO (IDFATORPRODUCAO,IDELEMENTO) values ('1','1'); /* Aprovado */
Insert into FICHATECNICAELEMENTO (IDFATORPRODUCAO,IDELEMENTO) values ('1','2'); /* Aprovado */
Insert into FICHATECNICAELEMENTO (IDFATORPRODUCAO,IDELEMENTO) values ('1','5'); /* Aprovado */
Insert into FICHATECNICAELEMENTO (IDFATORPRODUCAO,IDELEMENTO) values (NULL,'3'); /* Rejeitado (primary key constraint) */
Insert into FICHATECNICAELEMENTO (IDFATORPRODUCAO,IDELEMENTO) values ('2',NULL); /* Rejeitado (primary key constraint) */
Insert into FICHATECNICAELEMENTO (IDFATORPRODUCAO,IDELEMENTO) values (NULL,NULL); /* Rejeitado (primary key constraint) */


--Table CULTURAFATORPRODUCAO
Insert into CULTURAFATORPRODUCAO (IDCULTURA,IDFATORPRODUCAO) values ('6','1'); /* Aprovado */
Insert into CULTURAFATORPRODUCAO (IDCULTURA,IDFATORPRODUCAO) values (NULL,NULL); /* Rejeitado (primary key constraint) */
Insert into CULTURAFATORPRODUCAO (IDCULTURA,IDFATORPRODUCAO) values (NULL,'4'); /* Rejeitado (primary key constraint) */
Insert into CULTURAFATORPRODUCAO (IDCULTURA,IDFATORPRODUCAO) values ('2',NULL); /* Rejeitado (primary key constraint) */

--Table SISTEMAREGA
Insert into SISTEMAREGA (TIPODISTRIBUICAO,TIPOREGA,IDGESTORAGRICOLA) values ('aspersao','gravidade','9'); /* Aprovado */
Insert into SISTEMAREGA (TIPODISTRIBUICAO,TIPOREGA,IDGESTORAGRICOLA) values ('aspersao','bombeada',NULL); /* Rejeitado (not null constraint) */
Insert into SISTEMAREGA (TIPODISTRIBUICAO,TIPOREGA,IDGESTORAGRICOLA) values ('gotejamento',NULL,'9'); /* Rejeitado (not null constraint) */
Insert into SISTEMAREGA (TIPODISTRIBUICAO,TIPOREGA,IDGESTORAGRICOLA) values (NULL,'bombeada','9'); /* Rejeitado (not null constraint) */
Insert into SISTEMAREGA (TIPODISTRIBUICAO,TIPOREGA,IDGESTORAGRICOLA) values ('pulverizacao','error','9'); /* Rejeitado (check constraint) */
Insert into SISTEMAREGA (TIPODISTRIBUICAO,TIPOREGA,IDGESTORAGRICOLA) values ('error','bombeada','9'); /* Rejeitado (check constraint) */

--Table PLANOREGA
Insert into PLANOREGA (PARCELASREGA,TEMPOREGA,PERIODICIDADE) values ('5','5','semanal'); /* Aprovado */
Insert into PLANOREGA (PARCELASREGA,TEMPOREGA,PERIODICIDADE) values ('-6','10','semanal'); /* Rejeitado (check constraint) */
Insert into PLANOREGA (PARCELASREGA,TEMPOREGA,PERIODICIDADE) values ('10','-8','diario'); /* Rejeitado (check constraint) */
Insert into PLANOREGA (PARCELASREGA,TEMPOREGA,PERIODICIDADE) values ('9','4','error'); /* Rejeitado (check constraint) */
Insert into PLANOREGA (PARCELASREGA,TEMPOREGA,PERIODICIDADE) values ('6','7','semanal'); /* Aprovado */
Insert into PLANOREGA (PARCELASREGA,TEMPOREGA,PERIODICIDADE) values ('8','12','diario'); /* Aprovado */
Insert into PLANOREGA (PARCELASREGA,TEMPOREGA,PERIODICIDADE) values ('12','11','diario'); /* Aprovado */
Insert into PLANOREGA (PARCELASREGA,TEMPOREGA,PERIODICIDADE) values ('13','6','mensal'); /* Aprovado */

--Table CONTROLADOR
Insert into CONTROLADOR (IDSISTEMAREGA,IDPLANOREGA) values (NULL,NULL); /* Rejeitado (primary key constraint) */
Insert into CONTROLADOR (IDSISTEMAREGA,IDPLANOREGA) values ('1','1'); /* Aprovado */
Insert into CONTROLADOR (IDSISTEMAREGA,IDPLANOREGA) values (NULL,'2'); /* Rejeitado (primary key constraint) */
Insert into CONTROLADOR (IDSISTEMAREGA,IDPLANOREGA) values ('1',NULL); /* Rejeitado (primary key constraint) */

--Table PLANOANUAL
Insert into PLANOANUAL (CORRECOESMINERAIS,FERTILIZACAO,NECESSIDADEREGA,REALIZADOVIA,ANO) values ('E necessario aplicar produtos minerais de 5 em 5 dias','Usar produtos de fertelizacao','5','sistema de rega','2022'); /* Aprovado */
Insert into PLANOANUAL (CORRECOESMINERAIS,FERTILIZACAO,NECESSIDADEREGA,REALIZADOVIA,ANO) values ('E necessario aplicar produtos minerais de 10 em 10 dias','Usar produtos de fertelizacao','10','aplicacao direta','2021'); /* Aprovado */
Insert into PLANOANUAL (CORRECOESMINERAIS,FERTILIZACAO,NECESSIDADEREGA,REALIZADOVIA,ANO) values (NULL,'Usar produtos de fertelizacao','15','sistema de rega','2020'); /* Rejeitado (not null constraint) */
Insert into PLANOANUAL (CORRECOESMINERAIS,FERTILIZACAO,NECESSIDADEREGA,REALIZADOVIA,ANO) values ('E necessario aplicar produtos minerais de 5 em 5 dias',NULL,'20','aplicacao direta','2020'); /* Rejeitado (not null constraint) */
Insert into PLANOANUAL (CORRECOESMINERAIS,FERTILIZACAO,NECESSIDADEREGA,REALIZADOVIA,ANO) values ('E necessario aplicar produtos minerais de 5 em 5 dias','Usar produtos de fertelizacao',NULL,'sistema de rega','2020'); /* Rejeitado (not null constraint) */
Insert into PLANOANUAL (CORRECOESMINERAIS,FERTILIZACAO,NECESSIDADEREGA,REALIZADOVIA,ANO) values ('E necessario aplicar produtos minerais de 5 em 5 dias','Usar produtos de fertelizacao','25',NULL,'2020'); /* Rejeitado (not null constraint) */
Insert into PLANOANUAL (CORRECOESMINERAIS,FERTILIZACAO,NECESSIDADEREGA,REALIZADOVIA,ANO) values ('E necessario aplicar produtos minerais de 5 em 5 dias','Usar produtos de fertelizacao','30','error','2020'); /* Rejeitado (check constraint) */
Insert into PLANOANUAL (CORRECOESMINERAIS,FERTILIZACAO,NECESSIDADEREGA,REALIZADOVIA,ANO) values ('E necessario aplicar produtos minerais de 5 em 5 dias','Usar produtos de fertelizacao','35','sistema de rega','12'); /* Rejeitado (check constraint) */


--Table APLICACOESREALIZAR
Insert into APLICACOESREALIZAR (IDCULTURA,IDPLANOANUAL,QUANTIDADE,DATAPREVISTA) values ('6','1','10',to_date('22.11.24','RR.MM.DD')); /* Aprovado */
Insert into APLICACOESREALIZAR (IDCULTURA,IDPLANOANUAL,QUANTIDADE,DATAPREVISTA) values (NULL,NULL,'20',to_date('22.11.24','RR.MM.DD')); /* Rejeitado (primary key constraint) */
Insert into APLICACOESREALIZAR (IDCULTURA,IDPLANOANUAL,QUANTIDADE,DATAPREVISTA) values ('2','1','-5',to_date('22.11.30','RR.MM.DD')); /* Rejeitado (check constraint) */
Insert into APLICACOESREALIZAR (IDCULTURA,IDPLANOANUAL,QUANTIDADE,DATAPREVISTA) values ('1','2',NULL,to_date('23.07.07','RR.MM.DD'));  /* Rejeitado (not null constraint)(quantidade) */
Insert into APLICACOESREALIZAR (IDCULTURA,IDPLANOANUAL,QUANTIDADE,DATAPREVISTA) values (NULL,'2','30',to_date('23.01.23','RR.MM.DD')); /* Rejeitado (not null constraint) */
Insert into APLICACOESREALIZAR (IDCULTURA,IDPLANOANUAL,QUANTIDADE,DATAPREVISTA) values ('1',NULL,'15',to_date('23.08.08','RR.MM.DD')); /* Rejeitado (not null constraint) */

--Table PRODUTOAGRICOLA
Insert into PRODUTOAGRICOLA (DESIGNACAO) values ('Batata'); /* Aprovado */
Insert into PRODUTOAGRICOLA (DESIGNACAO) values (NULL); /* Rejeitado (not null constraint) */
Insert into PRODUTOAGRICOLA (DESIGNACAO) values ('Cenoura'); /* Aprovado */
Insert into PRODUTOAGRICOLA (DESIGNACAO) values ('Feijao'); /* Aprovado */
Insert into PRODUTOAGRICOLA (DESIGNACAO) values ('Maça'); /* Aprovado */
Insert into PRODUTOAGRICOLA (DESIGNACAO) values ('Laranja'); /* Aprovado */

--Table CULTURAPRODUTO
Insert into CULTURAPRODUTO (IDCULTURA,IDPRODUTO) values ('1','1'); /* Aprovado */
Insert into CULTURAPRODUTO (IDCULTURA,IDPRODUTO) values ('1',NULL); /* Rejeitado (primary key constraint) */
Insert into CULTURAPRODUTO (IDCULTURA,IDPRODUTO) values (NULL,'1'); /* Rejeitado (primary key constraint) */

--Table GESTORAGRICOLACLIENTE
Insert into GESTORAGRICOLACLIENTE (IDGESTORAGRICOLA,IDCLIENTE) values ('9','1'); /* Aprovado */
Insert into GESTORAGRICOLACLIENTE (IDGESTORAGRICOLA,IDCLIENTE) values ('9',NULL); /* Rejeitado (primary key constraint) */
Insert into GESTORAGRICOLACLIENTE (IDGESTORAGRICOLA,IDCLIENTE) values (NULL,'1'); /* Rejeitado (primary key constraint) */

--Table GESTORDISTRIBUICAO
Insert into GESTORDISTRIBUICAO (IDGESTORDISTRIBUICAO) values ('14'); /* Aprovado */
Insert into GESTORDISTRIBUICAO (IDGESTORDISTRIBUICAO) values ('4'); /* Aprovado */ 
Insert into GESTORDISTRIBUICAO (IDGESTORDISTRIBUICAO) values (NULL); /* Rejeitado (primary key constraint) */

--Table HUBDISTRIBUICAO
Insert into HUBDISTRIBUICAO (NOMEHUBDISTRIBUICAO,IDGESTORDISTRIBUICAO) values ('Hub 1','14'); /* Aprovado */
Insert into HUBDISTRIBUICAO (NOMEHUBDISTRIBUICAO,IDGESTORDISTRIBUICAO) values (NULL,'4'); /* Rejeitado (not null constraint) */
Insert into HUBDISTRIBUICAO (NOMEHUBDISTRIBUICAO,IDGESTORDISTRIBUICAO) values ('Hub 2',NULL); /* Rejeitado (primary key constraint) */

--Table ENCOMENDACLIENTE
Insert into ENCOMENDACLIENTE (IDCLIENTE,IDMORADAENTREGA,DATAPEDIDO,DATAVENCIMENTO,DATAPAGAMENTO,DATAENTREGA,ESTADOPEDIDO,VALORTOTAL) values ('1','1',to_date('21.11.24','RR.MM.DD'),to_date('22.11.24','RR.MM.DD'),to_date('22.11.24','RR.MM.DD'),null,'paga','1000'); /* Aprovado */
Insert into ENCOMENDACLIENTE (IDCLIENTE,IDMORADAENTREGA,DATAPEDIDO,DATAVENCIMENTO,DATAPAGAMENTO,DATAENTREGA,ESTADOPEDIDO,VALORTOTAL) values ('1','1',to_date('21.11.24','RR.MM.DD'),to_date('22.11.24','RR.MM.DD'),to_date('22.11.24','RR.MM.DD'),to_date('22.11.24','RR.MM.DD'),'paga','1000'); /* Aprovado */
Insert into ENCOMENDACLIENTE (IDCLIENTE,IDMORADAENTREGA,DATAPEDIDO,DATAVENCIMENTO,DATAPAGAMENTO,DATAENTREGA,ESTADOPEDIDO,VALORTOTAL) values ('1','1',to_date('21.11.24','RR.MM.DD'),to_date('22.11.24','RR.MM.DD'),to_date('22.11.24','RR.MM.DD'),to_date('22.11.24','RR.MM.DD'),'paga','-1000'); /* Rejeitado (check constraint) */
Insert into ENCOMENDACLIENTE (IDCLIENTE,IDMORADAENTREGA,DATAPEDIDO,DATAVENCIMENTO,DATAPAGAMENTO,DATAENTREGA,ESTADOPEDIDO,VALORTOTAL) values ('1','1',to_date('21.11.24','RR.MM.DD'),to_date('22.11.24','RR.MM.DD'),to_date('22.11.24','RR.MM.DD'),to_date('22.11.24','RR.MM.DD'),null,null); /* Rejeitado (not null constraint) */
Insert into ENCOMENDACLIENTE (IDCLIENTE,IDMORADAENTREGA,DATAPEDIDO,DATAVENCIMENTO,DATAPAGAMENTO,DATAENTREGA,ESTADOPEDIDO,VALORTOTAL) values ('1','1',null,to_date('22.11.24','RR.MM.DD'),to_date('22.11.24','RR.MM.DD'),to_date('22.11.24','RR.MM.DD'),'paga','1000'); /* Rejeitado (not null constraint) */
Insert into ENCOMENDACLIENTE (IDCLIENTE,IDMORADAENTREGA,DATAPEDIDO,DATAVENCIMENTO,DATAPAGAMENTO,DATAENTREGA,ESTADOPEDIDO,VALORTOTAL) values ('1','1',to_date('21.11.24','RR.MM.DD'),null,to_date('22.11.24','RR.MM.DD'),to_date('22.11.24','RR.MM.DD'),'paga','1000'); /* Rejeitado (not null constraint) */
Insert into ENCOMENDACLIENTE (IDCLIENTE,IDMORADAENTREGA,DATAPEDIDO,DATAVENCIMENTO,DATAPAGAMENTO,DATAENTREGA,ESTADOPEDIDO,VALORTOTAL) values (null,'1',to_date('21.11.24','RR.MM.DD'),to_date('22.11.24','RR.MM.DD'),to_date('22.11.24','RR.MM.DD'),to_date('22.11.24','RR.MM.DD'),'paga','1000'); /* Rejeitado (not null constraint) */
Insert into ENCOMENDACLIENTE (IDCLIENTE,IDMORADAENTREGA,DATAPEDIDO,DATAVENCIMENTO,DATAPAGAMENTO,DATAENTREGA,ESTADOPEDIDO,VALORTOTAL) values ('1',null,to_date('21.11.24','RR.MM.DD'),to_date('22.11.24','RR.MM.DD'),to_date('22.11.24','RR.MM.DD'),to_date('22.11.24','RR.MM.DD'),'paga','1000'); /* Rejeitado (not null constraint) */
Insert into ENCOMENDACLIENTE (IDCLIENTE,IDMORADAENTREGA,DATAPEDIDO,DATAVENCIMENTO,DATAPAGAMENTO,DATAENTREGA,ESTADOPEDIDO,VALORTOTAL) values ('1','1',to_date('21.11.24','RR.MM.DD'),to_date('20.11.24','RR.MM.DD'),to_date('22.11.24','RR.MM.DD'),to_date('22.11.24','RR.MM.DD'),'paga','1000'); /* Rejeitado (check constraint) */
Insert into ENCOMENDACLIENTE (IDCLIENTE,IDMORADAENTREGA,DATAPEDIDO,DATAVENCIMENTO,DATAPAGAMENTO,DATAENTREGA,ESTADOPEDIDO,VALORTOTAL) values ('1','1',to_date('21.11.24','RR.MM.DD'),to_date('22.11.24','RR.MM.DD'),to_date('20.11.24','RR.MM.DD'),to_date('22.11.24','RR.MM.DD'),'paga','1000'); /* Rejeitado (check constraint) */
Insert into ENCOMENDACLIENTE (IDCLIENTE,IDMORADAENTREGA,DATAPEDIDO,DATAVENCIMENTO,DATAPAGAMENTO,DATAENTREGA,ESTADOPEDIDO,VALORTOTAL) values ('1','1',to_date('21.11.24','RR.MM.DD'),to_date('22.11.24','RR.MM.DD'),to_date('22.11.24','RR.MM.DD'),to_date('20.11.24','RR.MM.DD'),'paga','1000'); /* Rejeitado (check constraint) */
Insert into ENCOMENDACLIENTE (IDCLIENTE,IDMORADAENTREGA,DATAPEDIDO,DATAVENCIMENTO,DATAPAGAMENTO,DATAENTREGA,ESTADOPEDIDO,VALORTOTAL) values ('1','1',to_date('21.11.24','RR.MM.DD'),to_date('22.11.24','RR.MM.DD'),to_date('22.11.24','RR.MM.DD'),to_date('22.11.24','RR.MM.DD'),'ERROR','1000'); /* Rejeitado (check constraint) */


--Table ENCOMENDAPRODUTO
Insert into ENCOMENDAPRODUTO (IDPEDIDO,IDPRODUTO) values ('1','1'); /* Aprovado */
Insert into ENCOMENDAPRODUTO (IDPEDIDO,IDPRODUTO) values ('1',NULL); /* Rejeitado (primary key constraint) */
Insert into ENCOMENDAPRODUTO (IDPEDIDO,IDPRODUTO) values (NULL,'1'); /* Rejeitado (primary key constraint) */
Insert into ENCOMENDAPRODUTO (IDPEDIDO,IDPRODUTO) values (NULL,NULL); /* Rejeitado (primary key constraint) */


--Table INCIDENTE
Insert into INCIDENTE (IDCLIENTE,VALORDIVIDA,DATASANADO,DATAOCORRENCIA) values ('1','1000',to_date('22.11.24','RR.MM.DD'),to_date('22.10.20','RR.MM.DD')); /* Aprovado */
Insert into INCIDENTE (IDCLIENTE,VALORDIVIDA,DATASANADO,DATAOCORRENCIA) values (NULL,'1350',to_date('21.08.10','RR.MM.DD'),to_date('21.06.17','RR.MM.DD')); /* Rejeitado (not null constraint) */
Insert into INCIDENTE (IDCLIENTE,VALORDIVIDA,DATASANADO,DATAOCORRENCIA) values ('1',NULL,to_date('21.07.16','RR.MM.DD'),to_date('21.01.13','RR.MM.DD')); /* Rejeitado (not null constraint) */
Insert into INCIDENTE (IDCLIENTE,VALORDIVIDA,DATASANADO,DATAOCORRENCIA) values ('1','876',NULL,to_date('22.09.21','RR.MM.DD')); /* Aprovado(dataSanado pode ser NULL(não ter sido paga a dívida)) */
Insert into INCIDENTE (IDCLIENTE,VALORDIVIDA,DATASANADO,DATAOCORRENCIA) values ('1','899',to_date('22.09.22','RR.MM.DD'),NULL); /* Rejeitado (not null constraint) */
Insert into INCIDENTE (IDCLIENTE,VALORDIVIDA,DATASANADO,DATAOCORRENCIA) values ('1','-3',to_date('21.09.23','RR.MM.DD'),to_date('20.07.14','RR.MM.DD')); /* Rejeitado (check constraint) */

--Table CONDUTOR
Insert into CONDUTOR (IDCONDUTOR) values ('15'); /* Aprovado */
Insert into CONDUTOR (IDCONDUTOR) values (NULL); /* Rejeitado (primary key constraint) */

--Table TRANSPORTE
Insert into TRANSPORTE (IDCONDUTOR,IDPRODUTO,IDHUBDISTRIBUICAO) values ('15','1','1'); /* Aprovado */
Insert into TRANSPORTE (IDCONDUTOR,IDPRODUTO,IDHUBDISTRIBUICAO) values (NULL,'2','1'); /* Rejeitado (not null constraint) */
Insert into TRANSPORTE (IDCONDUTOR,IDPRODUTO,IDHUBDISTRIBUICAO) values ('15',NULL,'1'); /* Rejeitado (not null constraint) */
Insert into TRANSPORTE (IDCONDUTOR,IDPRODUTO,IDHUBDISTRIBUICAO) values ('15','4',NULL); /* Rejeitado (not null constraint) */

--Table CADERNOCAMPO
Insert into CADERNOCAMPO (IDGESTORAGRICOLA) values ('9'); /* Aprovado */
Insert into CADERNOCAMPO (IDGESTORAGRICOLA) values (NULL); /* Rejeitado (primary key constraint) */

--Table REGISTO
Insert into REGISTO (DATAREGISTO,PARCELA,QUANTIDADE,IDCADERNOCAMPO) values (to_date('22.11.24','RR.MM.DD'),'1','10','1'); /* Aprovado */
Insert into REGISTO (DATAREGISTO,PARCELA,QUANTIDADE,IDCADERNOCAMPO) values (to_date('22.11.23','RR.MM.DD'),'2','-5','1'); /* Rejeitado (check constraint) */
Insert into REGISTO (DATAREGISTO,PARCELA,QUANTIDADE,IDCADERNOCAMPO) values (to_date('22.11.21','RR.MM.DD'),'-3','6','1'); /* Rejeitado (check constraint) */
Insert into REGISTO (DATAREGISTO,PARCELA,QUANTIDADE,IDCADERNOCAMPO) values (to_date('22.11.24','RR.MM.DD'),'4','7',NULL); /* Rejeitado (not null constraint) */
Insert into REGISTO (DATAREGISTO,PARCELA,QUANTIDADE,IDCADERNOCAMPO) values (to_date('22.11.24','RR.MM.DD'),'5',NULL,'1'); /* Rejeitado (not null constraint) */
Insert into REGISTO (DATAREGISTO,PARCELA,QUANTIDADE,IDCADERNOCAMPO) values (to_date('22.11.23','RR.MM.DD'),NULL,'10','1'); /* Rejeitado (not null constraint) */
Insert into REGISTO (DATAREGISTO,PARCELA,QUANTIDADE,IDCADERNOCAMPO) values (NULL,'6','10','1'); /* Rejeitado (not null constraint) */

--Table REGISTOCOLHEITA
Insert into REGISTOCOLHEITA (IDREGISTO,PRODUTOCOLHEITA) values ('1','Batatas'); /* Aprovado */
Insert into REGISTOCOLHEITA (IDREGISTO,PRODUTOCOLHEITA) values ('1',NULL); /* Rejeitado (not null constraint) */
Insert into REGISTOCOLHEITA (IDREGISTO,PRODUTOCOLHEITA) values (NULL,'Laranjas'); /* Rejeitado (primary key constraint) */
Insert into REGISTOCOLHEITA (IDREGISTO,PRODUTOCOLHEITA) values (NULL,NULL); /* Rejeitado (primary key constraint) */

--Table REGISTOFERTELIZACAO
Insert into REGISTOFERTELIZACAO (IDREGISTO,TIPOFERTELIZACAO) values ('1','Natural'); /* Aprovado */
Insert into REGISTOFERTELIZACAO (IDREGISTO,TIPOFERTELIZACAO) values (NULL,'Orgânico'); /* Rejeitado (primary key constraint) */
Insert into REGISTOFERTELIZACAO (IDREGISTO,TIPOFERTELIZACAO) values ('1',NULL); /* Rejeitado (not null constraint) */

--Table REGISTOREGA
Insert into REGISTOREGA (IDREGISTO,DESCRICAO) values ('1','Rega durou cerca de 8 minutos'); /* Aprovado */
Insert into REGISTOREGA (IDREGISTO,DESCRICAO) values ('1',NULL); /* Rejeitado (not null constraint) */
Insert into REGISTOREGA (IDREGISTO,DESCRICAO) values (NULL,'Rega durou cerca de 7 minutos'); /* Rejeitado (primary key constraint) */
Insert into REGISTOREGA (IDREGISTO,DESCRICAO) values (NULL,NULL); /* Rejeitado (not null constraint) */

--Table SENSOR
Insert into SENSOR (TIPOSENSOR) values ('pluviosidade'); /* Aprovado */
Insert into SENSOR (TIPOSENSOR) values (NULL); /* Rejeitado (not null constraint) */

--Table ESTACAOMETEOROLOGICA
Insert into ESTACAOMETEOROLOGICA (NOMEESTACAOMETEOROLOGICA) values ('Primavera'); /* Aprovado */
Insert into ESTACAOMETEOROLOGICA (NOMEESTACAOMETEOROLOGICA) values (NULL); /* Rejeitado (not null constraint) */ 

--Table RESUMOMETEOROLOGICO
Insert into RESUMOMETEOROLOGICO (RESUMOSENSORES,RESUMOSOLO,DATARESUMO,IDCADERNOCAMPO,IDESTACAOMETEOROLOGICO) values ('Todos os sensores executaram bem as medicoes','Problemas com o Solo',to_date('22.12.16','RR.MM.DD'),'1','1'); /* Aprovado */
Insert into RESUMOMETEOROLOGICO (RESUMOSENSORES,RESUMOSOLO,DATARESUMO,IDCADERNOCAMPO,IDESTACAOMETEOROLOGICO) values ('Problema com o sensor de temperatura','Solo muito bom durante o dia',to_date('22.07.22','RR.MM.DD'),NULL,'1'); /* Rejeitado (not null constraint) */
Insert into RESUMOMETEOROLOGICO (RESUMOSENSORES,RESUMOSOLO,DATARESUMO,IDCADERNOCAMPO,IDESTACAOMETEOROLOGICO) values ('Problema com o sensor de vento','Solo muito bom durante a manhã',to_date('22.09.29','RR.MM.DD'),'1',NULL); /* Rejeitado (not null constraint) */
Insert into RESUMOMETEOROLOGICO (RESUMOSENSORES,RESUMOSOLO,DATARESUMO,IDCADERNOCAMPO,IDESTACAOMETEOROLOGICO) values ('Problema com o sensor da humidade','Solo muito bom durante a noite',NULL,'1','1'); /* Rejeitado (not null constraint) */
Insert into RESUMOMETEOROLOGICO (RESUMOSENSORES,RESUMOSOLO,DATARESUMO,IDCADERNOCAMPO,IDESTACAOMETEOROLOGICO) values ('Problema com o sensor de pluviosidade',NULL,to_date('22.12.16','RR.MM.DD'),'1','1'); /* Rejeitado (not null constraint) */
Insert into RESUMOMETEOROLOGICO (RESUMOSENSORES,RESUMOSOLO,DATARESUMO,IDCADERNOCAMPO,IDESTACAOMETEOROLOGICO) values (NULL,'Problemas com o Solo',to_date('22.12.16','RR.MM.DD'),'1','1'); /* Rejeitado (not null constraint) */

--Table RESUMOMETEOROLOGICOSENSOR
Insert into RESUMOMETEOROLOGICOSENSOR (IDRESUMOMETEOROLOGICO,IDSENSOR,VALORMEDIDO) values ('1','1','7'); /* Aprovado */
Insert into RESUMOMETEOROLOGICOSENSOR (IDRESUMOMETEOROLOGICO,IDSENSOR,VALORMEDIDO) values ('2',NULL,'-100'); /* Rejeitado (not null constraint) */
Insert into RESUMOMETEOROLOGICOSENSOR (IDRESUMOMETEOROLOGICO,IDSENSOR,VALORMEDIDO) values (NULL,'4','500'); /* Rejeitado (not null constraint) */
Insert into RESUMOMETEOROLOGICOSENSOR (IDRESUMOMETEOROLOGICO,IDSENSOR,VALORMEDIDO) values ('1','1',NULL); /* Rejeitado (not null constraint) */

rollback;

-- Reset auto-increment id's

alter table MORADA
modify idMorada generated always as identity start with 1;

alter table PESSOA
modify idPessoa generated always as identity start with 1;

alter table SETOR
modify idSetor generated always as identity start with 1;

alter table CULTURA
modify idCultura generated always as identity start with 1;

alter table SAFRA
modify idSafra generated always as identity start with 1;

alter table FATORPRODUCAO
modify idFatorProducao generated always as identity start with 1;

alter table SISTEMAREGA
modify idSistemaRega generated always as identity start with 1;

alter table PLANOREGA
modify idPlanoRega generated always as identity start with 1;

alter table PLANOANUAL
modify idPlanoAnual generated always as identity start with 1;

alter table SETOR
modify idSetor generated always as identity start with 1;

alter table HUBDISTRIBUICAO
modify idHubDistribuicao generated always as identity start with 1;

alter table ENCOMENDACLIENTE
modify idPedido generated always as identity start with 1;

alter table TRANSPORTE
modify idTransporte generated always as identity start with 1;

alter table FATORPRODUCAO
modify idFatorProducao generated always as identity start with 1;

alter table CADERNOCAMPO
modify idCadernoCampo generated always as identity start with 1;

alter table RESUMOMETEOROLOGICO
modify idResumoMeteorologico generated always as identity start with 1;

alter table ESTACAOMETEOROLOGICA
modify idEstacaoMeteorologico generated always as identity start with 1;

alter table SENSOR
modify idSensor generated always as identity start with 1;

alter table REGISTO
modify idRegisto generated always as identity start with 1;

alter table INCIDENTE
modify idIncidente generated always as identity start with 1;

alter table PRODUTOAGRICOLA
modify idProduto generated always as identity start with 1;

alter table FICHATECNICA
modify idFichaTecnica generated always as identity start with 1;

alter table ELEMENTO
modify idElemento generated always as identity start with 1;



