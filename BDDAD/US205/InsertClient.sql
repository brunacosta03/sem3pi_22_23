set serveroutput on;
set verify off;


/* Function to insert Address */
CREATE OR REPLACE FUNCTION insert_morada (search_endereco IN Morada.endereco%TYPE, 
                                          search_codigoPostal IN Morada.codigoPostal%TYPE)

RETURN Morada.idMorada%TYPE -- tipo de retorno vai ser o id da morada

IS
    id_morada Morada.idMorada%TYPE;

BEGIN 
    SELECT idMorada 
    INTO id_morada 
    FROM Morada m
    WHERE m.endereco = search_endereco AND m.codigoPostal = search_codigoPostal;
    
    RETURN id_morada;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        INSERT INTO Morada (endereco, codigoPostal) VALUES (search_endereco, search_codigoPostal);
        dbms_output.put_line('MORADA INSERIDA!');
        SELECT idMorada INTO id_morada FROM Morada m WHERE m.endereco = search_endereco AND m.codigoPostal = search_codigoPostal;
        RETURN id_morada;
END;
/



/* Function to insert Client */
CREATE OR REPLACE FUNCTION insert_cliente ( search_idCliente IN Cliente.idCliente%TYPE, 
                                            search_nivel IN Cliente.nivel%TYPE, 
                                            search_plafond IN Cliente.plafond%TYPE, 
                                            search_idMorada IN Cliente.idMorada%TYPE, 
                                            search_idMoradaEntrega IN Cliente.idMoradaEntrega%TYPE)

RETURN Cliente.idCliente%TYPE -- tipo de retorno vai ser o id do cliente

IS
    id_cliente Cliente.idCliente%TYPE;

BEGIN

    SELECT idCliente 
    INTO id_cliente 
    FROM Cliente c
    WHERE c.idCliente = search_idCliente;


    RAISE_APPLICATION_ERROR(-20000, 'Cliente já existe');

    RETURN NULL;
EXCEPTION
    WHEN NO_DATA_FOUND THEN

        INSERT INTO Cliente (idCliente, nivel, plafond, idMorada, idMoradaEntrega)
        VALUES (search_idCliente, search_nivel, search_plafond, search_idMorada, search_idMoradaEntrega);

        SELECT idCliente 
        INTO id_cliente 
        FROM Cliente c
        WHERE c.idCliente = search_idCliente;

        RETURN id_cliente;
END;
/

/* Function to insert Person */
CREATE OR REPLACE FUNCTION insert_pessoa ( search_nome IN Pessoa.nome%TYPE, 
                                           search_nif IN Pessoa.nif%TYPE,
                                             search_email IN Pessoa.email%TYPE)

RETURN Pessoa.idPessoa%TYPE -- tipo de retorno vai ser o id da pessoa

IS
    id_pessoa Pessoa.idPessoa%TYPE;

BEGIN

    SELECT idPessoa 
    INTO id_pessoa 
    FROM Pessoa p
    WHERE p.nif = search_nif
    AND p.email = search_email
    AND p.nome = search_nome;

    RETURN id_pessoa;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        checkNifUnique(search_nif);
        checkEmailUnique(search_email);

        INSERT INTO Pessoa (nome, nif, email)
        VALUES (search_nome, search_nif, search_email);
        dbms_output.put_line('PESSOA INSERIDA!');

        SELECT idPessoa 
        INTO id_pessoa 
        FROM Pessoa p
        WHERE p.nif = search_nif
        AND p.email = search_email
        AND p.nome = search_nome;

        RETURN id_pessoa;
END;
/

/* Start Checkers */
-- checks name of client
CREATE OR REPLACE PROCEDURE checkNome (nome IN Pessoa.nome%TYPE)

IS

BEGIN
    IF (nome IS NULL) THEN
        RAISE_APPLICATION_ERROR(-20000, 'Nome não pode ser nulo!');
    END IF;
END;
/

-- checks NIF of client
CREATE OR REPLACE PROCEDURE checkNif (nif IN Pessoa.nif%TYPE)

IS

BEGIN
    IF (nif IS NULL) THEN
        RAISE_APPLICATION_ERROR(-20000, 'NIF não pode ser nulo!');
    ELSIF NOT (REGEXP_LIKE(nif, '[0-9]{9}')) THEN
        RAISE_APPLICATION_ERROR(-20000, 'NIF inválido! Deve ter 9 dígitos.');
    END IF;
END;
/

-- checks uniqueness of NIF of client
-- will be used if there are no clients but to verify if the NIF is used by another person
CREATE OR REPLACE PROCEDURE checkNifUnique (search_nif IN Pessoa.nif%TYPE)

IS
    nif_cliente Pessoa.nif%TYPE;

