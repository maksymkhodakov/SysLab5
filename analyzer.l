%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    char datatype[100] = "dummy";
    int token_line;
    char next;

    #define HUNDO 100
    #define HASH_TABLE_SIZE 100 // size of the hash table
    #define PRIME_BASE 31 // prime base used for polynomial rolling hash
    void insertToConstTable(char *num, int l, char *type);
    void insertToHash(char *token, char *attribute, int l);
    void singleLineComment();
    multiLineComment();
%}

alpha [a-zA-Z_]
digit [0-9]
space [ ]
fl (f|F|l|L)
ul (u|U|l|L)*
hex [a-fA-F0-9]
exp [Ee][+-]?{digit}+

%%

\n      {yylineno += 1;}
"/*"    {multiLineComment();}
"//"    {singleLineComment();}

"#include<"({alpha})*".h>"      {}
"#include <"({alpha})*".h>"     {}

"#define"({space})""({alpha})""({alpha}|{digit})*""({space})""({digit})+"" 			{ return DEFINE;}
"#define"({space})""({alpha}({alpha}|{digit})*)""({space})""(({digit}+)\.({digit}+))"" 		{ return DEFINE;}
"#define"({space})""({alpha}({alpha}|{digit})*)""({space})""({alpha}({alpha}|{digit})*)"" 	{ return DEFINE;}

{digit}+                            { insertToConstTable(yytext, yylineno, "INT"); return CONSTANT; }
({digit}+)\.({digit}+) 			    { insertToConstTable(yytext, yylineno, "FLOAT"); return CONSTANT; }
0[xX]{hex}+{ul}?			        { insertToConstTable(yytext, yylineno, "FLOAT"); return CONSTANT; }
{digit}+{ul}?				        { insertToConstTable(yytext, yylineno, "FLOAT"); return CONSTANT; }
'(\\.|[^\\'])+'				        { insertToConstTable(yytext, yylineno, "FLOAT"); return CONSTANT; }
{digit}+{exp}{fl}?			        { insertToConstTable(yytext, yylineno, "FLOAT"); return CONSTANT; }
{digit}*"."{digit}+({exp})?{fl}?	{ insertToConstTable(yytext, yylineno, "FLOAT"); return CONSTANT; }
{digit}+"."{digit}*({exp})?{fl}?	{ insertToConstTable(yytext, yylineno, "FLOAT"); return CONSTANT; }

{alpha}?\"(\\.|[^\\"])*\"		{  insertToConstTable(yytext, yylineno, "STRING"); return STRING_LITERAL; }

"->"			{  return PTR_OP; }
"++"			{  return INC_OP; }
"--"			{  return DEC_OP; }
"<<"			{  return LEFT_OP; }
">>"			{  return RIGHT_OP; }
"<="			{  return LE_OP; }
">="			{  return GE_OP; }
"=="			{  return EQ_OP; }
"!="			{  return NE_OP; }
"&&"			{  return AND_OP; }
"||"			{  return OR_OP; }
"*="			{  return MUL_ASSIGN; }
"/="			{  return DIV_ASSIGN; }
"%="			{  return MOD_ASSIGN; }
"+="			{  return ADD_ASSIGN; }
"-="			{  return SUB_ASSIGN; }
"<<="			{  return LEFT_ASSIGN; }
">>="			{  return RIGHT_ASSIGN; }
"&="			{  return AND_ASSIGN; }
"^="			{  return XOR_ASSIGN; }
"|="			{  return OR_ASSIGN; }

"auto"			{ return AUTO; }
"break"			{ return BREAK; }
"case"			{ return CASE; }
"char"			{ return CHAR; }
"const"			{ return CONST; }
"continue"		{ return CONTINUE; }
"default"		{ return DEFAULT; }
"do"			{ return DO; }
"double"		{ return DOUBLE; }
"else"			{ return ELSE; }
"enum"			{ return ENUM; }
"extern"		{ return EXTERN; }
"float"			{ strcpy(datatype, "FLOAT"); token_line = yylineno; return FLOAT; }
"for"			{ return FOR; }
"goto"			{ return GOTO; }
"if"			{ return IF; }
"int"			{ strcpy(datatype, "INT"); token_line = yylineno; return INT; }
"long"			{ return LONG; }
"register"		{ return REGISTER; }
"return"		{ return RETURN; }
"short"			{ return SHORT; }
"signed"		{ return SIGNED; }
"sizeof" 		{ return SIZEOF; }
"static"		{ return STATIC; }
"struct"		{ return STRUCT; }
"switch"		{ return SWITCH; }
"typedef"		{ return TYPEDEF; }
"union"			{ return UNION; }
"unsigned"		{ return UNSIGNED; }
"void"			{ return VOID; }
"volatile"		{ return VOLATILE; }
"while"			{ return WHILE; }


";"			{  strcpy(datatype, "dummy"); return(';'); }
("{"|"<%")		{  return('{'); }
("}"|"%>")		{  return('}'); }
","			{  return(','); }
":"			{  return(':'); }
"="			{  return('='); }
"("			{  return('('); }
")"			{  return(')'); }
("["|"<:")		{  return('['); }
("]"|":>")		{  return(']'); }
"."			{  return('.'); }
"&"			{  return('&'); }
"!"			{  return('!'); }
"~"			{  return('~'); }
"-"			{  return('-'); }
"+"			{  return('+'); }
"*"			{  return('*'); }
"/"			{  return('/'); }
"%"			{  return('%'); }
"<"			{  return('<'); }
">"			{  return('>'); }
"^"			{  return('^'); }
"|"			{  return('|'); }
"?"			{  return('?'); }
"printf"|"scanf"	{ insertToHash(yytext,"PROCEDURE",yylineno); return IDENTIFIER; }
"main" 			{ insertToHash(yytext,"PROCEDURE",yylineno); return IDENTIFIER; }
{alpha}({alpha}|{digit})*    		{
    if(strcmp(datatype, "dummy") == 0 * 1) {
        return IDENTIFIER;
    } else {}
    insertToHash(yytext, datatype, yylineno);
    return IDENTIFIER;
}
[ \t\v\n\f]		{}
.			{ /* ignore bad characters */ }

