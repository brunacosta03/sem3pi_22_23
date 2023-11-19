CREATE OR REPLACE TRIGGER trg_RegistoOperacoesAgricolas
AFTER INSERT OR UPDATE OR DELETE on OperacoesAgricolas
FOR EACH ROW
declare
  id_operacao OperacoesAgricolas.IDOPERACAO%Type;
  id_setor OperacoesAgricolas.IDSETOR%Type;
  tipo_alteracao VARCHAR(10);
BEGIN
    id_operacao := :new.IDOPERACAO;
    
    
    IF INSERTING THEN
        tipo_alteracao := 'insert';
        
        id_setor := :new.IDSETOR;
    ELSIF UPDATING THEN
        tipo_alteracao := 'update';
        
        id_setor := :new.IDSETOR;
    ELSIF DELETING THEN
        tipo_alteracao := 'delete';
        
        id_setor := :old.IDSETOR;
    END IF;
    
      INSERT INTO RegistoOperacoesAgricolas(IDSETOR, UTILIZADOR, DATAHORAOPERACAO, TIPOALTERACAO) 
      VALUES (id_setor, user, SYSDATE, tipo_alteracao);
END;
/

--Create Views
CREATE VIEW allOperacoesAgricolas AS
SELECT * FROM RegistoOperacoesAgricolas
ORDER BY dataHoraOperacao ASC;

CREATE VIEW OperacoesAgricolaInsert AS
SELECT * FROM RegistoOperacoesAgricolas
WHERE tipoAlteracao='insert'
ORDER BY dataHoraOperacao ASC;

CREATE VIEW OperacoesAgricolaUpdate AS
SELECT * FROM RegistoOperacoesAgricolas
WHERE tipoAlteracao='update'
ORDER BY dataHoraOperacao ASC;

CREATE VIEW OperacoesAgricolaDelete AS
SELECT * FROM RegistoOperacoesAgricolas
WHERE tipoAlteracao='delete'
ORDER BY dataHoraOperacao ASC;

--Tables RegistoOperacoesAgricolas
DECLARE
    id_operacao_agricola_inserted OPERACOESAGRICOLAS.IDOPERACAO%TYPE;
BEGIN
    Insert into OPERACOESAGRICOLAS (IDSETOR,TIPOOPERACAO,DATAREALIZACAO,ESTADOOPERACAO) values ('8','irrigação',to_date('22.02.27','RR.MM.DD'),'agendada') returning IDOPERACAO into id_operacao_agricola_inserted;
    UPDATE OPERACOESAGRICOLAS SET ESTADOOPERACAO = 'cancelada' WHERE IDOPERACAO = id_operacao_agricola_inserted;
    DELETE OPERACOESAGRICOLAS WHERE IDOPERACAO = id_operacao_agricola_inserted;
END;
/

DECLARE
    id_operacao_agricola_inserted OPERACOESAGRICOLAS.IDOPERACAO%TYPE;
BEGIN
    Insert into OPERACOESAGRICOLAS (IDSETOR,TIPOOPERACAO,DATAREALIZACAO,ESTADOOPERACAO) values ('9','irrigação',to_date('20.09.27','RR.MM.DD'),'cancelada') returning IDOPERACAO into id_operacao_agricola_inserted;
    UPDATE OPERACOESAGRICOLAS SET ESTADOOPERACAO = 'agendada' WHERE IDOPERACAO = id_operacao_agricola_inserted;
    DELETE OPERACOESAGRICOLAS WHERE IDOPERACAO = id_operacao_agricola_inserted;
END;
/

DECLARE
    id_operacao_agricola_inserted OPERACOESAGRICOLAS.IDOPERACAO%TYPE;
BEGIN
    Insert into OPERACOESAGRICOLAS (IDSETOR,TIPOOPERACAO,DATAREALIZACAO,ESTADOOPERACAO) values ('10','irrigação',to_date('21.01.23','RR.MM.DD'),'cancelada') returning IDOPERACAO into id_operacao_agricola_inserted;
    UPDATE OPERACOESAGRICOLAS SET ESTADOOPERACAO = 'agendada' WHERE IDOPERACAO = id_operacao_agricola_inserted;
    DELETE OPERACOESAGRICOLAS WHERE IDOPERACAO = id_operacao_agricola_inserted;
END;
/

--Table REGISTOOPERACOESAGRICOLAS
SELECT * FROM allOperacoesAgricolas;
SELECT COUNT(*) AS "Numero Operacoes" FROM allOperacoesAgricolas;

SELECT * FROM OperacoesAgricolaInsert;
SELECT COUNT(*)  AS "Numero Inserts" FROM OperacoesAgricolaInsert;

SELECT * FROM OperacoesAgricolaUpdate;
SELECT COUNT(*)  AS "Numero Updates" FROM OperacoesAgricolaUpdate;

SELECT * FROM OperacoesAgricolaDelete;
SELECT COUNT(*)  AS "Numero Deletes" FROM OperacoesAgricolaDelete;