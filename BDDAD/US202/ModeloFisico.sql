CREATE TABLE Setor (
  idSetor          integer GENERATED AS IDENTITY START WITH 1 INCREMENT BY 1, 
  designacao     varchar(300) constraint nn_designacao_Setor NOT NULL, 
  area             float constraint nn_area_Setor NOT NULL, 
  idGestorAgricola integer constraint nn_idGestorAgricola_Setor NOT NULL, 
  constraint pk_Setor PRIMARY KEY (idSetor),
  constraint ck_area_Setor CHECK (area > 0)
);

CREATE TABLE GestorAgricola (
  idGestorAgricola   integer constraint nn_idGestorAgricola_GestorAgricola NOT NULL,  
  constraint pk_GestorAgricola PRIMARY KEY (idGestorAgricola)
);

CREATE TABLE SistemaRega (
  idSistemaRega    integer GENERATED AS IDENTITY START WITH 1 INCREMENT BY 1, 
  tipoDistribuicao varchar(50) constraint nn_tipoDistribuicao_SistemaRega NOT NULL, 
  tipoRega         varchar(50) constraint nn_tipoRega_SistemaRega NOT NULL,  
  idGestorAgricola integer constraint nn_idGestorAgricola_SistemaRega NOT NULL, 
  constraint pk_SistemaRega PRIMARY KEY (idSistemaRega),
  constraint ck_tipoDistribuicao_SistemaRega CHECK (lower(tipoDistribuicao) IN ('aspersao', 'gotejamento', 'pulverizacao')),
  constraint ck_tipoRega_SistemaRega CHECK (lower(tipoRega) IN ('gravidade', 'bombeada'))
);

CREATE TABLE Controlador (
  idSistemaRega integer constraint nn_idSistemaRega_Controlador NOT NULL, 
  idPlanoRega   integer constraint nn_idPlanoRega_Controlador NOT NULL, 
  constraint pk_Controlador PRIMARY KEY (idSistemaRega)
);

CREATE TABLE PlanoRega (
  idPlanoRega  integer GENERATED AS IDENTITY START WITH 1 INCREMENT BY 1, 
  parcelasRega integer constraint nn_parcelasRega_PlanoRega NOT NULL, 
  tempoRega    integer constraint nn_tempoRega_PlanoRega NOT NULL, 
  periodicidade  varchar(10) NOT NULL, 
  constraint pk_PlanoRega PRIMARY KEY (idPlanoRega),
  constraint ck_periodicidade_PlanoRega CHECK (lower(periodicidade) IN ('diario', 'semanal', 'mensal', 'anual')),
  constraint ck_parcelasRega_PlanoRega CHECK (parcelasRega > 0),
  constraint ck_tempoRega_PlanoRega CHECK (tempoRega > 0)
);

CREATE TABLE Cultura (
  idCultura   integer GENERATED AS IDENTITY START WITH 1 INCREMENT BY 1,
  nomeCultura varchar(300) constraint nn_nomeCultura_Cultura NOT NULL,      
  tipoCultura char(10) NOT NULL, 
  designacao  varchar(300) constraint nn_designacao_Cultura NOT NULL,
  idSetor     integer constraint nn_idSetor_Cultura NOT NULL,  
  constraint pk_Cultura PRIMARY KEY (idCultura),
  constraint ck_tipoCultura_Cultura check (lower(tipoCultura) in ('permanente','temporario'))
);

CREATE TABLE Condutor (
  idCondutor    integer constraint nn_idCondutor_Condutor NOT NULL,
  constraint pk_Condutor PRIMARY KEY (idCondutor)
);

CREATE TABLE Hub (
  codigoHub   varchar(20) constraint nn_codigoHub_Hub NOT NULL,
  latitude    number(6, 4) constraint nn_latitude_Hub NOT NULL,  
  longitude   number(7, 4) constraint nn_longitude_Hub NOT NULL,
  codigoEP    varchar(20) constraint nn_codigoEP_Hub NOT NULL,  
  constraint pk_Hub PRIMARY KEY (codigoHub),
  constraint ck_latitude_Hub check (latitude >= -90 and latitude <= 90),
  constraint ck_longitude_Hub check (longitude >= -180 and latitude <= 180)
);

CREATE TABLE Input_Hub (
  input_string   varchar(25)
);

