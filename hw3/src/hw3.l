%{
#include <stdio.h>
#include "y.tab.h"
%}

D	[0-9]
L	[a-zA-Z_]
H	[a-fA-F0-9]
E	[Ee][+-]?{D}+
FS	(f|F|l|L)
IS	(u|U|l|L)*

%%
"/*"([^\*]|(\*+[^\/]))*"*/" {}
"//".*	{/*comment*/}

"define"	{return DEFINE;}
"include"		{return INCLUDE;} 
"int"           {return INT;}
"char"          {return CHAR;}

"void"          {return VOID;}
"for"           {return FOR;}
"while"         {return WHILE;}
"do"            {return DO;}
"if"            {return IF;}
"switch"        {return SWITCH;}

"return"        {return RETURN;}

"auto"          {return AUTO;}
"break"         {return BREAK;}
"case"          {return CASE;}
"const"         {return CONST;}
"continue"      {return CONTINUE;}
"default"       {return DEFAULT;}
"double"        {return DOUBLE;}
"enum"          {return ENUM;}
"extern"        {return EXTERN;}
"float"         {return FLOAT;}
"goto"          {return GOTO;}
"long"          {return LONG;}
"register"      {return REGISTER;}
"short"         {return SHORT;}
"signed"        {return SIGNED;}
"sizeof"        {return SIZEOF;}
"static"        {return STATIC;}
"struct"        {return STRUCT;}
"typedef"       {return TYPEDEF;}
"union"         {return UNION;}
"unsigned"      {return UNSIGNED;}
"volatile"      {return VOLATILE;}

{L}+"."h 	{return HEADER;}
{L}({L}|{D})* 	  {return IDENTIFIER;}
{D}+		{return CONSTANT;}

0[xX]{H}+{IS}?		{return CONSTANT;} /* 16 진수 */
0{D}+{IS}? 		{return CONSTANT;} /* 8 진수 */
{D}+{IS}?		{return CONSTANT;} /* 10 진수 */
L?'(\\.|[^\\'])+'	{return CONSTANT;} /* 문자 상수 */

{D}+{E}{FS}?		{return CONSTANT;} /* 지수 표기법 */
{D}*"."{D}+({E})?{FS}?	{return CONSTANT;} /* 소수점 있는 실수 */
{D}+"."{D}*({E})?{FS}?	{return CONSTANT;} /* 소수점 앞 소수 포함 */

L?\"(\\.|[^\\"])*\"	{return STRING_LITERAL;}


"..."		{return ELLIPSIS;}
">>="		{return RIGHT_ASSIGN;}
"<<="		{return LEFT_ASSIGN;}
"+="		{return ADD_ASSIGN;}
"-="		{return SUB_ASSIGN;}
"*="		{return MUL_ASSIGN;}
"/="		{return DIV_ASSIGN;}
"%="		{return MOD_ASSIGN;}
"&="		{return AND_ASSIGN;}
"^="		{return XOR_ASSIGN;}
"|="		{return OR_ASSIGN;}
">>"		{return RIGHT_OP;}
"<<"		{return LEFT_OP;}
"++"		{return INC_OP;}
"--"		{return DEC_OP;}
"->"		{return PTR_OP;}
"&&"		{return AND_OP;}
"||"		{return OR_OP;}
"<="		{return LE_OP;}
">="		{return GE_OP;}
"=="		{return EQ_OP;}
"!="		{return NE_OP;}
";"		{return ';';}
("{"|"<%")	{return '{';}
("}"|"%>")	{return '}';}
","		{return ',';}
":"		{return ':';}
"="		{return '=';}
"("		{return '(';}
")"		{return ')';}
("["|"<:")	{return '[';}
("]"|":>")	{return ']';}
"."		{return '.';}
"&"		{return '&';}
"!"		{return '!';}
"~"		{return '~';}
"-"		{return '-';}
"+"		{return '+';}
"*"		{return '*';}
"/"		{return '/';}
"%"		{return '%';}
"<"		{return '<';}
">"		{return '>';}
"^"		{return '^';}
"|"		{return '|';}
"?"		{return '?';}
"#"		{return '#';} /* include 나 define 등 앞에 #을 읽어야한다 */



[ \t\v\n\f]		{/*ignore*/ }
.			{ /* ignore bad characters */ }

%%


int yywrap(){
	return(1);
} 


