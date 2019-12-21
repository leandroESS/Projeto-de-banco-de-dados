--checklist
----------------------------------------------------------------sql----------------------------------------
-- 1 , 2 e 24(selecionar os nomes de funcionarios que ganham de 800 a 10000 e nasceram nos anos 90)
select p.nome
from pessoa p , funcionario f
where p.cpf = f.cpf and
f.salario between 800 and 10000 and
p.data_nasc between  to_date('1989', 'yyyy') and to_date('2000', 'yyyy');

-- 3 e 6 (seleciona nome de pessoas que começam com l de forma ordenada)
select nome 
from pessoa 
where nome like 'L%'
order by nome 

--4 ,7 , 8 e 9 ( crie view pra mostrar nomes das pessoas que trabalham na loja)

create view  trabalha_na_loja  as select nome
from  pessoa 
where cpf in 
    ( select CPF
      from funcionario); 

-- para consultar
view  = select * from trabalha_na_loja;

-- deleção de view 

DROP view trabalha_na_loja;

-- 5 (exibe os id de cadastros dos clientes  em que os pontos n sejam nulo)
select id_cad
from cliente
where pontos is not null;

--13 ( default)

--14,15 e 16 (modificando , add e removendo)

alter table cliente 
modify pontos default NULL;

alter table pessoa
add(cep varchar2(35));

alter table pessoa
drop(cep);

-- 17 ( media dos salarios dos mecanicos)
select avg(f.salario)
from funcionario f , mecanico m
where f.cpf = m.cpf

--18 (agregando carros)
select count(*) from carro;

--19 (agregando com group by)

select genero  , count(*) from Pessoa
group by genero;

-- 20 (seleciona os nomes dos clientes  sem repetir so nomes dos donos mesmo com carros diferentes)
select distinct e.nome  
from pessoa e , CARROCLIENTE cc
where e.cpf = cc.cpf_cliente;

--21 , 22 e 23
select genero  , count(*) from pessoa
group by  genero  having count (*) > 2;

select genero  , count(*) from Pessoa 
group by genero HAVING count(*) > (select count(*) from pessoa where genero = 'F');

select placa_carro , count(*) from carrocliente Where cpf_cliente = '097884027-2'  
group by placa_carro HAVING count(*) > 0;

--25

select p.nome , t.numero ,f.data_admissao from telefone t , pessoa p , funcionario f 
where p.cpf = t.cpf_pessoa and p.cpf = f.cpf;

--26

SELECT P.nome AS atendente, a.cpf AS CPF, a.cpf_chefe AS chefe
FROM pessoa P 
INNER JOIN atendente a ON P.cpf = a.cpf;


--27
SELECT p.nome, r.os, r.data1 FROM pessoa P LEFT OUTER JOIN realiza r on r.os = 878;


--28

SELECT P.data_nasc, c.* FROM pessoa P RIGHT OUTER JOIN cliente c ON c.CPF = P.CPF;


--29

select  cc.placa_carro , p.nome from carrocliente cc full outer join pessoa p on cc.cpf_cliente = p.cpf;



--30

select cpf  from funcionario  where salario > some (select salario from funcionario); 

--31
select cpf  from funcionario  where salario <= all (select salario from funcionario); 

--32 /33

select p.nome from pessoa p where exists ( select a.grau_esc from atendente a where grau_esc = 'ENSINO MEDIO INCOMPLETO' and a.cpf = p.cpf);

--34 (faz uniao de atendentes e mecanicos)

(select cpf AS atendente from atendente ) UNION (select cpf as mecanico from mecanico);

--35

(select CPF from pessoa) INTERSECT (select cpf from cliente);


--36 (seleciona todos os funcionarios em que n tme matricula 005)

(select cpf AS funcionario from funcionario ) MINUS (select cpf from funcionario where matricula = 005);

--37 

INSERT INTO TELEFONE (CPF_PESSOA, DDD, NUMERO) select f.cpf , f.salario , f.matricula from    funcionario f where f.cpf = '219006249-4' and f.salario = 880.00  and f.matricula = 001;



--38 
UPDATE funcionario SET salario = 1.3*salario WHERE cpf =  (select cpf from mecanico where cpf ='076899121-2'); 