CREATE TABLE Cliente (
  idCliente       integer constraint nn_idCliente_Cliente NOT NULL, 
  nivel           char(1) constraint nn_nivel_Cliente NOT NULL, 
  plafond         float constraint nn_plafond_Cliente NOT NULL, 
  idMoradaEntrega integer constraint nn_idMoradaEntrega_Cliente NOT NULL, 
  idMorada        integer constraint nn_idMorada_Cliente NOT NULL, 
  codigoHub       varchar(20),  
  constraint pk_Cliente PRIMARY KEY (idCliente),
  constraint ck_nivel_Cliente CHECK (nivel IN ('A', 'B', 'C', 'X')),
  constraint ck_plafond_Cliente CHECK (plafond >= 0)
);

CREATE TABLE EncomendaCliente (
  idEncomenda       integer GENERATED AS IDENTITY START WITH 1 INCREMENT BY 1, 
  idCliente         integer constraint nn_idCliente_ENCOMENDACLIENTE NOT NULL,    
  dataPedido        date constraint nn_dataPedido_ENCOMENDACLIENTE NOT NULL,
  dataVencimento    date constraint nn_dataVencimento_ENCOMENDACLIENTE NOT NULL, 
  dataPagamento     date,
  dataEntrega       date, 
  estadoPedido      varchar(20) constraint nn_estadoPedido_ENCOMENDACLIENTE NOT NULL, 
  valorTotal        float constraint nn_valorTotal_ENCOMENDACLIENTE NOT NULL,
  idMoradaEntrega   integer,
  codigoHubEntrega  varchar(20),  
  constraint pk_ENCOMENDACLIENTE PRIMARY KEY (idEncomenda),
  constraint ck_estadoPedido_ENCOMENDACLIENTE CHECK (lower(estadoPedido) IN ('registada', 'entregue', 'paga')),
  constraint ck_valorTotal_ENCOMENDACLIENTE CHECK (valorTotal > 0),
  constraint ck_dataVencimento_ENCOMENDACLIENTE CHECK (dataVencimento >= dataPedido),
  constraint ck_dataPagamento_ENCOMENDACLIENTE CHECK (dataPagamento >= dataPedido),
  constraint ck_dataEntrega_ENCOMENDACLIENTE CHECK (dataEntrega >= dataPedido)
);

CREATE TABLE Transporte (
  idTransporte      integer GENERATED AS IDENTITY START WITH 1 INCREMENT BY 1, 
  idCondutor        integer constraint nn_idCondutor_Transporte NOT NULL, 
  idProduto         integer constraint nn_idProduto_Transporte NOT NULL, 
  codigoHub         varchar(20) constraint nn_codigoHub_Transporte NOT NULL, 
  constraint pk_Transporte PRIMARY KEY (idTransporte)
);

CREATE TABLE AplicacoesRealizar (
  idCultura    integer constraint nn_idCultura_AplicacoesRealizar NOT NULL, 
  idPlanoAnual integer constraint nn_idPlanoAnual_AplicacoesRealizar NOT NULL, 
  quantidade   integer constraint nn_quantidade_AplicacoesRealizar NOT NULL, 
  dataPrevista date constraint nn_dataPrevista_AplicacoesRealizar NOT NULL, 
  constraint pk_AplicacoesRealizar PRIMARY KEY (idCultura, idPlanoAnual),
  constraint ck_quantidade_AplicacoesRealizar check (quantidade >= 0)
);

CREATE TABLE PlanoAnual (
  idPlanoAnual      integer GENERATED AS IDENTITY START WITH 1 INCREMENT BY 1, 
  correcoesMinerais varchar(300) constraint nn_correcoesMinerais_PlanoAnual NOT NULL, 
  fertilizacao      varchar(300) constraint nn_fertilizacao_PlanoAnual NOT NULL, 
  necessidadeRega   integer constraint nn_necessidadeRega_PlanoAnual NOT NULL, 
  realizadoVia      varchar(50) constraint nn_realizadoVia_PlanoAnual NOT NULL, 
  ano               integer constraint nn_ano_PlanoAnual NOT NULL, 
  constraint pk_PlanoAtual PRIMARY KEY (idPlanoAnual),
  constraint ck_necessidadeRega_PlanoAnual check (necessidadeRega >= 0),
  constraint ck_ano_PlanoAnual check (ano between 1900 and 2100),
  constraint ck_realizadoVia_PlanoAnual check (lower(realizadoVia) in ('sistema de rega','aplicacao direta'))
);

CREATE TABLE FatorProducao (
  idFatorProducao    integer GENERATED AS IDENTITY START WITH 1 INCREMENT BY 1, 
  classificacaoFator varchar(50) constraint nn_classificacaoFator_FatorProducao NOT NULL, 
  nomeComercial      varchar(50) constraint nn_nomeComercial_FatorProducao NOT NULL, 
  formulacao         varchar(9) constraint nn_formulacao_FatorProducao NOT NULL, 
  fornecedor         varchar(255) constraint nn_fornecedor_FatorProducao NOT NULL, 
  constraint pk_FatorProducao PRIMARY KEY (idFatorProducao),
  constraint ck_formulacao_FatorProducao check (lower(formulacao) in ('liquido', 'granulado', 'po')),
  constraint ck_classificacaoFator_FatorProducao check (lower(classificacaoFator) in ('fertilizantes', 'adubo', 'correctivos', 'produtos fitofarmacos'))
);

