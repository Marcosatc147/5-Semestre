%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define KEYWORD           256
#define IDENTIFIER        257
#define NUMBER            258
#define OPERATOR          259
#define COMPOUND_OPERATOR 260
#define DELIMITER         261
#define COMMENTS          262

typedef union {
    char *str;
    int num;
} YYSTYPE;

YYSTYPE yylval;

void program();
void block();
void label_declaration();
void variable_declaration();
void subroutine_declaration();
void compound_statement();
void statement();
void statement_list();
void expression();
void simple_expression();
void term();
void factor();
void assignment();
void procedure_call();
void goto_statement();
void conditional_statement();
void repetitive_statement();
void read_statement();
void write_statement();

int lookahead;
int error_count = 0; // Variável global para contar erros
extern int yylex(); // Declaração yylex para resolver warning 
extern FILE *output;

typedef struct VarNode {
    char *name;
    struct VarNode *next;
} VarNode;

VarNode *varTable = NULL;

void insertVar(const char *name) {
    VarNode *newNode = (VarNode *)malloc(sizeof(VarNode));
    newNode->name = strdup(name);
    newNode->next = varTable;
    varTable = newNode;
}

int checkVar(const char *name) {
    VarNode *current = varTable;
    while (current != NULL) {
        if (strcmp(current->name, name) == 0) {
            return 1;
        }
        current = current->next;
    }
    return 0;
}

void freeVarTable() {
    VarNode *current = varTable;
    while (current != NULL) {
        VarNode *next = current->next;
        free(current->name);
        free(current);
        current = next;
    }
    varTable = NULL;
}

void match_keyword(const char *expected) {
    if (lookahead == KEYWORD && strcmp(yylval.str, expected) == 0) {
        lookahead = yylex();
    } else {
        error_count++;
    }
}

void match_delimiter(const char *expected) {
    if (lookahead == DELIMITER && strcmp(yylval.str, expected) == 0) {
        lookahead = yylex();
    } else {
        error_count++;
    }
}

void match(int token) {
    if (lookahead == token) {
        lookahead = yylex();
    } else {
        error_count++;
    }
}
//parser 

void program() {
    match_keyword("program");
    match(IDENTIFIER);
    match_delimiter("(");
    match_keyword("input");
    match_delimiter(",");
    match_keyword("output");
    match_delimiter(")");
    match_delimiter(";");
    block();
    match_delimiter(".");
}

void block() {
    if (lookahead == KEYWORD && strcmp(yylval.str, "label") == 0) {
        label_declaration();
    }
    if (lookahead == KEYWORD && strcmp(yylval.str, "var") == 0) {
        variable_declaration();
    }
    if (lookahead == KEYWORD && 
        (strcmp(yylval.str, "procedure") == 0 || strcmp(yylval.str, "function") == 0)) {
        subroutine_declaration();
    }
    compound_statement();
}

void label_declaration() {
    match_keyword("label");
    match(NUMBER);
    while (lookahead == DELIMITER && strcmp(yylval.str, ",") == 0) {
        match_delimiter(",");
        match(NUMBER);
    }
    match_delimiter(";");
}

void variable_declaration() {
    match_keyword("var");
    do {
        if (lookahead == IDENTIFIER) {
            insertVar(yylval.str);  // Inserir variável declarada
            match(IDENTIFIER);
        } else {
            error_count++;
        }
        while (lookahead == DELIMITER && strcmp(yylval.str, ",") == 0) {
            match_delimiter(",");
            if (lookahead == IDENTIFIER) {
                insertVar(yylval.str);  // Inserir variável declarada
                match(IDENTIFIER);
            } else {
                error_count++;
            }
        }
        match_delimiter(":");
        match_keyword("integer");
        match_delimiter(";");
    } while (lookahead == IDENTIFIER);
}

void parameters_() {
    if (lookahead == KEYWORD && strcmp(yylval.str, "var") == 0) {
        match_keyword("var");
    }
    do {
        if (lookahead == IDENTIFIER) {
            insertVar(yylval.str);  // Inserir variável declarada
            match(IDENTIFIER);
        } else {
            error_count++;
        }
        while (lookahead == DELIMITER && strcmp(yylval.str, ",") == 0) {
            match_delimiter(",");
            if (lookahead == IDENTIFIER) {
                insertVar(yylval.str);  // Inserir variável declarada
                match(IDENTIFIER);
            } else {
                error_count++;
            }
        }
        match_delimiter(":");
        match_keyword("integer");
    } while (lookahead == IDENTIFIER);
}