--39

DELETE funcionario WHERE salario < (select avg(salario) from funcionario);



--40

GRANT SELECT ON servico TO PUBLIC;

--41

REVOKE SELECT ON servico FROM PUBLIC;

--42

select viewImplicita.cpf from (select cpf from pessoa where cpf in (select cpf from atendente)) viewImplicita where viewImplicita.cpf = '490040683-8';

--43
select avg(salario)+100 from funcionario;

--44
SELECT data_admissao , matricula FROM funcionario where salario BETWEEN (select min(salario) from funcionario) AND (select avg(salario) from funcionario);

--45
select s.descricao from servico s
inner join carrocliente cc on s.placa_carro = cc.placa_carro
inner join pessoa p on p.cpf = cc.cpf_cliente;

--46
select * from Pessoa order by data_nasc, nome;

--47
select c.placa from carro c where exists (select cc.cpf_cliente from carrocliente cc where cc.cpf_cliente = '445678990-2' and c.placa = cc.placa_carro );


-------------------------------------------------------------PL -----------------------------------------
--48 e 49 
declare
nome2 pessoa.nome%type;
begin
select p.nome  into nome2 from pessoa  p where p.cpf = '490040683-8';
 DBMS_OUTPUT.PUT_LINE(nome2);
EXCEPTION
 WHEN TOO_MANY_ROWS THEN RAISE_APPLICATION_ERROR (-20123, 'mais de uma pessoa retornada');
END;
/

--50 e 51
declare
total1 number;
total2 number;
begin
select count(*) into total1  from pessoa  where genero = 'm';
select count(*) into total2  from pessoa  where genero = 'f';
if(total1 > total2) then
DBMS_OUTPUT.PUT_LINE('MAIS HOMENS QUE MULHERES');
elsif(total1 < total2) then
DBMS_OUTPUT.PUT_LINE('MAIS MULHERES QUE HOMENS');
else
DBMS_OUTPUT.PUT_LINE('NUMERO DE HOMENS E MUHLERES IGUAIS');
END IF;
END;
/

--52,53,56,58,60,61
declare
   msg varchar2(50); -- msg que vou printar
   num natural; -- contador
   
   CURSOR serv ( placa servico.placa_carro%type)  is select OS, PRAZO from servico where placa_carro = placa; -- cursor recebe atributos da tabela servico
   serv_reg serv%ROWTYPE; -- registrador é do tipo cursor
begin
    select count (*) into num from servico; -- contar o numero de servico
    --for i in 1..num
    OPEN serv('GLS1234');
    LOOP
            
            FETCH serv into serv_reg;
             EXIT  when serv%NOTFOUND;
             msg :=
             CASE
                 when serv_reg.PRAZO <= to_date('31/12/2016','dd/mm/yyyy') then 'vai ser rapido' -- se o prazo do  servico ser menos que 2016
                 when serv_reg.PRAZO > to_date('31/12/2016','dd/mm/yyyy') then 'demorar muito'
                 --else 'não identificado'
              end;
              DBMS_OUTPUT.PUT_LINE ('a ordem de servico '||serv_reg.os||' '||msg);
             
            
            end loop;
        close serv;
        end;
/

--62 e 55

declare
   msg varchar2(50); -- msg que vou printar
   begin
    
    for serv_reg in ( select  os , prazo from servico)
    LOOP
   msg :=
        
             CASE
                       when serv_reg.PRAZO < to_date('2016','yyyy') then 'vai ser rapido' -- se o prazo do  servico ser menos que 2016
                 when serv_reg.PRAZO > to_date('2016','yyyy')  then 'demorar muito'
                 else 'não identificado'
              end;
              DBMS_OUTPUT.PUT_LINE ('a ordem de servico '||serv_reg.os||' '||msg);
            
            end loop;
        end;
/

--57 e 59
declare
 type register is record (name pessoa.nome%type , cpf2 pessoa.cpf%type);
 cursor atendido ( cod atendente.CPF%type) is select grau_esc from atendente  where CPF = cod;
 atende_var atendente.grau_esc%type;
 reg register;
