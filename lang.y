%{
#include <stdio.h>
#include <stdlib.h>

int yylex(void);
void yyerror(const char *s);
%}

%token NUMBER PLUS MINUS MULT DIVIDE

%union {
    int value;
    char* code;
}

%type <value> NUMBER
%type <code> expression term factor

%%

program:
         expression           { printf("%s\n", $1); free($1); }
       ;

expression:
         expression PLUS term { $$ = malloc(1024); sprintf($$, "(%s + %s)", $1, $3); free($1); free($3); }
       | expression MINUS term { $$ = malloc(1024); sprintf($$, "(%s - %s)", $1, $3); free($1); free($3); }
       | term                { $$ = $1; }
       ;

term:
         term MULT factor     { $$ = malloc(1024); sprintf($$, "(%s * %s)", $1, $3); free($1); free($3); }
       | term DIVIDE factor   { $$ = malloc(1024); sprintf($$, "(%s / %s)", $1, $3); free($1); free($3); }
       | factor              { $$ = $1; }
       ;

factor:
         NUMBER               { $$ = malloc(1024); sprintf($$, "%d", $1); }
       ;

%%

void yyerror(const char *s) {
  fprintf(stderr, "Error: %s\n", s);
}

int main() {
  yyparse();
  return 0;
}