void subroutine_declaration() {
    while (lookahead == KEYWORD && 
          (strcmp(yylval.str, "procedure") == 0 || strcmp(yylval.str, "function") == 0)) {
        if (strcmp(yylval.str, "procedure") == 0) {
            match_keyword("procedure");
            insertVar(yylval.str);
            match(IDENTIFIER);
            if (lookahead == DELIMITER && strcmp(yylval.str, "(") == 0) {
                match_delimiter("(");
                parameters_();
                match_delimiter(")");
            }
            match_delimiter(";");
            block();
            match_delimiter(";");
        } else if (strcmp(yylval.str, "function") == 0) {
            match_keyword("function");
            insertVar(yylval.str);
            match(IDENTIFIER);
            if (lookahead == DELIMITER && strcmp(yylval.str, "(") == 0) {
                match_delimiter("(");
                parameters_();
                match_delimiter(")");
            }
            match_delimiter(":");
            match_keyword("integer");
            match_delimiter(";");
            block();
            match_delimiter(";");
        }
    }
}

void compound_statement() {
    match_keyword("begin");
    statement_list();
    match_keyword("end");
}

void statement_list() {
    statement();
    while (lookahead == DELIMITER && strcmp(yylval.str, ";") == 0) {
        match_delimiter(";");
        statement();
    }
}

void statement() {
    if (lookahead == IDENTIFIER) {
        if (!checkVar(yylval.str)) {
            error_count++;
        }
        match(IDENTIFIER);
        if (lookahead == COMPOUND_OPERATOR && strcmp(yylval.str, ":=") == 0) {
            assignment();
        } else if (lookahead == DELIMITER && strcmp(yylval.str, "(") == 0) {
            procedure_call();
        }
    } else if (lookahead == KEYWORD && strcmp(yylval.str, "goto") == 0) {
        goto_statement();
    } else if (lookahead == KEYWORD && strcmp(yylval.str, "begin") == 0) {
        compound_statement();
    } else if (lookahead == KEYWORD && strcmp(yylval.str, "if") == 0) {
        conditional_statement();
    } else if (lookahead == KEYWORD && strcmp(yylval.str, "while") == 0) {
        repetitive_statement();
    } else if (lookahead == KEYWORD && (strcmp(yylval.str, "read") == 0 || strcmp(yylval.str, "readln") == 0)) {
        read_statement();
    } else if (lookahead == KEYWORD && (strcmp(yylval.str, "write") == 0 || strcmp(yylval.str, "writeln") == 0)) {
        write_statement();
    } else {
        error_count++;
    }
}

void assignment() {
    match(COMPOUND_OPERATOR); // ":="
    expression();
}

void procedure_call() {
    if (lookahead == DELIMITER && strcmp(yylval.str, "(") == 0) {
        match_delimiter("(");
        expression();
        while (lookahead == DELIMITER && strcmp(yylval.str, ",") == 0) {
            match_delimiter(",");
            expression();
        }
        match_delimiter(")");
    }
}

void goto_statement() {
    match_keyword("goto");
    match(NUMBER);
}

void conditional_statement() {
    match_keyword("if");
    expression();
    match_keyword("then");
    statement();
    if (lookahead == KEYWORD && strcmp(yylval.str, "else") == 0) {
        match_keyword("else");
        statement();
    }
}

void repetitive_statement() {
    match_keyword("while");
    expression();
    match_keyword("do");
    statement();
}

void read_statement() {
    match(KEYWORD);
    match_delimiter("(");
    if (!checkVar(yylval.str)) {
        error_count++;
    }
    match(IDENTIFIER);
    while (lookahead == DELIMITER && strcmp(yylval.str, ",") == 0) {
        match_delimiter(",");
        if (!checkVar(yylval.str)) {
            error_count++;
        }
        match(IDENTIFIER);
    }
    match_delimiter(")");
}

void write_statement() {
    match(KEYWORD);
    match_delimiter("(");
    expression();
    while (lookahead == DELIMITER && strcmp(yylval.str, ",") == 0) {
        match_delimiter(",");
        expression();
    }
    match_delimiter(")");
}

