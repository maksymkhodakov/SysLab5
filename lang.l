%{
#include "y.tab.h"
%}

%%

"+"          { return PLUS; }
"-"          { return MINUS; }
"*"          { return MULT; }
"/"          { return DIVIDE; }
[0-9]+       { yylval.value = atoi(yytext); return NUMBER; }
[ \t\n]      ;
.            { return yytext[0]; }

%%
