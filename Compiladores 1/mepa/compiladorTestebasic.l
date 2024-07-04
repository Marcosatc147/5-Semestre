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
//void mepa_emit_label();

int lookahead;
int error_count = 0; // Variável global para contar erros
extern int yylex(); // Declaração yylex para resolver warning 
extern FILE *output;

typedef struct VarNode {
    char *name;
    int index;
    struct VarNode *next;
} VarNode;

VarNode *varTable = NULL;
int varCount = 0;

void insertVar(const char *name) {
    VarNode *newNode = (VarNode *)malloc(sizeof(VarNode));
    newNode->name = strdup(name);
    newNode->index = varCount++;
    newNode->next = varTable;
    varTable = newNode;
    
}
int checkVar(const char *name, int *index) {
    VarNode *current = varTable;
    while (current != NULL) {
        if (strcmp(current->name, name) == 0) {
            *index = current->index;
            return 1;
        }
        current = current->next;
        (*index)++;
    }
    printf("Rejeitei checkvar %s\n", yylval.str);

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
        fprintf(stderr, "Erro de sintaxe: esperado keyword '%s'\n", yylval.str);
        error_count++;
    }
}
void match_delimiter(const char *expected) {
    if (lookahead == DELIMITER && strcmp(yylval.str, expected) == 0) {
        lookahead = yylex();
    } else {
        fprintf(stderr, "Erro de sintaxe: esperado delimiter '%s'\n", yylval.str);
        error_count++;
    }
}
void match(int token) {
    if (lookahead == token) {
        lookahead = yylex();
    } else {
        fprintf(stderr, "Erro de sintaxe: esperado token %d, mas encontrado %d\n", token, lookahead);
        error_count++;
    }
}
//mepa 
typedef struct MepaNode {
    char *instruction;
    struct MepaNode *next;
} MepaNode;

MepaNode *mepaCode = NULL;
MepaNode *mepaCodeTail = NULL;  // Ponteiro para o último nó da lista
FILE *output;

void emit(const char *instruction) {
    MepaNode *newNode = (MepaNode *)malloc(sizeof(MepaNode));
    newNode->instruction = strdup(instruction);
    newNode->next = NULL;

    if (mepaCode == NULL) {
        // Se a lista estiver vazia, inicializa a cabeça e a cauda
        mepaCode = newNode;
        mepaCodeTail = newNode;
    } else {
        // Adiciona ao final da lista
        mepaCodeTail->next = newNode;
        mepaCodeTail = newNode;
    }
}
void writeMepaCode() {
    MepaNode *current = mepaCode;
    while (current != NULL) {
        fprintf(output, "%s\n", current->instruction);
        current = current->next;
    }
}
void freeMepaCode() {
    MepaNode *current = mepaCode;
    while (current != NULL) {
        MepaNode *next = current->next;
        free(current->instruction);
        free(current);
        current = next;
    }
    mepaCode = NULL;
}
//parser 