CREATE TABLE OperacoesAgricolas (
  idOperacao          integer GENERATED AS IDENTITY START WITH 1 INCREMENT BY 1, 
  idSetor             integer constraint nn_idSetor_OperacoesAgricolas NOT NULL, 
  tipoOperacao        varchar(20) constraint nn_tipoOperacao_OperacoesAgricolas NOT NULL,
  dataRealizacao      date constraint nn_dataRealizacao_OperacoesAgricolas NOT NULL,
  estadoOperacao      varchar(20) constraint nn_estadoOperacao_OperacoesAgricolas NOT NULL,
  constraint ck_tipoOperacao_OperacoesAgricolas check (lower(tipoOperacao) in ('irrigação', 'adubação', 'aplicação')),
  constraint ck_estadoOperacao_OperacoesAgricolas check (lower(estadoOperacao) in ('cancelada', 'agendada', 'realizada')),
  constraint pk_OperacoesAgricolas PRIMARY KEY (idOperacao)
);

CREATE TABLE OperacaoFatoresProducaoAplicados (
  idOperacao          integer constraint nn_idOperacao_OperacaoFatoresProducaoAplicados NOT NULL, 
  idFatorProducao     integer constraint nn_idFatorProducao_OperacaoFatoresProducaoAplicados NOT NULL,
  quantidadeAplicada  float constraint nn_quantidadeAplicada_OperacaoFatoresProducaoAplicados NOT NULL,
  formaAplicacao      varchar(20) constraint nn_formaAplicacao_OperacaoFatoresProducaoAplicados NOT NULL,
  constraint ck_formaAplicacao_OperacaoFatoresProducaoAplicados check (lower(formaAplicacao) in ('foliar', 'fertirrega', 'no solo')),
  constraint pk_OperacaoFatoresProducaoAplicados PRIMARY KEY (idOperacao, idFatorProducao)
);

CREATE TABLE RestricoesSetorFatorProducao (
  idRestricao           integer GENERATED AS IDENTITY START WITH 1 INCREMENT BY 1, 
  idSetor               integer constraint nn_idSetor_RestricoesSetorFatorProducao NOT NULL, 
  idFatorProducao       integer constraint nn_idFatorProducao_RestricoesSetorFatorProducao NOT NULL,
  dataInicioRestricao   date constraint nn_dataRealizacao_RestricoesSetorFatorProducao NOT NULL,
  dataFimRestricao      date constraint nn_dataFimRestricao_RestricoesSetorFatorProducao NOT NULL,
  constraint ck_dataFimRestricao_RestricoesSetorFatorProducao CHECK (dataFimRestricao >= dataInicioRestricao),
  constraint pk_RestricoesSetorFatorProducao PRIMARY KEY (idRestricao)
);

CREATE TABLE FichaTecnica (
  idFichaTecnica   integer GENERATED AS IDENTITY START WITH 1 INCREMENT BY 1, 
  idFatorProducao integer constraint nn_idFatorProducao_FichaTecnica NOT NULL, 
  categoria       varchar(150) constraint nn_categoria_FichaTecnica NOT NULL, 
  constraint pk_FichaTecnica PRIMARY KEY (idFichaTecnica)
);

CREATE TABLE Elemento (
  idElemento    integer GENERATED AS IDENTITY START WITH 1 INCREMENT BY 1,
  substancia    varchar(300) constraint nn_substancia_Elemento NOT NULL,  
  quantidade    float constraint nn_quantidade_Elemento NOT NULL,
  unidade       varchar(10) constraint nn_unidade_Elemento NOT NULL,  
  constraint pk_Elemento PRIMARY KEY (idElemento),
  constraint ck_quantidade_Elemento CHECK (quantidade >= 0)
);

CREATE TABLE FichaTecnicaElemento (
  idFichaTecnica integer constraint nn_idFichaTecnica_FichaTecnicaElemento NOT NULL, 
  idElemento    integer constraint nn_idElemento_FichaTecnicaElemento NOT NULL, 
  constraint pk_FichaTecnicaElemento PRIMARY KEY (idFichaTecnica, idElemento)
);

