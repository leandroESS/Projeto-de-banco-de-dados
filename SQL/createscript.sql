--C:\Users\AvnerAugustodosAnjos\Desktop\createscript.sql
--------------------------------------------------------
--  DDL for Table PESSOA
--------------------------------------------------------

CREATE TABLE "PESSOA"
(	
	"CPF" VARCHAR2(11),
	"GENERO" VARCHAR2(1),
	"NOME" VARCHAR2(35),
	"DATA_NASC" DATE,
	CONSTRAINT "PESSOA_PK" PRIMARY KEY ("CPF")
);

--------------------------------------------------------
--  DDL for Table TELEFONE 
--------------------------------------------------------
CREATE TABLE "TELEFONE"
(	
	"CPF_PESSOA" VARCHAR2(11),
	"DDD" NUMBER,
	"NUMERO" NUMBER,
	CONSTRAINT "TELEFONE_PK" PRIMARY KEY ("NUMERO"),
	CONSTRAINT "TELEFONE_PESSOA_FK" FOREIGN KEY ("CPF_PESSOA") REFERENCES "PESSOA"("CPF")
);

--------------------------------------------------------
--  DDL for Table FUNCIONARIO
--------------------------------------------------------
CREATE TABLE "FUNCIONARIO"
(
	"CPF" VARCHAR2 (11),
	"DATA_ADMISSAO" DATE,
	"SALARIO" FLOAT,
	"MATRICULA" NUMBER,
	CONSTRAINT "FUNCIONARIO_PK" PRIMARY KEY ("CPF"),
	CONSTRAINT "FUNCIONARIO_PESSOA_FK" FOREIGN KEY ("CPF") REFERENCES"PESSOA"("CPF") 
);
CREATE SEQUENCE "MATRICULA" INCREMENT BY 1  START WITH 1 

--------------------------------------------------------
--  DDL for Table CLIENTE
--------------------------------------------------------
CREATE TABLE "CLIENTE"
(
	"CPF" VARCHAR2(11),
	"DATA_CAD" DATE,
	"ID_CAD" NUMBER,
	"PONTOS" NUMBER,
	CONSTRAINT "CLIENTE_PK" PRIMARY KEY ("CPF"),
	CONSTRAINT "CLIENTE_PESSOA_FK" FOREIGN KEY ("CPF")REFERENCES "PESSOA"("CPF")
);
CREATE SEQUENCE "ID_CAD" INCREMENT BY 1 START WITH 1

--------------------------------------------------------
--  DDL for Table ATENDENTE 
--------------------------------------------------------
CREATE TABLE "ATENDENTE"
(
	"CPF" VARCHAR2(11),
	"GRAU_ESC" VARCHAR2(30),
	"CPF_CHEFE" VARCHAR2(11),
	CONSTRAINT "ATENDENTE_PK" PRIMARY KEY ("CPF"),
	CONSTRAINT "ATENDENTE_PESSOA_FK" FOREIGN KEY ("CPF") REFERENCES "PESSOA"("CPF"),
	CONSTRAINT "ATENDENTE_CHEFE_FK" FOREIGN KEY ("CPF") REFERENCES "ATENDENTE"("CPF")
);
--------------------------------------------------------
--  DDL for Table MECANICO
--------------------------------------------------------
CREATE TABLE "MECANICO"
(
	"CPF" VARCHAR2(11),
	"CD_CERTIFICADO" NUMBER,
	"DATA_CONCLUSAO" DATE,
	"INSTITUICAO" VARCHAR2(20),
	CONSTRAINT "MECANICO_PK" PRIMARY KEY ("CPF"),
	CONSTRAINT "MECANICO_PESSOA_FK" FOREIGN KEY ("CPF") REFERENCES "PESSOA"("CPF")
);
--------------------------------------------------------
--  DDL for ATENDE 
--------------------------------------------------------
CREATE TABLE "ATENDE"
(
	"CPF_ATEND" VARCHAR2(11),
	"CPF_CLIENTE" VARCHAR2(11),
	CONSTRAINT "ATENDE_PF" PRIMARY KEY ("CPF_ATEND","CPF_CLIENTE"),
	CONSTRAINT "ANTENDE_A_FK" FOREIGN KEY ("CPF_ATEND") REFERENCES "ATENDENTE"("CPF"),
	CONSTRAINT "ANTENDE_C_FK" FOREIGN KEY ("CPF_CLIENTE") REFERENCES "CLIENTE"("CPF")
);
--------------------------------------------------------
--  DDL for CARRO 
--------------------------------------------------------
CREATE TABLE "CARRO"
(
	"PLACA" VARCHAR2(8),
	"COR" VARCHAR2(10),
	"ANO" NUMBER,
	"MODELO" VARCHAR2(10),
	CONSTRAINT "CARRO_PK" PRIMARY KEY ("PLACA")
);
--------------------------------------------------------
--  DDL for CARROCLIENTE
--------------------------------------------------------
CREATE TABLE "CARROCLIENTE"
(
	"PLACA_CARRO" VARCHAR2(8),
	"CPF_CLIENTE" VARCHAR2(11),
	CONSTRAINT "CARROCLIENTE_PK" PRIMARY KEY ("PLACA_CARRO","CPF_CLIENTE"),
	CONSTRAINT "CC_CARRO_FK" FOREIGN KEY ("PLACA_CARRO") REFERENCES "CARRO"("PLACA"),
	CONSTRAINT "CC_CLIENTE_FK" FOREIGN KEY ("CPF_CLIENTE") REFERENCES "CLIENTE"("CPF")
);
--------------------------------------------------------
--  DDL for PROMOCAO
--------------------------------------------------------
CREATE TABLE "PROMOCAO"
(
	"CD_PROMOCAO" NUMBER,
	"VALOR" FLOAT,
	"DESC_PROMOCAO" VARCHAR2(30),
	CONSTRAINT "PROMOCAO_PK" PRIMARY KEY ("CD_PROMOCAO")
);
CREATE SEQUENCE "CD_PROMOCAO" INCREMENT BY 1 START WITH 1

--------------------------------------------------------
--  DDL for SERVICO
--------------------------------------------------------
CREATE TABLE "SERVICO"
(
	"OS" NUMBER,
	"PRAZO" DATE,
	"VALOR" FLOAT,
	"DESCRICAO" VARCHAR2(20),
	"HORA" VARCHAR2(10),
	CONSTRAINT "SERVICO_PK" PRIMARY KEY ("OS")
);
--------------------------------------------------------
--  DDL for REALIZA
--------------------------------------------------------
CREATE TABLE "REALIZA"
(
	"CPF_CLIENTE" VARCHAR2(11),
	"CPF_MECANICO" VARCHAR2(11),
	"OS" NUMBER,
	"DATA" DATE,
	"CD_PROMOCAO" NUMBER,
	CONSTRAINT "REALIZA_PK" PRIMARY KEY ("CPF_MECANICO","OS"),
	CONSTRAINT "REALIZA_CLIENTE_FK" FOREIGN KEY ("CPF_CLIENTE") REFERENCES "CLIENTE"("CPF"),
	CONSTRAINT "REALIZA_MECANICO_FK" FOREIGN KEY ("CPF_MECANICO") REFERENCES "MECANICO"("CPF"),
	CONSTRAINT "REALIZA_SERVICO_FK" FOREIGN KEY ("OS") REFERENCES "SERVICO"("OS"),
	CONSTRAINT "REALIZA_PROMOCAO_FK" FOREIGN KEY ("CD_PROMOCAO") REFERENCES "PROMOCAO"("CD_PROMOCAO")
);