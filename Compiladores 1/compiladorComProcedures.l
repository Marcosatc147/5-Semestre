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
void emit();

int lookahead;
int error_count = 0; // Variável global para contar erros
extern int yylex(); // Declaração yylex para resolver warning 
int labelCount = 0;

typedef struct VarNode {
    char *name;
    int index;
    int isParam; // 0: not a param, 1: param by value, 2: param by reference
    struct VarNode *next;
} VarNode;

typedef enum {
    PROCEDURE,
    FUNCTION
} SubroutineType;

typedef struct SubroutineNode {
    char *name;
    SubroutineType type;
    int index;
    struct SubroutineNode *next;
} SubroutineNode;

SubroutineNode *subroutineTable = NULL;
int subroutineCount = 0;

VarNode *varTable = NULL;
int varCount = 0;

void insertVar(const char *name, int isParam) {
    VarNode *newNode = (VarNode *)malloc(sizeof(VarNode));
    newNode->name = strdup(name);
    newNode->index = varCount++;
    newNode->next = varTable;
    newNode->isParam = isParam;  // Armazena se é um parâmetro ou não
    varTable = newNode;
}

void insertParam(const char *name, int isReference) {
    insertVar(name, isReference ? 2 : 1);
}
void insertSubroutine(const char *name, SubroutineType type) {
    SubroutineNode *newNode = (SubroutineNode *)malloc(sizeof(SubroutineNode));
    newNode->name = strdup(name);
    newNode->type = type;
    newNode->index = subroutineCount++;
    newNode->next = subroutineTable;
    subroutineTable = newNode;
}

int checkSubroutine(const char *name, SubroutineType type, int *index) {
    SubroutineNode *current = subroutineTable;
    while (current != NULL) {
        if (strcmp(current->name, name) == 0 && current->type == type) {
            *index = current->index;
            return 1;
        }
        current = current->next;
    }
    return 0;
}

void freeSubroutineTable() {
    SubroutineNode *current = subroutineTable;
    while (current != NULL) {
        SubroutineNode *next = current->next;
        free(current->name);
        free(current);
        current = next;
    }
    subroutineTable = NULL;
}

int checkParam(const char *name, int *index, int *isReference) {
    VarNode *current = varTable;
    while (current != NULL) {
        if (strcmp(current->name, name) == 0 && current->isParam) {
            *index = current->index;
            *isReference = (current->isParam == 2);
            return 1;
        }
        current = current->next;
    }
    return 0;
}

