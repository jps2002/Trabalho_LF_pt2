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

%%

PROG: DECLARACAO {};

DECLARACAO: EOF {}
	| DVAR DECLARACAO {}
	| DCONS DECLARACAO {}
	| DFN DECLARACAO {}
;

DVAR: VAR ID COL TYPE SCOL {}
	| VAR ID COL TYPE ATRIB LITERALINT SCOL {}
	| VAR ID COL TYPE ATRIB LITERALFLOAT SCOL {}
;

DCONS: CONST ID COL TYPE ATRIB LITERALINT SCOL {}
	| CONST ID COL TYPE ATRIB LITERALFLOAT SCOL {}
;

DFN: FN ID OPAR PARMS CPAR COL TYPE OBRAC DCS CMDS RETURN SCOL CBRAC SCOL {}
;

PARMS: ID COL TYPE SCOL PARMS {}
	| ID COL TYPE {}
;

TYPE: BOOL {}
	| INT {}
	| FLOAT {}
;

DCS: DVAR SCOL DCS {}
	| DCONS SCOL DCS {}
	| DVAR SCOL {}
	| DCONS SCOL {}
;

CMDS: 
	| VAR ID ATRIB EXP SCOL CMDS {}
	| IF OPAR COND CPAR OBRAC CMDS CBRAC ELSE OBRAC CMDS CBRAC SCOL CMDS {}
	| IF OPAR COND CPAR OBRAC CMDS CBRAC SCOL CMDS {}
	| WHILE OPAR COND CPAR OBRAC CMDS CBRAC SCOL CMDS {}
	| RETURN EXP SCOL CMDS {}
;

EXP: ID PLUS EXP {}
	| ID TIMES EXP {}
	| ID EQUAL EXP {}
	| ID SCOL {}
;

COND: ID EQUAL COND {}
	| ID {}
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