CREATE TABLE CadernoCampo (
  idCadernoCampo   integer GENERATED AS IDENTITY START WITH 1 INCREMENT BY 1, 
  idGestorAgricola integer constraint nn_idGestorAgricola_CadernoCampo NOT NULL, 
  constraint pk_CadernoCampo PRIMARY KEY (idCadernoCampo)
);

CREATE TABLE ResumoMeteorologico (
  idResumoMeteorologico  integer GENERATED AS IDENTITY START WITH 1 INCREMENT BY 1, 
  resumoSensores         varchar(300) constraint nn_resumoSensores_ResumoMeteorologico NOT NULL, 
  resumoSolo             varchar(300) constraint nn_resumoSolo_ResumoMeteorologico NOT NULL,
  dataResumo             date constraint nn_dataResumo_ResumoMeteorologico NOT NULL,
  idCadernoCampo         integer constraint nn_idCadernoCampo_ResumoMeteorologico NOT NULL, 
  idEstacaoMeteorologico integer constraint nn_idEstacaoMeteorologico_ResumoMeteorologico NOT NULL, 
  constraint pk_ResumoMeteorologico PRIMARY KEY (idResumoMeteorologico)
);

CREATE TABLE EstacaoMeteorologica (
  idEstacaoMeteorologico    integer GENERATED AS IDENTITY START WITH 1 INCREMENT BY 1,
  nomeEstacaoMeteorologica  varchar(50) constraint nn_nome_EstacaoMeteorologica NOT NULL,   
  constraint pk_EstacaoMeteorologica PRIMARY KEY (idEstacaoMeteorologico)
);

CREATE TABLE ResumoMeteorologicoSensor (
  idResumoMeteorologico integer constraint nn_idResumoMeteorologico_ResumoMeteorologicoSensor NOT NULL, 
  idMedicao             integer constraint nn_idMedicao_ResumoMeteorologicoSensor NOT NULL, 
  constraint pk_ResumoMeteorologicoSensor PRIMARY KEY (idResumoMeteorologico, idMedicao)
);

CREATE TABLE SensorMedicoes ( 
  idMedicao         integer GENERATED AS IDENTITY START WITH 1 INCREMENT BY 1,
  idSensor          char(5) constraint nn_idSensor_SensorMedicoes NOT NULL,  
  valorLido         float constraint nn_valorLido_SensorMedicoes NOT NULL, 
  instanteLeitura   date constraint nn_instanteLeitura_SensorMedicoes NOT NULL, 
  constraint pk_SensorMedicoes PRIMARY KEY (idMedicao),
  constraint ck_valorLido_SensorMedicoes CHECK (valorLido >= 0 and valorLido <= 100)
);

CREATE TABLE Sensor (
  idSensor          char(5), 
  tipoSensor        char(2) constraint nn_tipoSensor_Sensor NOT NULL, 
  valorReferencia   integer constraint nnu_valorReferencia_Sensor NOT NULL UNIQUE, 
  constraint pk_Sensor PRIMARY KEY (idSensor),
  constraint ck_tipoSensor_Sensor check (lower(tipoSensor) in ('hs', 'pl', 'ts', 'vv', 'ta', 'ha', 'pa'))
);

CREATE TABLE Input_Sensor (
  input_string   varchar(25)
);

CREATE TABLE ProcessoLeitura (
  idProcessoLeitura       integer GENERATED AS IDENTITY START WITH 1 INCREMENT BY 1, 
  dataHora                date constraint nn_dataHora_ProcessoLeitura NOT NULL, 
  numRegistosLidos        integer,
  numRegistosInseridos    integer,
  numErros                integer,
  constraint pk_ProcessoLeitura PRIMARY KEY (idProcessoLeitura)
);

CREATE TABLE ProcessoLeituraSensor (
  idProcessoLeitura       integer constraint nn_idProcessoLeitura_ProcessoLeituraSensor NOT NULL, 
  idSensor                char(5) constraint nn_idSensor_ProcessoLeituraSensor NOT NULL, 
  numErros                integer constraint nn_numErros_ProcessoLeituraSensor NOT NULL,
  constraint pk_ProcessoLeituraSensor PRIMARY KEY (idProcessoLeitura, idSensor)
);
  
CREATE TABLE Registo (
  idRegisto      integer GENERATED AS IDENTITY START WITH 1 INCREMENT BY 1, 
  dataRegisto    date constraint nn_dataRegisto_Registo NOT NULL, 
  parcela        varchar(50) constraint nn_parcela_Registo NOT NULL, 
  Quantidade     integer constraint nn_quantidade_Registo NOT NULL, 
  idCadernoCampo integer constraint nn_idCadernoCampo_Registo NOT NULL, 
  constraint pk_Registo PRIMARY KEY (idRegisto)
);

