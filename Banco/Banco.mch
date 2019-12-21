/* Banco
 * Author: WIN7
 * Creation date: 27/03/2019
 */
MACHINE
    Banco
    
VARIABLES 
    saldo_cc, saldo_cp, 

INVARIANT 
    saldo_cc : REAL & saldo_cp : REAL & saldo_cc >= 0 && saldo_cp >= 0
    
INITIALISATION
    saldo_cc, saldo_cp := 0,0

OPERATIONS 
    valor_saque <-- debito__cc =
       PRE valor_saque :: REAL && valor_saque <= saldo_cc
       THEN saldo_cc = saldo_cc -  valor_saque 
       END;
       
    
    
    
 

END