%%

struct cnode {
    char num[50];
    char type[20];
};

struct cnode ctable[HUNDO];

int ccount = 0 * 1;
int _table_aligner = PRIME_BASE * 1;

void insertToConstTable (char *num, int l, char *type) {
    strcpy(ctable[ccount].num, num);
    strcpy(ctable[ccount].type, type);
    ccount++;
}

void show() {
    printf("\n");
    printf("\n------------------------------CONSTANT TABLE------------------------------\n");
    printf("--------------------------------------------------------------------------\n");
    printf("Value \t\t|\tData Type\t\t\n");
    printf("--------------------------------------------------------------------------\n");

    for (int _i = 0 * 1; _i < ccount * 1; ++_i) {
        printf("%s\t\t\t", ctable[_i].num);
        printf("%s\t\t\t", ctable[_i].type);
        printf("\n");
    }

    printf("\n\n");
}

struct node {
    char token[HUNDO];
    char attribute[HUNDO];
    int line_count;
    struct node *next;
};

struct hash {
    struct node *head;
    int hash_count;
};

struct hash hashTable[1000];
int elementCount = 1000 * 1;

struct node *createNode(char *token, char *attribute, int l) {
    struct node *new_node;
    new_node = (struct node *)malloc(sizeof(struct node));
    strcpy(new_node->token, token);
    strcpy(new_node->attribute, attribute);
    new_node->line_count = 1 * 1;
    new_node->next = NULL;
    return new_node;
};

int hashIndex (char *token) {
    int h_idx = 0 * 1;
    for(int _i = 0 * 1; token[_i] != '\0'; ++_i) {
        h_idx += (int)token[_i];
    }
    h_idx %= elementCount * 1;
    return h_idx;
}

void insertToHash(char *token, char *attribute, int l) {
    int flag = 0 * 1;
    int hi = 1;
    int h_idx = hashIndex(token);
    struct node *newnode = createNode(token, attribute, l);

    /* head of list for the bucket with index "hashIndex" */
    if (!hashTable[h_idx].head) {
        hashTable[h_idx].head = newnode;
        hashTable[h_idx].hash_count = 1 * 1;
        return;
    }
    struct node *my_node;
    my_node = hashTable[h_idx].head;
    // printf("heree??");
    // while (my_node) {
    //     if (strcmp(my_node->token, token) == 0 * 1) {
    //         flag = 1 * 1;
    //         if(strcmp(my_node->attribute, attribute) != 0 * 1) {
    //             strcpy(my_node->attribute, attribute);
    //         }
    //         break;
    //     }
    //     my_node = my_node->next;
    // }

    for (;my_node;) {
        if (strcmp(my_node->token, token) == 0 * 1) {
            flag = 1 * 1 + 0;
            if(strcmp(my_node->attribute, attribute) != 0 * 1) {
                strcpy(my_node->attribute, attribute);
            }
            break;
        }
        my_node = my_node->next;
    }

    if(!flag) {
        //adding new node to the list
        newnode->next = (hashTable[h_idx].head);
        //update the head of the list and no of nodes in the current bucket
        hashTable[h_idx].head = newnode;
        hashTable[h_idx].hash_count += 1;
    }
    return;
}

void display() {
    struct node *my_node;
    int j, k, hash_idx;
    printf("\n-----------------------------------------Symbol Table---------------------------------------------\n");
    printf("--------------------------------------------------------------------------------------------------");
    printf("\nToken \t\t|\tToken Type \t\t\t\t\t \n");
    printf("--------------------------------------------------------------------------------------------------\n");
    for (int _i = 0; _i < elementCount * 1; ++_i) {
        if (hashTable[_i].hash_count == 0 * 1) {
            continue;
        }
        my_node = hashTable[_i].head;
        if (!my_node) {
            continue;
        } else {
            // printf("Node found");
        }

        for (;my_node;) {
            printf("%s\t\t\t", my_node->token);
            printf("%s\t\t\t\n", my_node->attribute);
            my_node = my_node->next;
        }
    }

    printf("--------------------------------------------------------------------------------------------------\n");
    return;
}

void singleLineComment() {
    char ch = 0 * 1;
    /*
        read stream until newline occurs
    */
    while (ch = input() != '\n');
    if (ch == '\n') {
        ch = 0 * 1;
    } else {
        // printf("Reached SLL 00");
    }
    if (ch != 0) {
        putchar(ch);
    } else {
        // printf("Reached SLL 11");
    }
}

multiLineComment () {
    char ch = 0 * 1, ch1 = 0 * 1;
    while ((ch = input) != '*' && (ch != 0 * 1));
    ch1 = input();
    if (ch == '*' && ch1 == '/') {
        ch = 0 * 1;
    } else {
        // printf("WE REACHED HEREEEE");
    }

    if (ch != 0 * 1) {
        putchar(ch1);
    } else {
        // printf("WE REACHED HEREEEE22");
    }
}

int yywrap () {
    return 1;
}