CREATE TABLE RegistoFertelizacao (
  idRegisto        integer constraint nn_idRegisto_RegistoFertelizacao NOT NULL, 
  tipoFertelizacao varchar(50) NOT NULL, 
  constraint pk_RegistoFertelizacao PRIMARY KEY (idRegisto)
);

CREATE TABLE RegistoRega (
  idRegisto integer constraint nn_idRegisto_RegistoRega NOT NULL,
  descricao varchar(300) constraint nn_descricao_RegistoRega NOT NULL, 
  constraint pk_RegistoRega PRIMARY KEY (idRegisto)
);

CREATE TABLE RegistoColheita (
  idRegisto       integer constraint nn_idRegisto_RegistoColheita NOT NULL, 
  produtoColheita varchar(150) constraint nn_produtoColheita_RegistoColheita NOT NULL, 
  constraint pk_RegistoColheita PRIMARY KEY (idRegisto)
);

CREATE TABLE GestorAgricolaCliente (
  idGestorAgricola integer constraint nn_idGestorAgricola_GestorAgricolaCliente NOT NULL, 
  idCliente        integer constraint nn_idCliente_GestorAgricolaCliente NOT NULL, 
  constraint pk_GestorAgricolaCliente PRIMARY KEY (idGestorAgricola, idCliente)
);

CREATE TABLE Morada (
  idMorada     integer GENERATED AS IDENTITY START WITH 1 INCREMENT BY 1, 
  endereco     varchar(500) constraint nn_endereco_Morada NOT NULL, 
  codigoPostal char(8) constraint nn_codigoPostal_Morada NOT NULL, 
  constraint pk_Morada PRIMARY KEY (idMorada),
  constraint ck_codigoPostal_Morada check (REGEXP_LIKE(codigoPostal, '^[0-9]{4}-[0-9]{3}$'))
);

CREATE TABLE ClienteIncidentes (
  idCliente      integer constraint nn_idCliente_ClienteIncidentes NOT NULL, 
  numeroIncidentes    integer DEFAULT 0, 
  dataUltimoIncidente     date,
  constraint pk_idCliente_ClienteIncidentes PRIMARY KEY (idCliente)
);

CREATE TABLE Incidente (
  idIncidente    integer GENERATED AS IDENTITY START WITH 1 INCREMENT BY 1, 
  idCliente      integer constraint nn_idCliente_Incidente NOT NULL, 
  valorDivida    float constraint nn_valorDivida_Incidente NOT NULL, 
  dataSanado     date, 
  dataOcorrencia date constraint nn_dataOcorrencia_Incidente NOT NULL, 
  constraint pk_Incidente PRIMARY KEY (idIncidente),
  constraint ck_valorDivida_Incidente CHECK (valorDivida > 0)
);

CREATE TABLE ClienteEncomendasAnuais (
  idCliente      integer constraint nn_idCliente_ClienteEncomendasAnuais NOT NULL, 
  numeroEncomendas    integer DEFAULT 0, 
  valorTotalEncomendas    integer DEFAULT 0,
  constraint pk_idCliente_ClienteEncomendasAnuais PRIMARY KEY (idCliente)
);

CREATE TABLE ENCOMENDAPRODUTO (
  idEncomenda  integer constraint nn_idEncomenda_ENCOMENDAPRODUTO NOT NULL, 
  idProduto    integer constraint nn_idProduto_ENCOMENDAPRODUTO NOT NULL,
  quantidade   integer constraint nn_quantidade_ENCOMENDAPRODUTO NOT NULL,  
  constraint pk_ENCOMENDAPRODUTO PRIMARY KEY (idEncomenda, idProduto)
);

CREATE TABLE CulturaProduto (
  idCultura   integer constraint nn_idCultura_CulturaProduto NOT NULL, 
  idProduto integer constraint nn_idProduto_CulturaProduto NOT NULL, 
  constraint pk_CulturaProduto PRIMARY KEY (idCultura, idProduto)
);

CREATE TABLE ProdutoAgricola (
  idProduto  integer GENERATED AS IDENTITY START WITH 1 INCREMENT BY 1, 
  designacao varchar(150) constraint nn_designacao_ProdutoAgricola NOT NULL, 
  constraint pk_ProdutoAgricola PRIMARY KEY (idProduto)
);

