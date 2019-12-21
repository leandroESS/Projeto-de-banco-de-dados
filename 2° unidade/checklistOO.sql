-- 1. Criação de tipo e subtipo

-- já feito na criação de tabela e tipi 8 

-----------------------------------------------------------------------------//--------------------------------

-- 2. Criação de um tipo que contenha um atributo que seja de um outro tipo

-- telefone de pessoa referencia  tipo pessoa 

-----------------------------------------------------------------------------//--------------------------------

-- 3. Criação de um tipo que contenha um atributo que seja de um tipo VARRAY

CREATE OR REPLACE TYPE tp_va_fones AS VARRAY(5) OF VARCHAR(10);
/
-----------------------------------------------------------------------------//--------------------------------

-- 4. Criação de um tipo que contenha um atributo que seja de um tipo NESTED TABLE

-- já tem na criação de tipo
-----------------------------------------------------------------------------//--------------------------------
-- 5. Criação e chamada de um método construtor (diferente do padrão)

ALTER TYPE tp_carro ADD CONSTRUCTOR FUNCTION tp_carro (placa VARCHAR2) RETURN SELF AS RESULT CASCADE;

CREATE OR REPLACE TYPE BODY tp_carro as
	CONSTRUCTOR FUNCTION  tp_carro (placa VARCHAR2) RETURN SELF AS RESULT IS
	BEGIN
		SELF.placa  := 'AVC5567';
		SELF.cor := cor;
		SELF.ano := ano;
		SELF.modelo := modelo;
		RETURN;
	END;
END;
/

/* Teste item 5.

CREATE OR REPLACE TYPE tp_automovel AS OBJECT(
	placa2 varchar2(20),
	automovel tp_carro
)FINAL;
/

CREATE TABLE tb_automovel OF tp_automovel(
	PRIMARY KEY (placa)
);

INSERT INTO tb_automovel VALUES ('GLS000', tp_carro('GLS000'));
SELECT * FROM tb_automovel;

*/

-----------------------------------------------------------------------------//--------------------------------

--8. Criação e chamada de um método ORDER em um comando SELECT e em um bloco PL


-- ele diz se o carro do parametro é antigo ou novo comparando o ano de lançamento 


ALTER TYPE tp_carro ADD ORDER MEMBER FUNCTION mais_antigo2(P tp_carro) RETURN NUMBER CASCADE;

	CREATE OR REPLACE TYPE BODY tp_carro as
	ORDER MEMBER FUNCTION mais_antigo2(P tp_carro) RETURN NUMBER IS
	BEGIN
		IF ano > P.ano THEN
			DBMS_OUTPUT.PUT_LINE ('Mais antigo!');
			RETURN 1;
		ELSIF ano < P.ano THEN
			DBMS_OUTPUT.PUT_LINE ('Mais velho!');
			RETURN -1;
		ELSE
			DBMS_OUTPUT.PUT_LINE ('Mesma data!');
			RETURN 0;
		END IF;
	END;
END;
/

--  CHAMADA PL 

/*BEGIN
    DECLARE
        A tp_carro;
        B tp_carro;
        C INTEGER;
     BEGIN
          SELECT VALUE(p) INTO A FROM tb_carro p WHERE p.placa = 'SIS9816';
          SELECT VALUE(p) INTO B FROM tb_carro p WHERE p.placa = 'KWY0102';
          C:= A.mais_antigo2(B);
          DBMS_OUTPUT.PUT_LINE(C);
       END;
END;
/ 
*/


--CHAMADA SQL 

-- SELECT value(p) FROM tb_carro p, tb_carro l WHERE l.placa='KLB0876' AND p.mais_antigo2(value(l)) < 0;

-----------------------------------------------------------------------------//--------------------------------

--9. Criação e chamada de método abstrato ( retorna o nome da pessoa)

ALTER TYPE tp_pessoa ADD  MEMBER FUNCTION idade RETURN INTEGER CASCADE;

CREATE OR REPLACE TYPE BODY tp_pessoa AS
		MEMBER FUNCTION idade RETURN INTEGER IS
	BEGIN
		RETURN ((SYSDATE - data_nasc)/365);
	END;
END;
/

--- CHAMADA PL DO ITEM 9

/* BEGIN
	DECLARE
		A INTEGER;
		B tp_pessoa;
	BEGIN
		SELECT VALUE(p) INTO B FROM tb_cliente p WHERE p.nome = 'ODILEIA PIRES CALVALCANTI';
		A := B.idade();
		DBMS_OUTPUT.PUT_LINE(A);
	END;
END;
/
*/
---- CHAMADA SQL DO ITEM 9
--- SELECT p.idade() FROM tb_cliente p;

-----------------------------------------------------------------------------//--------------------------------

-- 6. Criação e chamada de um função membro em um comando SELECT e em um bloco PL

ALTER TYPE TP_ATENDENTE ADD MEMBER FUNCTION retorna_salario RETURN FLOAT CASCADE;

CREATE OR REPLACE TYPE BODY TP_ATENDENTE AS
	MEMBER FUNCTION retorna_salario RETURN FLOAT IS
	BEGIN
		RETURN SELF.SALARIO;
	END;