begin
  open atendido('320117350-5');
  loop
      fetch atendido into atende_var;
      exit when atendido%notfound;  
      select nome, cpf into  reg from pessoa where  pessoa.cpf = '320117350-5';
      DBMS_OUTPUT.PUT_LINE ('O cliente '||reg.name||' do CPF '||reg.cpf2||' TEM GRAU DE ESCOLARIDADE  '||atende_var);
      end loop;
      close atendido;
end;
/

--63
CREATE OR REPLACE PROCEDURE serviu IS
	CURSOR serviu_cursor IS
	SELECT s.hora , s.valor , cc.cpf_cliente 
	FROM servico s , carrocliente cc 
	WHERE s.placa_carro = cc.placa_carro;
	hora1 servico.hora%TYPE;
	valor1 servico.valor%TYPE;
	cpfcliente carrocliente.cpf_cliente%TYPE;
BEGIN
	OPEN serviu_cursor;
	LOOP
		FETCH serviu_cursor INTO hora1,valor1,cpfcliente;
		EXIT WHEN serviu_cursor%NOTFOUND;
		DBMS_OUTPUT.PUT_LINE(hora1||' '||valor1||' '||cpfcliente);
	END LOOP;
	CLOSE serviu_cursor;
COMMIT;
END serviu;
/

begin
	serviu;
end;
/

--64 ,65 e 66
CREATE OR REPLACE PROCEDURE trocaChefe(CPFA IN atendente.cpf%TYPE,CPFC IN OUT atendente.cpf_chefe%TYPE)IS
	temp atendente.cpf_chefe%TYPE;
	
	BEGIN
	SELECT cpf_chefe INTO temp 
	FROM atendente
	WHERE cpf = CPFA;
	
    UPDATE atendente SET cpf_chefe = CPFC WHERE cpf = CPFA;
	CPFC := temp;
END;
/

--67 
DECLARE 
	Var1 atendente.cpf%TYPE;
	Var2 atendente.cpf_chefe%TYPE;
BEGIN
	Var1:='490040683-8';
	Var2:='219006249-4';
	trocaChefe(Var1,Var2);
END;
/

--68
CREATE OR REPLACE FUNCTION mediaSalarial RETURN funcionario.salario%TYPE IS
	media Funcionario.salario%TYPE;
BEGIN
	SELECT AVG(salario) INTO media 
	FROM Funcionario;
	RETURN media;
END;
/

--69
CREATE OR REPLACE FUNCTION retornaNome (cpf_func IN VARCHAR2)
    RETURN VARCHAR2
IS
   nome_func VARCHAR2(50);

BEGIN
  SELECT nome INTO nome_func
  FROM pessoa
  WHERE cpf = cpf_func;
  RETURN nome_func;

END;
/

--70 e 71
CREATE OR REPLACE FUNCTION adicionaAvaliaCusto (inicial IN NUMBER, limite IN NUMBER, valor IN OUT NUMBER, cont OUT NUMBER) RETURN BOOLEAN IS
	adicional NUMBER;
	auxiliar NUMBER;
	contador NUMBER;
	retorno BOOLEAN;
BEGIN
	adicional := 0;
	contador := 0;
	auxiliar := limite - inicial + 1;
	FOR funcTar_reg IN (SELECT * FROM funcionario) LOOP
		IF (funcTar_reg.salario IS NOT NULL) THEN 
			adicional := adicional + 1000;
			contador := contador + 1; 
		END IF;
	END LOOP;
	valor := valor + adicional/auxiliar;
	cont := contador;
	IF (valor >= 1200) THEN
		retorno := TRUE;
	ELSE
		retorno := FALSE;
	END IF;
	RETURN retorno;
END;
/




--72
CREATE OR REPLACE PACKAGE cadastraCliente AS
    PROCEDURE cadastro(Pcpf IN Pessoa.cpf%TYPE,Pgenero IN Pessoa.genero%TYPE , Pnome IN Pessoa.nome%TYPE,dn IN Pessoa.data_Nasc%TYPE); --faltou variáveis
	FUNCTION idade(dn IN Pessoa.data_Nasc%TYPE) RETURN NUMBER; -- faltou return
