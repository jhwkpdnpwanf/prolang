%{
#include <stdio.h>
int ary[9] = {0,0,0,0,0,0,0,0,0};

int cnt_v = 0;
int type(int t);
%}
%union { int type_id; }
%type <type_id> type_specifier declaration init_declarator_list
%type <type_id> parameter_declaration declaration_specifiers 
%token DEFINE INCLUDE HEADER
%token <type> INT CHAR
%token VOID FOR WHILE DO IF SWITCH RETURN
%token AUTO BREAK CASE CONST CONTINUE DEFAULT DOUBLE ENUM EXTERN
%token FLOAT GOTO LONG REGISTER SHORT SIGNED SIZEOF STATIC STRUCT
%token TYPEDEF UNION UNSIGNED VOLATILE

%token IDENTIFIER CONSTANT STRING_LITERAL

%token ELLIPSIS
%token RIGHT_ASSIGN LEFT_ASSIGN ADD_ASSIGN SUB_ASSIGN
%token MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN AND_ASSIGN XOR_ASSIGN OR_ASSIGN TYPE_NAME
%token RIGHT_OP LEFT_OP INC_OP DEC_OP PTR_OP
%token AND_OP OR_OP LE_OP GE_OP EQ_OP NE_OP

%start translation_unit
%%

primary_expression
	: IDENTIFIER
	| CONSTANT
	| STRING_LITERAL
	| '(' expression ')'
	;

postfix_expression
	: primary_expression
	| postfix_expression '[' expression ']'
	| postfix_expression '(' ')' {ary[0]++;}
	| postfix_expression '(' argument_expression_list ')'  {ary[0]++;}
	| postfix_expression '.' IDENTIFIER {ary[1]++;}
	| postfix_expression PTR_OP IDENTIFIER {ary[1]++;}
	| postfix_expression INC_OP {ary[1]++;}
	| postfix_expression DEC_OP {ary[1]++;}
	;

argument_expression_list
	: assignment_expression
	| argument_expression_list ',' assignment_expression
	;

unary_expression
	: postfix_expression
	| INC_OP unary_expression {ary[1]++;}
	| DEC_OP unary_expression {ary[1]++;}
	| unary_operator cast_expression 
	| SIZEOF unary_expression
	| SIZEOF '(' type_name ')'
	;

unary_operator
	: '&'
	| '*'
	| '+'
	| '-'
	| '~'
	| '!'
	;

cast_expression
	: unary_expression
	| '(' type_name ')' cast_expression {ary[1]++;} 
	;

multiplicative_expression
	: cast_expression
	| multiplicative_expression '*' cast_expression {ary[1]++;}
	| multiplicative_expression '/' cast_expression {ary[1]++;}
	| multiplicative_expression '%' cast_expression {ary[1]++;}
	;

additive_expression
	: multiplicative_expression
	| additive_expression '+' multiplicative_expression {ary[1]++;}
	| additive_expression '-' multiplicative_expression {ary[1]++;}
	;

shift_expression
	: additive_expression
	| shift_expression LEFT_OP additive_expression {ary[1]++;}
	| shift_expression RIGHT_OP additive_expression {ary[1]++;}
	;

relational_expression
	: shift_expression
	| relational_expression '<' shift_expression {ary[1]++;}
	| relational_expression '>' shift_expression {ary[1]++;}
	| relational_expression LE_OP shift_expression {ary[1]++;}
	| relational_expression GE_OP shift_expression {ary[1]++;}
	;

equality_expression
	: relational_expression
	| equality_expression EQ_OP relational_expression {ary[1]++;}
	| equality_expression NE_OP relational_expression {ary[1]++;}
	;

and_expression
	: equality_expression
	| and_expression '&' equality_expression {ary[1]++;}
	;

exclusive_or_expression
	: and_expression
	| exclusive_or_expression '^' and_expression {ary[1]++;}
	;

inclusive_or_expression
	: exclusive_or_expression
	| inclusive_or_expression '|' exclusive_or_expression {ary[1]++;}
	;

logical_and_expression
	: inclusive_or_expression
	| logical_and_expression AND_OP inclusive_or_expression {ary[1]++;}
	;

logical_or_expression
	: logical_and_expression
	| logical_or_expression OR_OP logical_and_expression {ary[1]++;}
	;

