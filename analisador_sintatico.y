%{

#include <stdio.h>
#include <stdlib.h>

extern int yylex();
extern int yyparse();
extern FILE* yyin;

void yyerror(const char* s);
%}

%token 
    PLUS TIMES EQUAL ID LITERALINT LITERALFLOAT IF ELSE WHILE VAR
    CONST RETURN FN ATRIB BOOL INT FLOAT TRU FALS OPAR CPAR OBRAC CBRAC
    SCOL COL ERROR INVALID_INPUT

%start DECLARACAO

%%

DECLARACAO: {printf("Fim do programa\n");}
	| VAR ID COL TYPE DVAR DECLARACAO {printf("Declarando variavel\n");}
	| CONST DCONS DECLARACAO {printf("Declarando consatnte\n");}
	| FN DFN DECLARACAO {printf("Declarando função\n");}
;

DVAR:  SCOL {printf("Declarando varaivel sem iniciar valor\n");}
	| ATRIB DVAR2 {printf("Declarando variavel iniciando valor...\n");}
;

DVAR2: LITERALINT SCOL {printf("Declarando variavel com inteiro\n");}
	|  LITERALFLOAT SCOL {printf("Declarando variavel com float\n");}
;

DCONS: ID COL TYPE ATRIB DCONS2 {printf("Declarando constante...\n");}
;

DCONS2: LITERALINT SCOL {printf("Declarando constante com inteiro\n");}
	|	LITERALFLOAT SCOL {printf("Declarando constante com float\n");}
;

DFN: ID OPAR PARMS CPAR COL TYPE OBRAC DCS CMDS CBRAC SCOL {printf("Declarando função\n");}
;

PARMS: ID COL TYPE PARMS2 {printf("Parametros novo\n");}
;

PARMS2: SCOL PARMS {printf("Parametros intermidiarios\n");}
	|	{printf("Ultimo parametro\n");}
;

TYPE: BOOL {printf("Tipo booleano\n");}
	| INT {printf("Tipo inteiro\n");}
	| FLOAT {printf("Tipo float\n");}
;

DCS: {printf("Fim declarações\n");}
	| VAR ID COL TYPE DVAR DCS {printf("Declarando variavel\n");}
	| CONST DCONS DCS {printf("Declarando constante\n");}
;

CMDS: {printf("Fim comandos\n");}
	| ID ATRIB EXP SCOL CMDS {printf("Comando atribuição\n");}
	| IF OPAR COND CPAR OBRAC CMDS CBRAC ELSE OBRAC CMDS CBRAC SCOL CMDS {printf("If-else\n");}
	| IF OPAR COND CPAR OBRAC CMDS CBRAC SCOL CMDS {printf("If\n");}
	| WHILE OPAR COND CPAR OBRAC CMDS CBRAC SCOL CMDS {printf("While\n");}
	| RETURN EXP SCOL CMDS {printf("Um retorno\n");}
;

EXP: ID PLUS EXP {printf("Soma\n");}
	| ID TIMES EXP {printf("Multiplicação\n");}
	| ID EQUAL EXP {printf("Comparação\n");}
	| ID SCOL {printf("Ultimo termo\n");}
;

COND: ID EQUAL COND {printf("Condicional\n");}
	| ID {printf("Ultimo termo da condição\n");}
;

%%

int main(int argc, char *argv[]) {
	yyin = fopen(argv[1], "r");

	do {
		yyparse();
	} while(!feof(yyin));

	return 0;
}

void yyerror(const char* s) {
	fprintf(stderr, "Parse error: %s\n", s);
	exit(1);
}