END;
/

CREATE OR REPLACE PACKAGE BODY cadastraCliente AS
	PROCEDURE cadastro (Pcpf IN Pessoa.cpf%TYPE,Pgenero IN Pessoa.genero%TYPE , Pnome IN Pessoa.nome%TYPE,dn IN Pessoa.data_Nasc%TYPE)IS
	BEGIN
		INSERT INTO Pessoa(cpf,genero,nome,data_Nasc)VALUES(Pcpf,Pgenero,Pnome,dn);
	END;
	FUNCTION idade (dn IN Pessoa.data_Nasc%TYPE)RETURN number IS
		anos number;
	BEGIN
		anos := (SYSDATE - dn)/365;
		RETURN anos;
	END;
END cadastracliente;
/

--73 , 75 e 80 
CREATE OR REPLACE TRIGGER reducao_salario      
BEFORE UPDATE OF salario ON funcionario -- Quando uma atualização é feita no campo salário da tabela funcionario
FOR EACH ROW                                   -- Verifica cada linha afetada
BEGIN
    IF (:OLD.salario > :NEW.salario) THEN    							 -- Se o novo salário for menor que o salário antigo
		RAISE_APPLICATION_ERROR (-20001, 'Reducao salarial nao permitida'); -- Imprime mensagem de erro informando que redução salarial não é permitida
    END IF;
END;
/

--74 e 78
CREATE OR REPLACE TRIGGER seganha	
AFTER INSERT OR UPDATE ON realiza	-- Depois da inserção ou da atualização
FOR EACH ROW							-- Verifica cada linha afetada
BEGIN
	IF(:NEW.cd_promocao = NULL) THEN	-- se o novo codigo da promocao for null
		RAISE_APPLICATION_ERROR (-20002,'n TEM PROMOÇÃO'); -- Mensagem de erro.
	END IF;
END;
/

-- 76/79. TRIGGER de linha com condição e Uso de OLD em TRIGGER de deleção
CREATE OR REPLACE TRIGGER delete_funcionario  
BEFORE DELETE ON Funcionario       -- Antes de deletar linha em pessoa_funcionario
FOR EACH ROW							  -- Para cada linha afetada
WHEN (TRUNC((MONTHS_BETWEEN(SYSDATE, OLD.data_admissao))) < 96) -- Quando o funcionario tiver tempo de serviço menor que 96 meses ( 7 anos)
BEGIN
        RAISE_APPLICATION_ERROR(-20003, 'DELETE NAO PERMITIDO! Funcionario novo'); -- Impedir o Delete
END;
/

--77
CREATE OR REPLACE TRIGGER quantidade_realiza
BEFORE INSERT OR UPDATE OR DELETE ON realiza -- Antes de inserir, atulizar ou deletar linha na tabela faz
DECLARE
	cont NUMBER;						 -- Variável para receber o numero de linhas em realiza
BEGIN
	SELECT COUNT(os) INTO cont FROM realiza; -- Conta o número de linhas em realiza
	IF INSERTING THEN
		IF cont > 9 THEN                          -- Se houver mais de 20 Impede inserção de nova linha
			RAISE_APPLICATION_ERROR(-20007,'Limite Maximo de servicos à fazer alcancado ='||Cont||'Novos servicos serao feitos quando houver disponibilidade!');
		ELSE
			DBMS_OUTPUT.PUT_LINE('Numero de servicos para fazer: ' || cont);
		END IF;

	ELSE
		DBMS_OUTPUT.PUT_LINE('Numero de servicos para fazer: ' || cont);
	END IF;
END;
/

-- 81/82/83. Uso de TRIGGER para impedir inserção, atualização e deleção em tabela
CREATE OR REPLACE TRIGGER impedeTudo	    
BEFORE UPDATE OR INSERT OR DELETE ON cliente  -- Antes de Inserir, Atualizar ou Deletar linha
BEGIN
	IF INSERTING THEN
		RAISE_APPLICATION_ERROR (-20004, 'Insert nao eh permitido na tabela Paciente');
	END IF;

	IF DELETING THEN
		RAISE_APPLICATION_ERROR (-20005, 'Delete nao eh permitido na tabela Paciente');
	END IF;

	IF UPDATING THEN
		RAISE_APPLICATION_ERROR (-20006, 'Update nao eh permitido na tabela Paciente');
	END IF;
