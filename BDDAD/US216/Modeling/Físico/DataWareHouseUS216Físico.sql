/* Fact table */

CREATE TABLE Stats (
    vendas float(10) constraint nn_vendas_Stats NOT NULL,
    producao float(10) constraint nn_producao_Stats NOT NULL, 
    idTempo number(10) constraint nn_idTempo_Stats NOT NULL, 
    idCliente number(10) constraint nn_idCliente_Stats NOT NULL, 
    idProduto number(10) constraint nn_idProduto_Stats NOT NULL, 
    idSetor number(10) constraint nn_idSetor_Stats NOT NULL, 
    codigoHub number(10) constraint nn_codigoHub_Stats NOT NULL,
    constraint pk_Stats PRIMARY KEY (idTempo, idCliente, idProduto, idSetor, codigoHub)
);

/* Dimension Tables */

CREATE TABLE Tempo (
    idTempo number(10),
    ano number(10) constraint nn_ano_Tempo NOT NULL, 
    mes number(10) constraint nn_mes_Tempo NOT NULL, 
    constraint pk_Tempo PRIMARY KEY (idTempo),
    constraint ck_mes_Tempo check (mes in (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12)),
    constraint ck_ano_Tempo check (ano >= 1900 and ano <= 2100)
);

CREATE TABLE Setor (
    idSetor number(10),
    designacao varchar(300) constraint nn_designacao_Setor NOT NULL, 
    constraint pk_Setor PRIMARY KEY (idSetor)
);

CREATE TABLE Cliente (
    idCliente number(10),
    nome varchar(200) constraint nn_nome_Cliente NOT NULL,
    nif char(9) constraint nnu_nif_Cliente NOT NULL UNIQUE,
    email varchar(150) constraint nnu_email_Cliente NOT NULL UNIQUE, 
    constraint pk_Cliente PRIMARY KEY (idCliente),
    constraint ck_nif_Cliente CHECK (REGEXP_LIKE(nif, '[0-9]{9}', 'i')),
    constraint ck_email_Cliente CHECK (email LIKE '%@%.%')
);

CREATE TABLE Cultura (
    idCultura number(10), 
    tipoCultura char(10) constraint nn_tipoCultura_Cultura NOT NULL, 
    designacao varchar(300) constraint nn_designacao_Cultura NOT NULL, 
    idSetor number(10) constraint nn_idSetor_Cultura NOT NULL, 
    constraint pk_Cultura PRIMARY KEY (idCultura)
);

CREATE TABLE ProdutoAgricola (
    idProduto number(10), 
    designacao varchar(150) constraint nn_designacao_ProdutoAgricola NOT NULL, 
    constraint pk_ProdutoAgricola PRIMARY KEY (idProduto)
);

CREATE TABLE CulturaProduto (
    idCultura number(10) constraint nn_idCultura_CulturaProduto NOT NULL, 
    idProduto number(10) constraint nn_idProduto_CulturaProduto NOT NULL, 
    constraint pk_CulturaProduto PRIMARY KEY (idCultura, idProduto)
);

CREATE TABLE Hub (
    codigoHub varchar(20) constraint nn_codigoHub_Hub NOT NULL, 
    latitude    number(6, 4) constraint nn_latitude_Hub NOT NULL,  
    longitude   number(7, 4) constraint nn_longitude_Hub NOT NULL,
    codigoEP    varchar(20) constraint nn_codigoEP_Hub NOT NULL,  
    tipoHub char(1),
    constraint pk_Hub PRIMARY KEY (idHubDistribuicao),
    constraint ck_tipoHub check (lower(tipoHub) in ('e', 'p')),
    constraint ck_latitude_Hub check (latitude >= -90 and latitude <= 90),
    constraint ck_longitude_Hub check (longitude >= -180 and latitude <= 180)
);

/* Foreign key constraints */

ALTER TABLE CulturaProduto 
ADD CONSTRAINT fk_CulturaProduto_ProdutoAgricola FOREIGN KEY (idProduto) REFERENCES ProdutoAgricola (idProduto);

ALTER TABLE CulturaProduto 
ADD CONSTRAINT fk_CulturaProduto_Cultura FOREIGN KEY (idCultura) REFERENCES Cultura (idCultura);

ALTER TABLE Stats 
ADD CONSTRAINT fk_Stats_Tempo FOREIGN KEY (idTempo) REFERENCES Tempo (idTempo);

ALTER TABLE Stats 
ADD CONSTRAINT fk_Stats_Cliente FOREIGN KEY (idCliente) REFERENCES Cliente (idCliente);

ALTER TABLE Stats 
ADD CONSTRAINT fk_Stats_ProdutoAgricola FOREIGN KEY (idProduto) REFERENCES ProdutoAgricola (idProduto);

ALTER TABLE Stats 
ADD CONSTRAINT fk_Stats_Setor FOREIGN KEY (idSetor) REFERENCES Setor (idSetor);

ALTER TABLE Stats 
ADD CONSTRAINT fk_Stats_Hub FOREIGN KEY (codigoHub) REFERENCES Hub (codigoHub);

ALTER TABLE Cultura 
ADD CONSTRAINT fk_Cultura_Setor FOREIGN KEY (idSetor) REFERENCES Setor (idSetor);