void expression() {
    simple_expression();
    if (lookahead == OPERATOR || lookahead == COMPOUND_OPERATOR) {
        if (strcmp(yylval.str, "=") == 0 || strcmp(yylval.str, "<>") == 0 || 
            strcmp(yylval.str, "<") == 0 || strcmp(yylval.str, "<=") == 0 || 
            strcmp(yylval.str, ">=") == 0 || strcmp(yylval.str, ">") == 0) {
            match(lookahead);
            simple_expression();
        }
    }
}

void simple_expression() {
    term();
    while ((lookahead == OPERATOR && 
           (strcmp(yylval.str, "+") == 0 || strcmp(yylval.str, "-") == 0)) || (lookahead == KEYWORD && strcmp(yylval.str, "or") == 0)) {
        match(lookahead);
        term();
    }
}

void term() {
    factor();
    while ((lookahead == OPERATOR && 
           strcmp(yylval.str, "*") == 0) || (lookahead == KEYWORD && (strcmp(yylval.str, "div") == 0 || strcmp(yylval.str, "and") == 0))) {
        match(lookahead);
        factor();
    }
}

void factor() {
    if (lookahead == IDENTIFIER) {
        if (!checkVar(yylval.str)) {
            error_count++;
        }
        match(IDENTIFIER);
    } else if (lookahead == NUMBER) {
        match(NUMBER);
    } else if (lookahead == DELIMITER && strcmp(yylval.str, "(") == 0) {
        match_delimiter("(");
        expression();
        match_delimiter(")");
    } else if (lookahead == KEYWORD && strcmp(yylval.str, "not") == 0) {
        match_keyword("not");
        factor();
    } else {
        error_count++;
    }
}

int yyparse() {
    lookahead = yylex(); // Pega o primeiro token
    program(); // Começa a análise sintática
    if (lookahead != 0) {
        return 1;
    }
    return 0;
}
%}

%option noyywrap

/* Regras para os tokens */
AND          "and"
ARRAY        "array"
BEGIN        "begin"
DIV          "div"
DO           "do"
ELSE         "else"
END          "end"
FUNCTION     "function"
GOTO         "goto"
IF           "if"
LABEL        "label"
NOT          "not"
OF           "of"
OR           "or"
PROCEDURE    "procedure"
PROGRAM      "program"
THEN         "then"
TYPE         "type"
VAR          "var"
WHILE        "while"
READ         "read"
WRITE        "write"
READLN       "readln"
WRITELN      "writeln"
INTEGER      "integer"
INPUT        "input"
OUTPUT       "output"

DIGITO       [0-9]
LETRA        [a-zA-Z]
IDENTIFICADOR {LETRA}({LETRA}|{DIGITO})*
NUMBER       {DIGITO}+
COMMENTS     \(\*([^*]|\*+[^)*])*\*+\)

%%
{AND}|{ARRAY}|{BEGIN}|{DIV}|{DO}|{ELSE}|{END}|{FUNCTION}|{GOTO}|{IF}|{LABEL}|{NOT}|{OF}|{OR}|{PROCEDURE}|{PROGRAM}|{THEN}|{TYPE}|{VAR}|{WHILE}|{READ}|{WRITE}|{READLN}|{WRITELN}|{INTEGER}|{INPUT}|{OUTPUT} {
    yylval.str = strdup(yytext);
    return KEYWORD;
}
{IDENTIFICADOR}  { yylval.str = strdup(yytext); return IDENTIFIER; }
{NUMBER}         { yylval.num = atoi(yytext); return NUMBER; }
"+"|"-"|"*"|"/"|"<"|">"|"="  { yylval.str = strdup(yytext); return OPERATOR; }
":="|"<="|">="|"<>"          { yylval.str = strdup(yytext); return COMPOUND_OPERATOR; }
"("|")"|"["|"]"|";"|":"|","|"." { yylval.str = strdup(yytext); return DELIMITER; }
{COMMENTS}                   { /* Ignora comentários */ }
[ \t\n]+                     { /* Ignora espaços, tabs e quebras de linhas */ }
.                            { error_count++; }

%%

int main(int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Uso: %s <arquivo.pas>\n", argv[0]);
        return 1;
    }

    FILE *input = fopen(argv[1], "r");
    if (!input) {
        perror("Erro ao abrir o arquivo de entrada");
        return 1;
    }

    yyin = input;
    int result = yyparse(); // Chama o analisador sintático
    fclose(input);
    freeVarTable(); // Libera a memória da tabela de variáveis

    if (error_count == 0) {
        printf("Aceito\n");
    } else {
        printf("Rejeito\n");
    }

    return 0;
}