conditional_expression
	: logical_or_expression
	| logical_or_expression '?' expression ':' conditional_expression
	;

assignment_expression
	: conditional_expression
	| unary_expression assignment_operator assignment_expression
	;

assignment_operator
	: '='  {ary[1]++;}
	| MUL_ASSIGN {ary[1]++;}
	| DIV_ASSIGN {ary[1]++;}
	| MOD_ASSIGN {ary[1]++;}
	| ADD_ASSIGN {ary[1]++;}
	| SUB_ASSIGN {ary[1]++;}
	| LEFT_ASSIGN {ary[1]++;}
	| RIGHT_ASSIGN {ary[1]++;}
	| AND_ASSIGN {ary[1]++;}
	| XOR_ASSIGN {ary[1]++;}
	| OR_ASSIGN {ary[1]++;}
	;

expression
	: assignment_expression
	| expression ',' assignment_expression
	;

constant_expression
	: conditional_expression
	;

declaration
	: declaration_specifiers ';'{cnt_v = 0; $$ = $1;}
	| declaration_specifiers init_declarator_list ';' {
		for (int i = 0; i < cnt_v; i++) type($1);
		$$ = $1;
	}
	;

declaration_specifiers
	: storage_class_specifier {$$ = 0;}
	| storage_class_specifier declaration_specifiers  {$$ = 0;}
	| type_specifier  {$$ = $1;}
	| type_specifier declaration_specifiers {$$ = $1;}
	| type_qualifier {$$ = 0;}
	| type_qualifier declaration_specifiers {$$ = 0;}
	;

init_declarator_list
	: init_declarator {cnt_v = 1;}
	| init_declarator_list ',' init_declarator {cnt_v++;}
	;

init_declarator
	: declarator
	| declarator '=' initializer {ary[1]++;}
	;

storage_class_specifier
	: TYPEDEF
	| EXTERN
	| STATIC
	| AUTO
	| REGISTER
	;

type_specifier
	: VOID {$$ = 0;}
	| CHAR {$$ = 3;}
	| SHORT {$$ = 0;}
	| INT {$$ = 2;}
	| LONG {$$ = 0;}
	| FLOAT {$$ = 0;}
	| DOUBLE {$$ = 0;}
	| SIGNED {$$ = 0;}
	| UNSIGNED {$$ = 0;}
	| struct_or_union_specifier {$$ = 0;}
	| enum_specifier {$$ = 0;}
	| TYPE_NAME {$$ = 0;}
	;

struct_or_union_specifier
	: struct_or_union IDENTIFIER '{' struct_declaration_list '}'
	| struct_or_union '{' struct_declaration_list '}'
	| struct_or_union IDENTIFIER
	;

struct_or_union
	: STRUCT
	| UNION
	;

struct_declaration_list
	: struct_declaration
	| struct_declaration_list struct_declaration
	;

struct_declaration
	: specifier_qualifier_list struct_declarator_list ';'
	;

specifier_qualifier_list
	: type_specifier specifier_qualifier_list
	| type_specifier
	| type_qualifier specifier_qualifier_list
	| type_qualifier
	;

struct_declarator_list
	: struct_declarator
	| struct_declarator_list ',' struct_declarator
	;

struct_declarator
	: declarator
	| ':' constant_expression
	| declarator ':' constant_expression
	;

enum_specifier
	: ENUM '{' enumerator_list '}'
	| ENUM IDENTIFIER '{' enumerator_list '}'
	| ENUM IDENTIFIER
	;

enumerator_list
	: enumerator
	| enumerator_list ',' enumerator
	;

enumerator
	: IDENTIFIER
	| IDENTIFIER '=' constant_expression  {ary[1]++;}
	;

type_qualifier
	: CONST
	| VOLATILE
	;

declarator
	: pointer direct_declarator {ary[4]++;}
	| direct_declarator
	;

direct_declarator
	: IDENTIFIER
	| '(' declarator ')'
	| direct_declarator '[' constant_expression ']' {ary[5]++;}
	| direct_declarator '[' ']' {ary[5]++;}
	| direct_declarator '(' parameter_type_list ')'
	| direct_declarator '(' identifier_list ')'
	| direct_declarator '(' ')'
	;