END;
/

-- Chamada em Consulta ( retorna o nome e o salario das mulheres atendentes)

 -- SELECT E.nome, E.retorna_salario() FROM TB_ATENDENTE E WHERE E.GENERO = 'F';

-- Chamada em Bloco PL
/*DECLARE
	NOME VARCHAR2(30);
	salario VARCHAR2(15);
BEGIN
	SELECT E.ref_chefe.retorna_salario(), E.ref_chefe.NOME INTO salario, NOME FROM TB_ATENDENTE E 
	WHERE E.NOME = 'CINTIA JESSICA LOPES';
	DBMS_OUTPUT.PUT_LINE('NOME SUPERVISOR: ' || NOME);
	DBMS_OUTPUT.PUT_LINE('SALARIO SUPERVISOR: '|| salario);	
END;
/
*/

-----------------------------------------------------------------------------//--------------------------------

--7. Criação e chamada de um método MAP em um comando SELECT e em um bloco PL

ALTER TYPE tp_pessoa ADD MAP MEMBER FUNCTION IDADE RETURN NUMBER CASCADE;

CREATE OR REPLACE TYPE BODY tp_pessoa AS
	MAP MEMBER FUNCTION IDADE RETURN NUMBER IS
		BEGIN
			RETURN TRUNC((MONTHS_BETWEEN(SYSDATE, data_nasc))/12);
		END;
END;
/

--Chamada PL
/* BEGIN
	DECLARE
		nome_p1 VARCHAR2(30);
		nome_p2 VARCHAR2(30);
		idade_p1 NUMBER;
		idade_p2 NUMBER;
	BEGIN
		SELECT p.nome, p.IDADE() INTO nome_p1, idade_p1 FROM tb_cliente p WHERE p.cpf='231228461-6';
		SELECT p.nome, p.IDADE() INTO nome_p2, idade_p2 FROM tb_cliente p WHERE p.cpf='389939572-7';
		
		DBMS_OUTPUT.PUT_LINE('cliente 1: ' || nome_p1 || ', '|| idade_p1 || ' anos.');
		DBMS_OUTPUT.PUT_LINE('cliente 2: ' || nome_p2 || ', '|| idade_p2 || ' anos.');
		
		IF (idade_p1 > idade_p2) THEN
			DBMS_OUTPUT.PUT_LINE('Paciente 1 tem prioridade de atendimento por idade.');
		ELSIF (idade_p1 < idade_p2) THEN
			DBMS_OUTPUT.PUT_LINE('Paciente 2 tem prioridade de atendimento por idade.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('Mesma prioridade de idade.');
		END IF;
	END;
END;
/ */

-- chamada SQL 

 /* SELECT p2.nome AS nome, p2.CPF AS CPF, p2.IDADE() AS idade 
FROM tb_cliente p1, tb_cliente p2 
WHERE p1.cpf='389939572-7' AND p1.IDADE()>p2.IDADE()
ORDER BY p2.data_nasc; */

-----------------------------------------------------------------------------//--------------------------------

-- 10. Redefinição de método do supertipo dentro do subtipo

ALTER TYPE TP_FUNCIONARIO ADD CONSTRUCTOR FUNCTION tp_funcionario (x1 tp_pessoa) RETURN SELF AS RESULT CASCADE;
ALTER TYPE TP_FUNCIONARIO ADD OVERRIDING MAP MEMBER FUNCTION IDADE RETURN NUMBER CASCADE;

CREATE OR REPLACE TYPE BODY tp_funcionario AS
	
	CONSTRUCTOR FUNCTION tp_funcionario (x1 tp_pessoa) RETURN SELF AS RESULT IS 
	BEGIN
		cpf := x1.cpf;
		genero := x1.genero;
		nome := x1.nome;
		data_nasc := x1.data_nasc;
		telefone := x1.telefone;
	END;
	
	OVERRIDING MAP MEMBER FUNCTION IDADE RETURN NUMBER IS
	BEGIN
		RETURN TRUNC((MONTHS_BETWEEN(SYSDATE, data_admissao))/12);
	END;
END;
/

-- teste

-- SELECT M.NOME, M.IDADE() AS tempo_servico FROM TB_mecanico M;

-----------------------------------------------------------------------------//--------------------------------

-- 11. Alteração de tipo: adição de atributo
-- 14. Alteração de supertipo com propagação de mudança

ALTER TYPE tp_carro ADD ATTRIBUTE(preco NUMBER(3,2)) CASCADE;

-----------------------------------------------------------------------------//--------------------------------

-- 12. Alteração de tipo: modificação de atributo

ALTER TYPE tp_carro MODIFY ATTRIBUTE preco NUMERIC(7,2) CASCADE;

-----------------------------------------------------------------------------//--------------------------------

-- 13. Alteração de tipo: remoção de atributo

ALTER TYPE tp_carro DROP ATTRIBUTE preco CASCADE;

-----------------------------------------------------------------------------//--------------------------------

-- 15. Alteração de supertipo com invalidação de subtipos afetados

ALTER TYPE tp_pessoa DROP ATTRIBUTE data_nasc INVALIDATE;