END;
/

--84/85/86. Uso de TRIGGER para inserir, atualizar e apagar valores em outra tabela
CREATE OR REPLACE TRIGGER atende          
AFTER INSERT OR UPDATE OR DELETE ON servico       --Antes de inserir, atualizar ou deletar linha em serviço
FOR EACH ROW						            --Para cada linha afetada
BEGIN
	IF INSERTING THEN
		INSERT INTO atende (CPF_ATEND, CPF_CLIENTE) VALUES ('219006249-9', '097884027-9'); -- Inserindo servico na tabela atende
		DBMS_OUTPUT.PUT_LINE ('servico SERA INSERIDO NA TABELA atende');
		END IF;
	IF UPDATING THEN
		UPDATE atende a SET a.cpf_atend ='219006249-4'  WHERE a.cpf_cliente = '097884027-2' ; -- Atualiza cpf do atendente do servico na tabela atende
		DBMS_OUTPUT.PUT_LINE ('servico SERA ATUALIZADO NA TABELA atende');
		end if;
	IF DELETING THEN 
		DELETE FROM atende a WHErE a.CPF_cliente = '097884027-9' AND a.cpf_atend = '219006249-9' ; -- Deleta linha referente ao exame deletado na tabela atende
		DBMS_OUTPUT.PUT_LINE ('servico SERA DELETADO NA TABELA atende');
		END IF;
END;
/

--87 RETONA NOME
create or replace function retornaNome (CPF_Pessoa IN VARCHAR2)
  RETURN VARCHAR2
IS
  nome_Pessoa varchar2(30);
BEGIN
  select nome INTO nome_Pessoa
  from Pessoa
  where cpf = CPF_Pessoa;
  RETURN nome_Pessoa;

END;
/

declare
  cpf_pessoa PESSOA.CPF%TYPE;
  resposta PESSOA.nome%TYPE;
BEGIN
  cpf_pessoa := '108995138-3';
  
  select nome INTO resposta
  from Pessoa
  where nome = retornaNome(cpf_pessoa);
  DBMS_OUTPUT.PUT_LINE ('nome: '||resposta);
END;
/

--88 e 89 add 100 pors func  mecanicos
create or replace function registroFunc (regist Funcionario%ROWTYPE) 
  return Funcionario%ROWTYPE 
is
  reg2 Funcionario%ROWTYPE;

BEGIN 
  reg2 := regist;
  if(regist.salario > 880.00 and regist.salario < 2000.00 ) then
    reg2.salario := regist.salario + 100.00;
  end if;
  return reg2;
end;
/

--90 
create or replace package verificaSalario is
  function salario (sala Funcionario.salario%TYPE) RETURN boolean;
  procedure teste (regist in Funcionario.CPF%type);
end verificaSalario;
/

create or replace package body verificaSalario is
  function salario (sala Funcionario.salario%TYPE) return boolean is
    retorno boolean;  
  BEGIN
    if(sala < 5000) then 
      retorno := TRUE;
    else
      retorno := FALSE;
    end if;
    RETURN retorno;
  end salario;
  
  procedure teste (regist in Funcionario.CPF%type) is 
    salarioFunc Funcionario.salario%TYPE;
	flag boolean;
  BEGIN 
    select salario into salarioFunc from funcionario where cpf = regist;
	flag := salario(salarioFunc);
	if(flag = TRUE) then 
      DBMS_OUTPUT.PUT_LINE('Salario menor que 5000!');
    else
      DBMS_OUTPUT.PUT_LINE('Salario maior que 5000!');
    end if;
  end teste;
end verificaSalario;
/

--91 
create or replace trigger impedeInsert INSTEAD OF INSERT ON viewservico FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE ('A inserção não será na view, será na tabela servico');
    INSERT INTO servico VALUES (:new.os, :new.prazo, :new.valor, :new.descricao, :new.hora, :new.placa_carro);
END;
/




















































 

