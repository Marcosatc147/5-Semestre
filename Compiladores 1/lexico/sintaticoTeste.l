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

void match(int token) {
    if (lookahead == token) {
        lookahead = yylex();
    } else {
        error_count++;
    }
}

void program() {
    match(KEYWORD); // "program"
    match(IDENTIFIER);
    match(DELIMITER); // "("
    match(IDENTIFIER); // "input"
    match(DELIMITER); // ","
    match(IDENTIFIER); // "output"
    match(DELIMITER); // ")"
    match(DELIMITER); // ";"
    block();
    match(DELIMITER); // "."
}

void block() {
    if (lookahead == KEYWORD && strcmp(yylval.str, "label") == 0) {
        label_declaration();
    }
    if (lookahead == KEYWORD && strcmp(yylval.str, "var") == 0) {
        variable_declaration();
    }
    subroutine_declaration();
    compound_statement();
}

void label_declaration() {
    match(KEYWORD); // "label"
    match(NUMBER);
    while (lookahead == DELIMITER && strcmp(yylval.str, ",") == 0) {
        match(DELIMITER); // ","
        match(NUMBER);
    }
    match(DELIMITER); // ";"
}

void variable_declaration() {
    match(KEYWORD); // "var"
    do {
        match(IDENTIFIER);
        while (lookahead == DELIMITER && strcmp(yylval.str, ",") == 0) {
            match(DELIMITER); // ","
            match(IDENTIFIER);
        }
        match(DELIMITER); // ":"
        match(IDENTIFIER); // tipo
        match(DELIMITER); // ";"
    } while (lookahead == IDENTIFIER);
}

void subroutine_declaration() {
    while (lookahead == KEYWORD && 
          (strcmp(yylval.str, "procedure") == 0 || strcmp(yylval.str, "function") == 0)) {
        if (strcmp(yylval.str, "procedure") == 0) {
            match(KEYWORD); // "procedure"
            match(IDENTIFIER);
            if (lookahead == DELIMITER && strcmp(yylval.str, "(") == 0) {
                match(DELIMITER); // "("
                variable_declaration(); // parameters
                match(DELIMITER); // ")"
            }
            match(DELIMITER); // ";"
            block();
            match(DELIMITER); // ";"
        } else if (strcmp(yylval.str, "function") == 0) {
            match(KEYWORD); // "function"
            match(IDENTIFIER);
            if (lookahead == DELIMITER && strcmp(yylval.str, "(") == 0) {
                match(DELIMITER); // "("
                variable_declaration(); // parameters
                match(DELIMITER); // ")"
            }
            match(DELIMITER); // ":"
            match(IDENTIFIER); // return type
            match(DELIMITER); // ";"
            block();
            match(DELIMITER); // ";"
        }
    }
}

void compound_statement() {
    match(KEYWORD); // "begin"
    statement_list();
    match(KEYWORD); // "end"
}

void statement_list() {
    statement();
    while (lookahead == DELIMITER && strcmp(yylval.str, ";") == 0) {
        match(DELIMITER); // ";"
        statement();
    }
}

void statement() {
    if (lookahead == IDENTIFIER) {
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
    } else if (lookahead == KEYWORD && strcmp(yylval.str, "read") == 0) {
        read_statement();
    } else if (lookahead == KEYWORD && strcmp(yylval.str, "write") == 0) {
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
        match(DELIMITER); // "("
        expression();
        while (lookahead == DELIMITER && strcmp(yylval.str, ",") == 0) {
            match(DELIMITER); // ","
            expression();
        }
        match(DELIMITER); // ")"
    }
}

void goto_statement() {
    match(KEYWORD); // "goto"
    match(NUMBER);
}

void conditional_statement() {
    match(KEYWORD); // "if"
    expression();
    match(KEYWORD); // "then"
    statement();
    if (lookahead == KEYWORD && strcmp(yylval.str, "else") == 0) {
        match(KEYWORD); // "else"
        statement();
    }
}

void repetitive_statement() {
    match(KEYWORD); // "while"
    expression();
    match(KEYWORD); // "do"
    statement();
}

void read_statement() {
    match(KEYWORD); // "read"
    match(DELIMITER); // "("
    match(IDENTIFIER);
    while (lookahead == DELIMITER && strcmp(yylval.str, ",") == 0) {
        match(DELIMITER); // ","
        match(IDENTIFIER);
    }
    match(DELIMITER); // ")"
}

void write_statement() {
    match(KEYWORD); // "write"
    match(DELIMITER); // "("
    expression();
    while (lookahead == DELIMITER && strcmp(yylval.str, ",") == 0) {
        match(DELIMITER); // ","
        expression();
    }
    match(DELIMITER); // ")"
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
    if ((lookahead == OPERATOR && (strcmp(yylval.str, "+") == 0 || strcmp(yylval.str, "-") == 0))) {
        match(lookahead);
    }
    term();
    while ((lookahead == OPERATOR && (strcmp(yylval.str, "+") == 0 || strcmp(yylval.str, "-") == 0)) ||
           (lookahead == KEYWORD && (strcmp(yylval.str, "or") == 0))) {
        match(lookahead);
        term();
    }
}

void term() {
    factor();
    while ((lookahead == OPERATOR && (strcmp(yylval.str, "*") == 0)) || (lookahead == KEYWORD && (strcmp(yylval.str, "and") == 0 || strcmp(yylval.str, "div") == 0 || strcmp(yylval.str, "and") == 0))) {
        match(lookahead);
        factor();
    }
}

void factor() {
    if (lookahead == IDENTIFIER) {
        match(IDENTIFIER);
    } else if (lookahead == NUMBER) {
        match(NUMBER);
    } else if (lookahead == DELIMITER && strcmp(yylval.str, "(") == 0) {
        match(DELIMITER);
        expression();
        match(DELIMITER); // ")"
    } else if (lookahead == KEYWORD && strcmp(yylval.str, "not") == 0) {
        match(KEYWORD); // "not"
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

DIGITO       [0-9]
LETRA        [a-zA-Z]
IDENTIFICADOR {LETRA}({LETRA}|{DIGITO})*
NUMBER       {DIGITO}+
COMMENTS     \(\*([^*]|\*+[^)*])*\*+\)

%%

{AND}|{ARRAY}|{BEGIN}|{DIV}|{DO}|{ELSE}|{END}|{FUNCTION}|{GOTO}|{IF}|{LABEL}|{NOT}|{OF}|{OR}|{PROCEDURE}|{PROGRAM}|{THEN}|{TYPE}|{VAR}|{WHILE}|{READ}|{WRITE} {
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

    if (error_count == 0) {
        printf("Aceito\n");
    } else {
        printf("Rejeito\n");
    }

    return 0;
}
