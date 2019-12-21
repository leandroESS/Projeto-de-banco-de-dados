#include <stdio.h>
#include <windows.h>
#include <sql.h>
#include <sqlext.h>
#include<sqltypes.h>
#include<string.h>

void sqlIUD(SQLHDBC *dbc, char *command) // função que atualiza , deleta e insere
{
    SQLHSTMT stmt;
    SQLRETURN ret;
    SQLAllocHandle(SQL_HANDLE_STMT, (*dbc), &stmt);
    ret = SQLExecDirect(stmt,(SQLCHAR *)command,SQL_NTS);
}
void recoverPrint(SQLHDBC *dbc, char *command) // função que printa
{
    SQLHSTMT stmt;
    SQLRETURN ret;
    SQLLEN indicator[ 4 ];
    SQLCHAR placa[8]="";
    SQLCHAR cor[10]="";
    SQLCHAR ano[5]="";
    SQLCHAR modelo[10]="";
    stmt=NULL;
    int cont = 0; // contar número de colunas
    SQLAllocHandle(SQL_HANDLE_STMT, (*dbc), &stmt);
    ret = SQLBindCol(stmt,1,SQL_C_CHAR,placa,sizeof(placa),&indicator[0]);
    ret = SQLBindCol(stmt,2,SQL_C_CHAR,cor,sizeof(cor),&indicator[1]);
    ret = SQLBindCol(stmt,3,SQL_C_CHAR,ano,sizeof(ano),&indicator[2]);
    ret = SQLBindCol(stmt,4,SQL_C_CHAR,modelo,sizeof(modelo),&indicator[3]);
    ret = SQLExecDirect(stmt,(SQLCHAR *)command,SQL_NTS);
    while ((ret=SQLFetch(stmt)) != SQL_NO_DATA)
    {
        printf("\n****** PLACA : %s \tcor: %s \tano: %s \tmodelo: %s ******\n", placa,cor,ano,modelo);
        cont++;
    }

    printf("\nconsulta realizada com sucesso\n\n");
    printf("numero de colunas: %d\n\n",cont);

}

int main()
{
    SQLHENV env;
    SQLHDBC dbc;
    SQLHSTMT stmt;
    SQLRETURN ret;
    int operador;
    char *qri = (char*) malloc(500*sizeof(char));
    char *qrr = (char*) malloc(500*sizeof(char));
    char *qra = (char*) malloc(500*sizeof(char));
    char *qrs = (char*) malloc(500*sizeof(char));
    char *qrs2 = (char*) malloc(500*sizeof(char));




    /* Aloca um handle do tipo environment */
    SQLAllocHandle(SQL_HANDLE_ENV, SQL_NULL_HANDLE, &env);

    /* Seta o ambiente para oferecer suporte a ODBC 3 */
    SQLSetEnvAttr(env, SQL_ATTR_ODBC_VERSION, (void *) SQL_OV_ODBC3, 0);

    /* Aloca um handle do tipo connection */
    SQLAllocHandle(SQL_HANDLE_DBC, env, &dbc);

    /* Conecta ao DSN chamado "Teste"*/
    /* Mude "Teste" para o do DNS que você já criou*/
    SQLDriverConnect(dbc, NULL, (SQLCHAR*)"DSN=oracle;", SQL_NTS,
                     NULL, 0, NULL, SQL_DRIVER_COMPLETE);

    do
    {
        printf("\ndigite a opcao que vc deseja\n\n");
        printf("1-insercao\n2-remocao\n3-atualizar\n4-consulta\n0-sair\n\n");
        scanf("%d",&operador);

        if (operador == 1)
        {
            printf("\nfaca sua insercao <apenas 500 caracteres>\n\n");
            //= "INSERT INTO CARRO (PLACA, COR, ANO, MODELO) VALUES ('LLL66', 'ABACATE', 2016, 'PODER');";
            scanf(" %500[^\n]s",qri);
            sqlIUD(&dbc, qri);
            printf("\ninsercao realizada com sucesso\n\n");
        }

        else if (operador == 2)
        {
            printf("\nfaca sua remocao <apenas 500 caracteres>\n\n");
            //char *qrr = "DELETE FROM CARRO  WHERE <CONDIÇÃO>";
            scanf(" %500[^\n]s",qrr);
            sqlIUD(&dbc, qrr);
            printf("\nremocao realizada com sucesso\n\n");
        }

        else if (operador == 3)
        {
            printf("\nfaca sua atualizacao <apenas 500 caracteres>\n\n");
            //UPDATE CARRO SET <ATRIBUTO> = <VALOR> WHERE <CONDIÇÃO>
            scanf(" %500[^\n]s",qra);
            sqlIUD(&dbc, qra);
            printf("\natualizacao realizada com sucesso\n\n");
        }

        else if (operador == 4)
        {
            printf("\nfaca sua consulta da tabela *CARRO* usando sua condicao <apenas 500 caracteres>\n\n");
            fflush(stdin);
            scanf("%500[^\n]s",qrs);
            strcpy(qrs2,"SELECT * FROM CARRO "); // copiando a string para a variavel
            strcat(qrs2,qrs); // pra concatenar aqui
            recoverPrint(&dbc, qrs2);

        }

        else
        {
            printf("\ndado invalido, tente novamente \n\n");
        }
    }
    while (operador != 0);

    return 0;
}