-- 16. Uso de referência e controle de integridade referencial

DROP TABLE  tb_atende;

CREATE TABLE tb_atende OF tp_atende(
	PRIMARY KEY (CPF_ATEND,CPF_CLIENTE),
	ref_atendente WITH ROWID REFERENCES tb_atendente,
	ref_cliente WITH ROWID REFERENCES tb_cliente
);

-- 17. Restrição de escopo de referência

CREATE TABLE tb_carrocliente3 OF tp_carrocliente(
	PRIMARY KEY (CPF_CLIENTE,PLACA_CARRO),
	ref_cliente SCOPE IS  tb_cliente,
	ref_carro SCOPE IS  tb_carro
);

-- 18. Criação de todas as tabela a partir de um tipo

-- ver criacao_tabela_mecanica.sql (todas as tabelas foram criadas a partir de um tipo)

-- 19. Criação de uma consulta com expressão de caminho para percorrer três tabelas
-- 20. Criação de uma consulta com DEREF

SELECT DEREF(f.ref_servico.ref_carro) FROM tb_realiza f  WHERE data1 = to_date ('12/06/2016', 'dd/mm/yyyy');

-- 21. Criação de uma consulta com VALUE

SELECT VALUE(L) FROM tb_promocao L;

-- 22. Criação de uma consulta com TABLE
-- 26. Criação de uma consulta que exiba os dados de um NESTED TABLE

SELECT n.nome, n.* FROM tb_atendente n, TABLE(n.telefone) t;

-- 23. Criação de consultas com LIKE, BETWEEN, ORDER BY, GROUP BY, HAVING

SELECT nome FROM tb_cliente WHERE nome LIKE 'O%';
SELECT nome FROM tb_mecanico WHERE salario BETWEEN 0 AND 30000;
SELECT * FROM tb_cliente ORDER BY data_nasc;
SELECT genero,Count(*) FROM tb_atendente GROUP BY genero HAVING COUNT(*)>1;

-- 24. Criação de subconsultas com IN , ALL, ANY,

SELECT P.descricao FROM tb_servico P WHERE P.valor > ALL( select A.valor from tb_servico A WHERE A.prazo = to_date ('04/08/2016', 'dd/mm/yyyy'));

SELECT P.descricao FROM tb_servico P WHERE P.valor < ANY( select A.valor from tb_servico A WHERE A.prazo = to_date ('04/08/2016', 'dd/mm/yyyy'));

SELECT P.cor FROM tb_carro P WHERE P.placa IN(select A.placa from tb_carro A , tb_carrocliente z WHERE  z.placa_carro = A.placa); 

-- 25. Criação de uma consulta que exiba os dados de um VARRAY

CREATE OR REPLACE TYPE tp_fones AS VARRAY(2) OF VARCHAR2(12);
/

ALTER TYPE tp_atende
    ADD ATTRIBUTE fones tp_fones CASCADE;


INSERT INTO tb_atende VALUES ('xxxxxx', 'yyyyyy', (SELECT REF(A) FROM tb_atendente A WHERE A.CPF = 'xxxxxx'), (SELECT REF(C) FROM tb_cliente C WHERE C.CPF = 'yyyyyy'), tp_fones('99999-9999', '88888-8888'));


SELECT  d.fones FROM tb_atende d; 




-- 27. SELECT com EXISTS para acessar os dados de uma tabela A​ com referência para outra tabela B​, a partir da tabela B

SELECT E.ref_cliente.nome from tb_realiza E WHERE EXISTS (SELECT * FROM tb_realiza f WHERE f.os =  878);

-- 28. Criação de TRIGGER de linha ao ocorrer um INSERT, DELETE ou UPDATE

CREATE OR REPLACE TRIGGER verifica
BEFORE INSERT ON tb_cliente
FOR EACH ROW
DECLARE
	cont NUMBER;
BEGIN
	SELECT COUNT(*) INTO cont FROM tb_cliente M WHERE M.nome = :NEW.nome;
	IF (cont > 0) THEN
		RAISE_APPLICATION_ERROR(-20020, 'Nome ja cadastrado');
	END IF;
END verifica;
/

-- 29. Criação de TRIGGER de linha para impedir INSERT, DELETE ou UPDATE

Create OR REPLACE TRIGGER impedir
BEFORE UPDATE ON tb_mecanico
FOR EACH ROW
WHEN (NEW.salario > Old.salario)
BEGIN
	RAISE_APPLICATION_ERROR(-20017, 'Ninguem pode receber mais que 50% de aumento na mesma atualizacao');
END impedir;
/

-- 30. Criação de TRIGGER de comando para impedir INSERT, DELETE ou UPDATE

CREATE OR REPLACE TRIGGER naoDelete1
BEFORE DELETE ON tb_carro
DECLARE
auxDelete NUMBER;
BEGIN
SELECT COUNT(*) INTO auxDelete from tb_carro;
IF auxDelete = 1 THEN
RAISE_APPLICATION_ERROR(-20324,'Nao posso deletar, pois a tabela so tem uma linha');
  	END IF;
END naoDelete1;
/




















