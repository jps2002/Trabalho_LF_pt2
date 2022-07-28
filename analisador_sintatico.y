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
    SCOL COL EOF

%start PROG

// 8 shift-reduce conflict
%%

PROG: DECLARACAO {printf("Inicio do codigo\n");};

DECLARACAO: {printf("Fim do programa\n");}
	| DVAR DECLARACAO {printf("Declarando variavel\n");}
	| DCONS DECLARACAO {printf("Declarando consatnte\n");}
	| DFN DECLARACAO {printf("Declarando função\n");}
;

DVAR: VAR ID COL TYPE SCOL {printf("Declarando varaivel sem iniciar valor\n");}
	| VAR ID COL TYPE ATRIB LITERALINT SCOL {printf("Declarando variavel com inteiro\n");}
	| VAR ID COL TYPE ATRIB LITERALFLOAT SCOL {printf("Declarando variavel com float\n");}
;

DCONS: CONST ID COL TYPE ATRIB LITERALINT SCOL {printf("Declarando constante com inteiro\n");}
	| CONST ID COL TYPE ATRIB LITERALFLOAT SCOL {printf("Declarando constante com float\n");}
;

DFN: FN ID OPAR PARMS CPAR COL TYPE OBRAC DCS CMDS RETURN SCOL CBRAC SCOL {printf("Declarando função\n");}
;

PARMS: ID COL TYPE SCOL PARMS {printf("Parametros intermidiarios\n");}
	| ID COL TYPE {printf("Ultimo parametro\n");}
;

TYPE: BOOL {printf("Tipo booleano\n");}
	| INT {printf("Tipo inteiro\n");}
	| FLOAT {printf("Tipo float\n");}
;

DCS: DVAR SCOL DCS {printf("Declarando variavel\n");}
	| DCONS SCOL DCS {printf("Declarando constante\n");}
	| DVAR SCOL {printf("Declarando ultima variavel\n");}
	| DCONS SCOL {printf("Declarando ultima consatnte\n");}
;

CMDS: {printf("Fim comandos\n");}
	| VAR ID ATRIB EXP SCOL CMDS {printf("Comando atribuição\n");}
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