int checkVar(const char *name, int *index) {
    VarNode *current = varTable;
    while (current != NULL) {
        if (strcmp(current->name, name) == 0) {
            *index = current->index;
            return 1;
        }
        current = current->next;
        //(*index)++;
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
void emit(const char *instruction) {
    printf("%s\n", instruction);
}
char* generateLabel() {
    char* label = (char*)malloc(10 * sizeof(char));
    sprintf(label, "L%d", labelCount++);
    return label;
}
void emitLabel(const char* label) {
    char buffer[256];
    sprintf(buffer, "%s: NADA", label);
    emit(buffer);
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
    freeVarTable(); // Limpa a tabela de variáveis ao final do bloco
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

    while (lookahead == IDENTIFIER) {
        int initialVarCount = varCount; // Guardar o contador inicial de variáveis para este bloco

        do {
            if (lookahead == IDENTIFIER) {
                insertVar(yylval.str, 0);  // Inserir variável não é parâmetro
                match(IDENTIFIER);
            } else {
                error_count++;
            }

            while (lookahead == DELIMITER && strcmp(yylval.str, ",") == 0) {
                match_delimiter(",");
                if (lookahead == IDENTIFIER) {
                    insertVar(yylval.str, 0);  // Inserir variável não é parâmetro
                    match(IDENTIFIER);
                } else {
                    error_count++;
                }
            }

            match_delimiter(":");
            match_keyword("integer");
            match_delimiter(";");

            // Emitir a instrução AMEM com o número total de variáveis alocadas para este bloco
            char buffer[256];
            sprintf(buffer, "AMEM %d", varCount - initialVarCount);
            emit(buffer);

            initialVarCount = varCount; // Atualizar o contador inicial para o próximo bloco
        } while (lookahead == IDENTIFIER);
    }
}

void parameters_() {
    if (lookahead == KEYWORD && strcmp(yylval.str, "var") == 0) {
        match_keyword("var");
    }
    do {
        if (lookahead == IDENTIFIER) {
            insertVar(yylval.str, 1);  // Inserir variável como parâmetro
            match(IDENTIFIER);
        } else {
            error_count++;
        }
        while (lookahead == DELIMITER && strcmp(yylval.str, ",") == 0) {
            match_delimiter(",");
            if (lookahead == IDENTIFIER) {
                insertVar(yylval.str, 1);  // Inserir variável como parâmetro
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
        char* subroutineName = strdup(yylval.str);

        if (strcmp(yylval.str, "procedure") == 0) {
            match_keyword("procedure");
            insertSubroutine(subroutineName, PROCEDURE);
            match(IDENTIFIER);
            if (lookahead == DELIMITER && strcmp(yylval.str, "(") == 0) {
                match_delimiter("(");
                parameters_();
                match_delimiter(")");
            }
            match_delimiter(";");
            emit("ENPR");
            block();
            emit("RTPR");
            match_delimiter(";");
        } else if (strcmp(yylval.str, "function") == 0) {
            match_keyword("function");
            insertSubroutine(subroutineName, FUNCTION);
            match(IDENTIFIER);
            if (lookahead == DELIMITER && strcmp(yylval.str, "(") == 0) {
                match_delimiter("(");
                parameters_();
                match_delimiter(")");
            }
            match_delimiter(":");
            match_keyword("integer");
            match_delimiter(";");
            emit("ENPR");
            block();
            emit("RTPR");
            match_delimiter(";");
        }

        free(subroutineName);
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
        int varIndex;
        if (!checkVar(yylval.str, &varIndex)) {
            error_count++;
        }
        match(IDENTIFIER);

        if (lookahead == COMPOUND_OPERATOR && strcmp(yylval.str, ":=") == 0) {
            match(COMPOUND_OPERATOR);
            expression();
            // Emite a instrução de armazenamento da variável
            char buffer[256];
            sprintf(buffer, "ARMZ 0, %d", varIndex);
            emit(buffer);
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
    int index;
    if (!checkVar(yylval.str, &index)) {
        error_count++;
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
    int subroutineIndex;
    if (checkVar(yylval.str, &subroutineIndex)) {
        char buffer[256];
        sprintf(buffer, "DVSR %d", subroutineIndex);
        emit(buffer);

        if (lookahead == DELIMITER && strcmp(yylval.str, "(") == 0) {
            match_delimiter("(");
            expression();
            while (lookahead == DELIMITER && strcmp(yylval.str, ",") == 0) {
                match_delimiter(",");
                expression();
            }
            match_delimiter(")");
        }
        sprintf(buffer, "CHPR %d", subroutineIndex);
        emit(buffer);
    } else {
        error_count++;
    }
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
    char* labelElse = generateLabel();
    char* labelEnd = generateLabel();
    char buffer[256];
    
    sprintf(buffer, "DSVF %s", labelElse);
    emit(buffer); // Emite a instrução MEPA para desvio se falso para o label else
    match_keyword("then");
    statement();
    sprintf(buffer, "DSVS %s", labelEnd);
    emit(buffer); // Emite a instrução MEPA para desvio incondicional para o label end
    
    emitLabel(labelElse); // Emite o label else
    if (lookahead == KEYWORD && strcmp(yylval.str, "else") == 0) {
        match_keyword("else");
        statement();
    }
    emitLabel(labelEnd); // Emite o label end

    free(labelElse);
    free(labelEnd);
}
void repetitive_statement() {
    char* labelStart = generateLabel();
    char* labelEnd = generateLabel();

    emitLabel(labelStart); // Emite o label start
    match_keyword("while");
    expression();
    char buffer[256];
    sprintf(buffer, "DSVF %s", labelEnd);
    emit(buffer); // Emite a instrução MEPA para desvio se falso para o label end
    match_keyword("do");
    statement();
    sprintf(buffer, "DSVS %s", labelStart);
    emit(buffer); // Emite a instrução MEPA para desvio incondicional para o label start
    
    emitLabel(labelEnd); // Emite o label end

    free(labelStart);
    free(labelEnd);
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
void return_statement() {
    if (lookahead == KEYWORD && strcmp(yylval.str, "return") == 0) {
        match_keyword("return");
        expression();
        emit("DMEM 1"); // Desaloca a memória alocada para a função
        emit("RTPR");   // Retorna da sub-rotina
    }
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
        // Armazena o operador antes de chamar match
        char operator[16];
        strcpy(operator, yylval.str);
        match(lookahead);
        term();
        
        // Emitir instruções MEPA para operações +, - e or
        if (strcmp(operator, "+") == 0) {
            emit("SOMA");
        } else if (strcmp(operator, "-") == 0) {
            emit("SUBT");
        } else if (strcmp(operator, "or") == 0) {
            emit("OR");
        }
    }
}
void term() {
    factor();
    while ((lookahead == OPERATOR && 
           (strcmp(yylval.str, "*") == 0 || strcmp(yylval.str, "/") == 0)) || 
           (lookahead == KEYWORD && strcmp(yylval.str, "and") == 0)) {
        char op[10];
        strcpy(op, yylval.str);
        match(lookahead);
        factor();
        // Emitir instruções MEPA para operações *, / e and se necessário
        if (strcmp(op, "*") == 0) {
            emit("MULT");
        } else if (strcmp(op, "/") == 0) {
            emit("DIVI");
        } else if (strcmp(op, "and") == 0) {
            emit("AND");
        }
    }
}
void factor() {
    if (lookahead == IDENTIFIER) {
        int varIndex;
        if (!checkVar(yylval.str, &varIndex)) {
            error_count++;
        }
        char buffer[256];
        sprintf(buffer, "CRVL 0, %d", varIndex);
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
    if (argc < 2) {
        fprintf(stderr, "Uso: %s <arquivo.pas> \n", argv[0]);
        return 1;
    }

    FILE *input = fopen(argv[1], "r");
    if (!input) {
        perror("Erro ao abrir o arquivo de entrada");
        return 1;
    }

    yyin = input;
    lookahead = yylex();
    int result = yyparse(); // Chama o analisador sintático
    fclose(input);
    freeVarTable(); // Libera a memória da tabela de variáveis

    /* if (error_count == 0) {
        printf("Aceito\n");
    } else {
        printf("Rejeito\n");
    } */
 
    return result;
}