CREATE TABLE Pessoa(
  idPessoa integer GENERATED AS IDENTITY START WITH 1 INCREMENT BY 1,
  nome            varchar(200) constraint nn_nome_Pessoa NOT NULL, 
  nif             char(9) constraint nnu_nif_Pessoa NOT NULL UNIQUE, 
  email           varchar(150) constraint nnu_email_Pessoa NOT NULL UNIQUE,
  constraint pk_Pessoa PRIMARY KEY (idPessoa),
  constraint ck_nif_Pessoa CHECK (REGEXP_LIKE(nif, '[0-9]{9}', 'i')),
  constraint ck_email_Pessoa CHECK (email LIKE '%@%.%')
);

CREATE TABLE Safra(
  idSafra integer GENERATED AS IDENTITY START WITH 1 INCREMENT BY 1,
  idCultura integer constraint nn_idCultura_Safra NOT NULL,
  lucro float constraint nn_lucro_Safra NOT NULL,
  quantidade float constraint nn_quantidade_Safra NOT NULL,
  periodicidade integer constraint nn_periodicidade_Safra NOT NULL,
  areaSafra float constraint nn_area_Safra NOT NULL, 
  constraint pk_Safra PRIMARY KEY (idSafra),
  constraint ck_area_Safra CHECK (areaSafra > 0),
  constraint ck_lucro_Safra CHECK (lucro > 0),
  constraint ck_quantidade_Safra CHECK (quantidade > 0),
  constraint ck_tempo_Safra CHECK (periodicidade > 0)
);

CREATE TABLE PlanoRegaCultura(
  idPlanoRega integer,
  idCultura integer,
  constraint pk_PlanoRegaCultura PRIMARY KEY (idPlanoRega, idCultura)
);

CREATE TABLE RegistoOperacoesAgricolas(
    idRegisto           integer GENERATED AS IDENTITY START WITH 1 INCREMENT BY 1,
    idSetor             integer constraint nn_idOperacao NOT NULL,
    utilizador          varchar(128) constraint nn_utilizador NOT NULL,
    dataHoraOperacao    date constraint nn_dataOperacao_RegistoOperacoesAgricolas NOT NULL,
    tipoAlteracao       char(6) constraint nn_tipoAlteracao_RegistoOperacoesAgricolas NOT NULL,
    constraint pk_RegistoOperacoesAgricolas PRIMARY KEY (idRegisto),
    constraint check_type CHECK (lower(tipoAlteracao) IN ('delete', 'update', 'insert'))
);

/* Constraints foreign key */

alter table FichaTecnicaElemento
add constraint fk_FichaTecnicaElemento_FichaTecnica foreign key (idFichaTecnica) references FichaTecnica(idFichaTecnica);

alter table FichaTecnicaElemento
add constraint fk_FichaTecnicaElemento_Elemento foreign key (idElemento) references Elemento(idElemento);

alter table FichaTecnica
add constraint fk_FichaTecnica_FatorProducao foreign key (idFatorProducao) references FatorProducao(idFatorProducao);

alter table OperacoesAgricolas
add constraint fk_OperacoesAgricolas_Setor foreign key (idSetor) references Setor(idSetor);

alter table OperacaoFatoresProducaoAplicados
add constraint fk_OperacaoFatoresProducaoAplicados_FatorProducao foreign key (idFatorProducao) references FatorProducao(idFatorProducao);

alter table OperacaoFatoresProducaoAplicados
add constraint fk_OperacaoFatoresProducaoAplicados_Setor foreign key (idOperacao) references OperacoesAgricolas(idOperacao);

alter table RestricoesSetorFatorProducao
add constraint fk_RestricoesSetorFatorProducao_FatorProducao foreign key (idFatorProducao) references FatorProducao(idFatorProducao);

alter table RestricoesSetorFatorProducao
add constraint fk_RestricoesSetorFatorProducao_Setor foreign key (idSetor) references Setor(idSetor);

alter table Cultura
add constraint fk_Cultura_Setor foreign key (idSetor) references Setor(idSetor);

alter table AplicacoesRealizar
add constraint fk_AplicacoesRealizar_Cultura foreign key (idCultura) references Cultura(idCultura);

alter table AplicacoesRealizar
add constraint fk_AplicacoesRealizar_PlanoAnual foreign key (idPlanoAnual) references PlanoAnual(idPlanoAnual);

alter table Setor
add constraint fk_Setor_GestorAgricola foreign key (idGestorAgricola) references GestorAgricola(idGestorAgricola);

alter table Controlador
add constraint fk_Controlador_PlanoRega foreign key (idPlanoRega) references PlanoRega(idPlanoRega);

alter table Controlador
add constraint fk_Controlador_SistemaRega foreign key (idSistemaRega) references SistemaRega(idSistemaRega);

alter table SistemaRega
add constraint fk_SistemaRega_GestorAgricola foreign key (idGestorAgricola) references GestorAgricola(idGestorAgricola);