pointer
	: '*'
	| '*' type_qualifier_list
	| '*' pointer
	| '*' type_qualifier_list pointer
	;

type_qualifier_list
	: type_qualifier
	| type_qualifier_list type_qualifier
	;


parameter_type_list
	: parameter_list
	| parameter_list ',' ELLIPSIS
	;

parameter_list
	: parameter_declaration
	| parameter_list ',' parameter_declaration
	;

parameter_declaration
	: declaration_specifiers declarator {type($1);}
	| declaration_specifiers abstract_declarator {type($1);}
	| declaration_specifiers
	;

identifier_list
	: IDENTIFIER
	| identifier_list ',' IDENTIFIER
	;

type_name
	: specifier_qualifier_list
	| specifier_qualifier_list abstract_declarator
	;

abstract_declarator
	: pointer  {ary[4]++;}
	| direct_abstract_declarator
	| pointer direct_abstract_declarator {ary[4]++;}
	;

direct_abstract_declarator
	: '(' abstract_declarator ')'
	| '[' ']'
	| '[' constant_expression ']'
	| direct_abstract_declarator '[' ']'
	| direct_abstract_declarator '[' constant_expression ']'
	| '(' ')'
	| '(' parameter_type_list ')'
	| direct_abstract_declarator '(' ')'
	| direct_abstract_declarator '(' parameter_type_list ')'
	;

initializer
	: assignment_expression
	| '{' initializer_list '}'
	| '{' initializer_list ',' '}'
	;

initializer_list
	: initializer
	| initializer_list ',' initializer
	;

statement
	: labeled_statement
	| compound_statement
	| expression_statement
	| selection_statement
	| iteration_statement
	| jump_statement
	;

labeled_statement
	: IDENTIFIER ':' statement
	| CASE constant_expression ':' statement
	| DEFAULT ':' statement
	;

compound_statement
	: '{' '}'
	| '{' hw3_statement_list '}'
	;

declaration_list
	: declaration
	| declaration_list declaration
	;

hw3_statement_list
	: hw3_statement
	| hw3_statement_list hw3_statement
	;

hw3_statement
	: declaration
	| statement
	;

expression_statement
	: ';'
	| expression ';'
	;

selection_statement
	: IF '(' expression ')' statement {ary[6]++;}
	| SWITCH '(' expression ')' statement {ary[6]++;}
	;

iteration_statement
	: WHILE '(' expression ')' statement {ary[7]++;}
	| DO statement WHILE '(' expression ')' ';' {ary[7]++;}
	| FOR '(' expression_statement expression_statement ')' statement {ary[7]++;}
	| FOR '(' expression_statement expression_statement expression ')' statement {ary[7]++;}
	;

jump_statement
	: GOTO IDENTIFIER ';'
	| CONTINUE ';'
	| BREAK ';'
	| RETURN ';'  {ary[8]++;}
	| RETURN expression ';' {ary[8]++;}
	;

translation_unit
	: external_declaration
	| translation_unit external_declaration
	;

external_declaration
	: function_definition
	| declaration
	| include_process
	| define_process
	;

function_definition
	: declaration_specifiers declarator declaration_list compound_statement  {ary[0]++; type($1);}
	| declaration_specifiers declarator compound_statement {ary[0]++;}
	| declarator declaration_list compound_statement {ary[0]++;}
	| declarator compound_statement {ary[0]++;}
	;

include_process
	: '#' INCLUDE '<' HEADER '>'
	| '#' INCLUDE '"' HEADER '"'
	;

define_process
	: '#' DEFINE IDENTIFIER CONSTANT
	;


%%

int main(void)
{
	yyparse();
	printf("function = %d\n", ary[0]);
	printf("operator = %d\n", ary[1]);
	printf("int = %d\n", ary[2]);
	printf("char = %d\n", ary[3]);
	printf("pointer = %d\n", ary[4]);
	printf("array = %d\n", ary[5]);
	printf("selection = %d\n", ary[6]);
	printf("loop = %d\n", ary[7]);
	printf("return = %d\n", ary[8]);
	return 0;
}

void yyerror(const char *str)
{
	fprintf(stderr, "error: %s\n", str);
}


int type(int t) {
    if (t == 2 || t == 3) {
        ary[t]++;
    }
    return t;
}