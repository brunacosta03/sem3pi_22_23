# Convenções de Nomenclatura para desenvolvimento de Bases de Dados

## Lingua

O desenvolvimento da base de dados será feito em Inglês.

---

## Tabelas

### Capitalization Casing

A titulação da tabela será feita com Capitalization Casing

### Exemplos

| Conceito | Nome da Tabela (Implementação) |
| -------- | ------------------------------ |
| Cliente  | Client                         |

---

## Atributos de uma tabela

### Camel Casing

Todos os atributos utilizarão Camel Casing.

#### Exemplos:

| Conceito                 | Implementação    |
| ------------------------ | ---------------- |
| Data de Nascimentoo      | birthDate        |
| Identificador de Cliente | clientID         |
| Nome de um Destribuidor  | distribuitorName |

---

## Restrições

### Snake Casing

Todas as restrições utilizarão Snake Casing

### Tipos de Restrições

Cada restrição utilizará um prefixo que indique o seu tipo:

- Primary Key: `pk`
- Unique: `u`
- Not Null: `nn`
- Not Null e Unique: `nnu`
- Foreign Key: `fk`
- Check: `ck`

Dependendo do tipo de restrição a estrutura do nome da restrição será diferente:

- Primary Key: `pk_[nomeTabela]`
- Unique: `u_[atributo]`
- Not Null: `nn_[atributo]`
- Not Null e Unique: `nnu_[atributo]`
- Foreign: `fk_[tabelaOrigem]_[tabelaChegada]`
- Check: `ck_[atributo]_[num]`

### Exemplos

| Atributo | Tipo de Restrição | Implementação |
| -------- | ----------------- | ------------- |
| clientID | Primary Key       | pk_clientID   |

| Atributo | Tipo de Restrição | TabelaOrigem | TabelaChegada | Implementação   |
| -------- | ----------------- | ------------ | ------------- | --------------- |
| clientID | Foreign Key       | Client       | Order         | fk_Client_Order |