alter table CulturaProduto
add constraint fk_CulturaProduto_Cultura foreign key (idCultura) references Cultura(idCultura);

alter table CulturaProduto
add constraint fk_CulturaProduto_ProdutoAgricola foreign key (idProduto) references ProdutoAgricola(idProduto);

alter table Transporte
add constraint fk_Transporte_Condutor foreign key (idCondutor) references Condutor(idCondutor);

alter table Transporte
add constraint fk_Transporte_ProdutoAgricola foreign key (idProduto) references ProdutoAgricola(idProduto);

alter table Transporte
add constraint fk_Transporte_Hub foreign key (codigoHub) references Hub(codigoHub);

alter table ENCOMENDAPRODUTO
add constraint fk_ENCOMENDAPRODUTO_ENCOMENDACLIENTE foreign key (idEncomenda) references ENCOMENDACLIENTE(idEncomenda);

alter table ENCOMENDAPRODUTO
add constraint fk_ENCOMENDAPRODUTO_ProdutoAgricola foreign key (idProduto) references ProdutoAgricola(idProduto);

alter table ENCOMENDACLIENTE
add constraint fk_ENCOMENDACLIENTE_Cliente foreign key (idCliente) references Cliente(idCliente);

alter table ENCOMENDACLIENTE
add constraint fk_ENCOMENDACLIENTE_Morada foreign key (idMoradaEntrega) references Morada(idMorada);

alter table ENCOMENDACLIENTE
add constraint fk_ENCOMENDACLIENTE_Hub foreign key (codigoHubEntrega) references Hub(codigoHub);

alter table Cliente
add constraint fk_Cliente_Morada foreign key (idMorada) references Morada(idMorada);

alter table Cliente
add constraint fk_Cliente_Morada2 foreign key (idMoradaEntrega) references Morada(idMorada);

alter table Cliente
add constraint fk_Cliente_Hub foreign key (codigoHub) references Hub(codigoHub);

alter table ClienteIncidentes
add constraint fk_ClienteIncidentes_Cliente foreign key (idCliente) references Cliente(idCliente);

alter table Incidente
add constraint fk_Incidente_Cliente foreign key (idCliente) references Cliente(idCliente);

alter table ClienteEncomendasAnuais
add constraint fk_ClienteEncomendasAnuais_Cliente foreign key (idCliente) references Cliente(idCliente);

alter table GestorAgricolaCliente
add constraint fk_GestorAgricolaCliente_GestorAgricola foreign key (idGestorAgricola) references GestorAgricola(idGestorAgricola);

alter table GestorAgricolaCliente
add constraint fk_GestorAgricolaCliente_Cliente foreign key (idCliente) references Cliente(idCliente);

alter table CadernoCampo
add constraint fk_CadernoCampo_GestoAgricola foreign key (idGestorAgricola) references GestorAgricola(idGestorAgricola);

alter table Registo
add constraint fk_Registo_CadernoCampo foreign key (idCadernoCampo) references CadernoCampo(idCadernoCampo);

alter table RegistoFertelizacao
add constraint fk_RegistoFertelizacao_Registo foreign key (idRegisto) references Registo(idRegisto);

alter table RegistoRega
add constraint fk_RegistoRega_Registo foreign key (idRegisto) references Registo(idRegisto);

alter table RegistoColheita
add constraint fk_RegistoColheita_Registo foreign key (idRegisto) references Registo(idRegisto);

alter table ResumoMeteorologico
add constraint fk_ResumoMeteorologico_CadernoCampo foreign key (idCadernoCampo) references CadernoCampo(idCadernoCampo);

alter table ResumoMeteorologico
add constraint fk_ResumoMeteorologico_EstacaoMeteorologica foreign key (idEstacaoMeteorologico) references EstacaoMeteorologica(idEstacaoMeteorologico);

alter table ResumoMeteorologicoSensor
add constraint fk_ResumoMeteorologicoSensor_ResumoMeteorologico foreign key (idResumoMeteorologico) references ResumoMeteorologico(idResumoMeteorologico);

alter table ResumoMeteorologicoSensor
add constraint fk_ResumoMeteorologicoSensor_SensorMedicoes foreign key (idMedicao) references SensorMedicoes(idMedicao);

alter table SensorMedicoes
add constraint fk_SensorMedicoes_Sensor foreign key (idSensor) references Sensor(idSensor);

alter table ProcessoLeituraSensor
add constraint fk_ProcessoLeituraSensor_ProcessoLeitura foreign key (idProcessoLeitura) references ProcessoLeitura(idProcessoLeitura);

alter table ProcessoLeituraSensor
add constraint fk_ProcessoLeituraSensor_Sensor foreign key (idSensor) references Sensor(idSensor);