BEGIN
    SELECT nif INTO nif_cliente FROM Pessoa p WHERE p.nif = search_nif;

    RAISE_APPLICATION_ERROR(-20000, 'Já existe um cliente com esse NIF!');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('NIF Válido!');
END;
/

-- checks uniqueness of email of client
-- will be used if there are no clients but to verify if the email is used by another person
CREATE OR REPLACE PROCEDURE checkEmailUnique (search_email IN Pessoa.email%TYPE)

IS
    email_cliente Pessoa.email%TYPE;

BEGIN
    SELECT email INTO email_cliente FROM Pessoa p WHERE p.email = search_email;

    RAISE_APPLICATION_ERROR(-20000, 'Já existe um cliente com esse email!');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('Email Válido!');
END;
/

-- checks email of client
CREATE OR REPLACE PROCEDURE checkEmail (email IN Pessoa.email%TYPE)

IS

BEGIN
    IF (email IS NULL) THEN
        RAISE_APPLICATION_ERROR(-20000, 'Email não pode ser nulo!');
    ELSIF NOT (REGEXP_LIKE(email, '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}')) THEN
        RAISE_APPLICATION_ERROR(-20000, 'Email inválido! Deve conter um @ e um .');
    END IF;
END;
/

-- checks plafond of client
CREATE OR REPLACE PROCEDURE checkPlafond (plafond IN Cliente.plafond%TYPE)

IS

BEGIN
    IF (plafond IS NULL) THEN
        RAISE_APPLICATION_ERROR(-20000, 'Plafond não pode ser nulo!');
    ELSIF (plafond < 0) THEN
        RAISE_APPLICATION_ERROR(-20000, 'Plafond inválido! Deve ser maior que 0.');
    END IF;
END;
/

-- checks postal code of client
CREATE OR REPLACE PROCEDURE checkCodigoPostal (codigo_postal IN Morada.codigoPostal%TYPE)

IS

BEGIN
    IF (codigo_postal IS NULL) THEN
        RAISE_APPLICATION_ERROR(-20000, 'Código Postal não pode ser nulo!');
    ELSIF NOT REGEXP_LIKE(codigo_postal, '[0-9]{4}-[0-9]{3}') THEN
        RAISE_APPLICATION_ERROR(-20000, 'Código Postal inválido! Deve ter o formato XXXX-XXX.');
    END IF;
END;
/

-- checks address of client
CREATE OR REPLACE PROCEDURE checkEndereco (endereco IN Morada.endereco%TYPE)

IS

BEGIN
    IF (endereco IS NULL) THEN
        RAISE_APPLICATION_ERROR(-20000, 'Endereço não pode ser nulo!');
    END IF;
END;
/
/* End Checkers */

/* Function to Instantiate a Client that returns its ID and prints it */
CREATE OR REPLACE FUNCTION create_client(cliente_nome Pessoa.nome%TYPE, 
                                        cliente_nif Pessoa.nif%TYPE,
                                        cliente_email Pessoa.email%TYPE,
                                        cliente_plafond Cliente.plafond%TYPE,
                                        cliente_endereco Morada.endereco%TYPE,
                                        cliente_codigo_postal Morada.codigoPostal%TYPE,
                                        cliente_endereco_entrega Morada.endereco%TYPE,
                                        cliente_codigo_postal_entrega Morada.codigoPostal%TYPE)

RETURN Cliente.idCliente%TYPE -- tipo de retorno vai ser o id do cliente

IS
    id_cliente Cliente.idCliente%TYPE;
    id_morada Morada.idMorada%TYPE;
    id_morada_entrega Morada.idMorada%TYPE;
    cliente_nivel Cliente.nivel%TYPE;
    id_pessoa Pessoa.idPessoa%TYPE;

BEGIN 
    cliente_nivel := 'X';

    checkNome(cliente_nome);
    checkNif(cliente_nif);
    checkEmail(cliente_email);
    checkPlafond(cliente_plafond);
    checkEndereco(cliente_endereco);
    checkCodigoPostal(cliente_codigo_postal);
    checkEndereco(cliente_endereco_entrega);
    checkCodigoPostal(cliente_codigo_postal_entrega);

    -- id morada
    id_morada := insert_morada (cliente_endereco, cliente_codigo_postal);
    -- id morada entrega
    id_morada_entrega := insert_morada (cliente_endereco_entrega, cliente_codigo_postal_entrega);

    -- id pessoa
    id_pessoa := insert_pessoa (cliente_nome, cliente_nif, cliente_email);

    -- id cliente
    id_cliente := insert_cliente (id_pessoa, cliente_nivel, cliente_plafond, id_morada, id_morada_entrega);

    dbms_output.put_line('Client inserted with id: ' || id_cliente);

    RETURN id_cliente;
EXCEPTION
    WHEN others THEN
        dbms_output.put_line(SQLERRM);
        RETURN NULL;
END;
/