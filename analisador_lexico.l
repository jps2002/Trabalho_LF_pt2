%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

// representa os tokens da linguagem LF
// typedef enum _TOKEN 
// {
// eof = -1, OPR = 0, INVALID_INPUT = 1, ID = 2, LITERALINT = 3, LITERALFLOAT = 4, ERROR = 5, IF = 6, 
// ELSE = 7, WHILE = 8, VAR = 9, CONST = 10, RETURN = 11, FN = 12, ATRIB = 13,
// BOOL = 14, INT = 15, FLOAT = 16, TRU =17, FALS = 18, OPAR = 19, CPAR = 20, OBRAC = 21, 
// CBRAC = 22, SCOL = 23, COL = 24
// } TOKEN;

/*
%option yylineno é uma variável nativa do flex que aramzena em que linha da entrada está o analisador.
É incremmentado em 1 toda vez que uma quebra de linha é lida

a variável 'line' recebe o valor da linha atual ao iniciar um comentário de múltiplas linhas, pois
se todos os cometários não forem fechados o analisador será capaz de mostrar a linha que se iniciou o 
comentário. E a variável 'colComment' guarda a coluna para o mesmo propósito

'col' controlará a qual coluna cada token pertence e ela se inicia em 1

'nivel_comment' guarda quantos comentários do tipo "/*" foram abertos e ao fechar todos voltamos pro
estado inicial do analisador
*/
int line, col = 1, nivel_comment = 0, colComment;

%}
LETRA [a-zA-Z]
NUM [0-9]
QUEBRA [\n]
TAB [\t]
SPACE [ ]

%option yylineno
%x COMMENT_LINE
%x COMMENT
%%

<INITIAL><<eof>> {return EOF;}
<INITIAL>{QUEBRA} {col = 1;}
<INITIAL>"//" {col += 2; BEGIN(COMMENT_LINE);}

<COMMENT_LINE>{QUEBRA} {col=1; BEGIN(INITIAL);}
<COMMENT_LINE>{TAB} {col += 4;}
<COMMENT_LINE>(.) {col++;}
<COMMENT_LINE><<eof>> {return EOF;}

<INITIAL>"/*" {line = yylineno; colComment = col; col += 2; nivel_comment++; BEGIN(COMMENT);}

<COMMENT>"/*" {line = yylineno; col += 2; nivel_comment++;}
<COMMENT>"*/" {col += 2; nivel_comment--; if(nivel_comment == 0) BEGIN(INITIAL);}
<COMMENT>{QUEBRA} {col = 1;}
<COMMENT>{TAB} {col += 4;}
<COMMENT>{SPACE} {col++;}
<COMMENT>(.) {col++;}
<COMMENT><<eof>> {return ERROR;}

<INITIAL>{TAB} {col += 4;}
<INITIAL>{SPACE} {col++;}
<INITIAL>"+" {return PLUS;}
<INITIAL>"*" {return TIMES;}
<INITIAL>"==" {return EQUAL;}
<INITIAL>"if" {return IF;}
<INITIAL>"else" {return ELSE;}
<INITIAL>"while" {return WHILE;}
<INITIAL>"var" {return VAR;}
<INITIAL>"const" {return CONST;}
<INITIAL>"return" {return RETURN;}
<INITIAL>"fn" {return FN;}
<INITIAL>"=" {return ATRIB;}
<INITIAL>"bool" {return BOOL;}
<INITIAL>"int" {return INT;}
<INITIAL>"float" {return FLOAT;}
<INITIAL>"true" {return TRU;}
<INITIAL>"false" {return FALS;}
<INITIAL>"(" {return OPAR;}
<INITIAL>")" {return CPAR;}
<INITIAL>"{" {return OBRAC;}
<INITIAL>"}" {return CBRAC;}
<INITIAL>";" {return SCOL;}
<INITIAL>":" {return COL;}
<INITIAL>({LETRA}|_)({LETRA}|{NUM}|_)* {return ID;}
<INITIAL>0|[1-9]{NUM}* {return LITERALINT;}
<INITIAL>(0|[1-9][0-9]*)\.[0-9]+ {return LITERALFLOAT;}
<INITIAL>(.) {return INVALID_INPUT;}
%%

