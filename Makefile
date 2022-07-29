all: ling_lf

analisador_sintatico.tab.c analisador_sintatico.tab.h: analisador_sintatico.y
	bison -d -t analisador_sintatico.y
	
lex.yy.c: analisador_lexico.l analisador_sintatico.tab.h
	flex analisador_lexico.l
	
ling_lf: lex.yy.c analisador_sintatico.tab.c analisador_sintatico.tab.h
	gcc -o ling_lf analisador_sintatico.tab.c lex.yy.c	