alter table Cliente
add constraint fk_Cliente_Pessoa foreign key (idCliente) references Pessoa(idPessoa);

alter table GestorAgricola
add constraint fk_GestorAgricola_Pessoa foreign key (idGestorAgricola) references Pessoa(idPessoa);

alter table Condutor
add constraint fk_Condutor_Pessoa foreign key (idCondutor) references Pessoa(idPessoa);

alter table Safra
add constraint fk_Safra_Cultura foreign key (idCultura) references Cultura(idCultura);

alter table PlanoRegaCultura
add constraint fk_PlanoRegaCultura_PlanoRega foreign key (idPlanoRega) references PlanoRega(idPlanoRega);

alter table PlanoRegaCultura
add constraint fk_PlanoRegaCultura_Cultura foreign key (idCultura) references Cultura(idCultura);

alter table RegistoOperacoesAgricolas
add constraint fk_RegistoOperacoesAgricolas_idSetor foreign key (idSetor) references Setor(idSetor);

/* Triggers */

-- Atualiza a tabela CLIENTEINCIDENTES sempre que um incidente novo é adicionado
-- Atualiza o nivel do CLIENTE pois a partir do momento que um CLIENTE tem um INCIDENTE no mesmo ano, o seu nivel é alterado para 'C'
CREATE OR REPLACE TRIGGER trg_new_incidente
  AFTER INSERT ON INCIDENTE
FOR EACH ROW
DECLARE
    new_numero_incidentes CLIENTEINCIDENTES.NUMEROINCIDENTES%type;
BEGIN
    SELECT NUMEROINCIDENTES INTO new_numero_incidentes FROM CLIENTEINCIDENTES WHERE IDCLIENTE = :new.IDCLIENTE;
    
    new_numero_incidentes := new_numero_incidentes + 1;
    
    UPDATE CLIENTEINCIDENTES SET NUMEROINCIDENTES = new_numero_incidentes, DATAULTIMOINCIDENTE = :new.DATAOCORRENCIA WHERE IDCLIENTE = :new.IDCLIENTE;

    UPDATE CLIENTE SET NIVEL = 'C' WHERE IDCLIENTE = :new.IDCLIENTE;
END;
/


-- Atualiza a tabela CLIENTEENCOMENDASANUAIS sempre que um pedido é feito pelo cliente
CREATE OR REPLACE TRIGGER trg_new_pedido_cliente
  BEFORE INSERT ON ENCOMENDACLIENTE
FOR EACH ROW
DECLARE
    new_numero_encomendas CLIENTEENCOMENDASANUAIS.NUMEROENCOMENDAS%type;
    new_valor_total_encomendas CLIENTEENCOMENDASANUAIS.VALORTOTALENCOMENDAS%type;
BEGIN
    SELECT COUNT(*) INTO new_numero_encomendas FROM ENCOMENDACLIENTE WHERE IDCLIENTE = :new.IDCLIENTE and DATAPEDIDO between add_months(SYSDATE, -12) and SYSDATE;
    SELECT SUM(VALORTOTAL) INTO new_valor_total_encomendas FROM ENCOMENDACLIENTE WHERE IDCLIENTE = :new.IDCLIENTE and DATAPEDIDO between add_months(SYSDATE, -12) and SYSDATE;
    
    new_numero_encomendas := new_numero_encomendas + 1;
    new_valor_total_encomendas := new_valor_total_encomendas + :new.VALORTOTAL;
    
    UPDATE CLIENTEENCOMENDASANUAIS SET NUMEROENCOMENDAS = new_numero_encomendas, VALORTOTALENCOMENDAS = new_valor_total_encomendas WHERE IDCLIENTE = :new.IDCLIENTE;
END;
/

--Cria uma linha na tabela ClienteIncidentes com os dados default para o cliente que acabou de ser adicionado na tabela Cliente
--Cria uma linha na tabela ClienteEncomendas com os dados default para o cliente que acabou de ser adicionado na tabela Cliente
CREATE OR REPLACE TRIGGER trg_new_cliente
  AFTER INSERT ON CLIENTE
FOR EACH ROW
BEGIN
    INSERT INTO CLIENTEINCIDENTES (IDCLIENTE,NUMEROINCIDENTES,DATAULTIMOINCIDENTE) 
    VALUES (:new.IDCLIENTE,'0',null);
    
    INSERT INTO CLIENTEENCOMENDASANUAIS (IDCLIENTE,NUMEROENCOMENDAS,VALORTOTALENCOMENDAS) 
    VALUES (:new.IDCLIENTE,'0','0');
END;
/