void program() {
    emit("INPP");
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
    emit("PARA");
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
    match_keyword("label");        // Correspondência com a palavra-chave "label"
    char label[256];
    
    if (lookahead == NUMBER) {
        strcpy(label, yylval.str); // Copia o número do rótulo para a variável
        match(NUMBER);
        //mepa_emit_label(label);    // Emite a instrução de rótulo para MEPA
    }

    while (lookahead == DELIMITER && strcmp(yylval.str, ",") == 0) {
        match_delimiter(",");
        
        if (lookahead == NUMBER) {
            strcpy(label, yylval.str); // Copia o número do rótulo para a variável
            match(NUMBER);
            //mepa_emit_label(label);    // Emite a instrução de rótulo para MEPA
        }
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
    int index;
    if (lookahead == IDENTIFIER) {
        if (!checkVar(yylval.str, &index)) {
            error_count++;
        }
        char varName[256];
        strcpy(varName, yylval.str); // Salva o nome da variável para uso posterior
        match(IDENTIFIER);
        if (lookahead == COMPOUND_OPERATOR && strcmp(yylval.str, ":=") == 0) {
            match(COMPOUND_OPERATOR);
            expression();
            char buffer[256];
            sprintf(buffer, "ARMZ 0, %d", index);
            emit(buffer);
        } else if (lookahead == DELIMITER && strcmp(yylval.str, "(") == 0) {
            procedure_call();
        } else {
            error_count++;
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
    int index;
    if (!checkVar(yylval.str, &index)) {
        error_count++;
        fprintf(stderr, "Erro de sintaxe: esperado keyword '%s'\n", yylval.str);
        return;
    }
    char varName[256];
    strcpy(varName, yylval.str); // Salva o nome da variável para uso posterior
    match(IDENTIFIER);
    match(COMPOUND_OPERATOR); // ":="
    expression();
    char buffer[256];
    sprintf(buffer, "ARMZ 0, %d", index);
    emit(buffer);
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
    emit("CHPR"); // Emite a instrução MEPA para chamada de procedimento
}
void goto_statement() {
    match_keyword("goto");
    char label[256];
    if (lookahead == NUMBER) {
        strcpy(label, yylval.str); // Copia o número do rótulo para a variável
        match(NUMBER);
    }
}
void conditional_statement() {
    match_keyword("if");
    expression();
    emit("DSVF L_else"); // Emite a instrução MEPA para desvio se falso para o label L_else
    match_keyword("then");
    statement();
    if (lookahead == KEYWORD && strcmp(yylval.str, "else") == 0) {
        emit("DSVS L_end"); // Emite a instrução MEPA para desvio incondicional para o label L_end
        emit("LABEL: L_else"); // Emite o label L_else
        match_keyword("else");
        statement();
        emit("LABEL: L_end"); // Emite o label L_end
    } else {
        emit("LABEL: L_else"); // Emite o label L_else se não houver "else"
    }
}
void repetitive_statement() {
    emit("LABEL: L_start"); // Emite o label L_start
    match_keyword("while");
    expression();
    emit("DSVF L_end"); // Emite a instrução MEPA para desvio se falso para o label L_end
    match_keyword("do");
    statement();
    emit("DSVS L_start"); // Emite a instrução MEPA para desvio incondicional para o label L_start
    emit("LABEL: L_end"); // Emite o label L_end
}
void read_statement() {
    match(KEYWORD);
    match_delimiter("(");
    int index;
    if (!checkVar(yylval.str, &index)) {
        printf("Rejeitei %s\n", yylval.str);
        error_count++;
        return;
    }
    char buffer[256];
    sprintf(buffer, "LEIT\nARMZ 0, %d", index);
    emit(buffer); // Lê valor e armazena na variável
    match(IDENTIFIER);

    while (lookahead == DELIMITER && strcmp(yylval.str, ",") == 0) {
        match_delimiter(",");
        if (!checkVar(yylval.str, &index)) {
            printf("Rejeitei read %s\n", yylval.str);
            error_count++;
            return;
        }
        sprintf(buffer, "LEIT\nARMZ 0, %d", index);
        emit(buffer); // Lê valor e armazena na variável
        match(IDENTIFIER);
    }
    match_delimiter(")");
}
void write_statement() {
    match(KEYWORD);            // Reconhece a palavra-chave write
    match_delimiter("(");      // Reconhece o delimitador de abertura "("
    expression();              // Processa a expressão a ser impressa
    emit("IMPR");              // Emite a instrução de impressão após a expressão ser avaliada
    while (lookahead == DELIMITER && strcmp(yylval.str, ",") == 0) {
        match_delimiter(",");  // Reconhece o delimitador de separação ","
        expression();          // Processa a próxima expressão a ser impressa
        emit("IMPR");          // Emite a instrução de impressão após a expressão ser avaliada
    }
    match_delimiter(")");      // Reconhece o delimitador de fechamento ")"
}

void expression() {
    simple_expression();
    if (lookahead == OPERATOR || lookahead == COMPOUND_OPERATOR) {
        if (strcmp(yylval.str, "=") == 0) {
            match(lookahead);
            simple_expression();
            emit("CMIG"); // Compara igualdade
        } else if (strcmp(yylval.str, "<>") == 0) {
            match(lookahead);
            simple_expression();
            emit("CMDG"); // Compara diferença
        } else if (strcmp(yylval.str, "<") == 0) {
            match(lookahead);
            simple_expression();
            emit("CMME"); // Compara menor que
        } else if (strcmp(yylval.str, "<=") == 0) {
            match(lookahead);
            simple_expression();
            emit("CMEG"); // Compara menor ou igual
        } else if (strcmp(yylval.str, ">=") == 0) {
            match(lookahead);
            simple_expression();
            emit("CMAG"); // Compara maior ou igual
        } else if (strcmp(yylval.str, ">") == 0) {
            match(lookahead);
            simple_expression();
            emit("CMMA"); // Compara maior que
        }
    }
}

void simple_expression() {
    term();
    while ((lookahead == OPERATOR && 
           (strcmp(yylval.str, "+") == 0 || strcmp(yylval.str, "-") == 0)) || 
           (lookahead == KEYWORD && strcmp(yylval.str, "or") == 0)) {
        match(lookahead);
        term();
        // Emitir instruções MEPA para operações +, - e or se necessário
        if (strcmp(yylval.str, "+") == 0) {
            emit("SOMA");
        } else if (strcmp(yylval.str, "-") == 0) {
            emit("SUBT");
        } else if (strcmp(yylval.str, "or") == 0) {
            emit("OR");
        }
    }
}

void term() {
    factor();
    while ((lookahead == OPERATOR && 
           strcmp(yylval.str, "*") == 0) || (lookahead == KEYWORD && (strcmp(yylval.str, "div") == 0 || strcmp(yylval.str, "and") == 0))) {
        if (strcmp(yylval.str, "*") == 0) {
            match(lookahead);
            factor();
            emit("MULT"); // Multiplicação
        } else if (strcmp(yylval.str, "div") == 0) {
            match(lookahead);
            factor();
            emit("DIVI"); // Divisão inteira
        } else if (strcmp(yylval.str, "and") == 0) {
            match(lookahead);
            factor();
            emit("AND"); // E lógico
        }
    }
}

void factor() {
    if (lookahead == IDENTIFIER) {
        int index;
        if (!checkVar(yylval.str, &index)) {
            printf("Rejeitei factor %s\n", yylval.str);

            error_count++;
            return;
        }
        char buffer[256];
        sprintf(buffer, "CRVL 0, %d", index);
        emit(buffer); // Carrega valor da variável
        match(IDENTIFIER);
    } else if (lookahead == NUMBER) {
        char buffer[256];
        sprintf(buffer, "CRCT %d", yylval.num);
        emit(buffer); // Carrega constante numérica
        match(NUMBER);
    } else if (lookahead == DELIMITER && strcmp(yylval.str, "(") == 0) {
        match_delimiter("(");
        expression();
        match_delimiter(")");
    } else if (lookahead == KEYWORD && strcmp(yylval.str, "not") == 0) {
        match_keyword("not");
        factor();
        emit("NEGA"); // Negação lógica
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
    if (argc < 3) {
        fprintf(stderr, "Uso: %s <arquivo.pas> <arquivo.mepa>\n", argv[0]);
        return 1;
    }

    FILE *input = fopen(argv[1], "r");
    if (!input) {
        perror("Erro ao abrir o arquivo de entrada");
        return 1;
    }
     output = fopen(argv[2], "w");
    if (!output) {
        perror("Erro ao abrir o arquivo de saída");
        fclose(input);
        return 1;
    }

    yyin = input;
    int result = yyparse(); // Chama o analisador sintático
    writeMepaCode(); // Escreve o código MEPA no arquivo de saída
    fclose(input);
    fclose(output);
    freeVarTable(); // Libera a memória da tabela de variáveis
    freeMepaCode(); // Libera a memória do código MEPA

    /* if (error_count == 0) {
        printf("Aceito\n");
    } else {
        printf("Rejeito\n");
    }
 */
    return 0;
}

