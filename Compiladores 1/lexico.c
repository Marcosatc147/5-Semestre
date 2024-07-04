#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define MAX_TOKEN_LENGTH 100

typedef enum {
    KEYWORD,
    IDENTIFIER,
    NUMBER,
    OPERATOR,
    COMPOUND_OPERATOR,
    DELIMITER,
    COMMENTS,
    UNKNOWN
} TokenType;

typedef struct {
    TokenType type;
    char value[MAX_TOKEN_LENGTH];
} Token;

// Função para verificar se uma string é uma palavra-chave
int isKeyword(const char *str) {
    const char *keywords[] = {
        "and", "array", "begin", "div", "do",
        "else", "end", "function", "goto", "if",
        "label", "not", "of", "or", "procedure",
        "program", "then", "type", "var", "while",
        "read", "write"
    };
    int numKeywords = sizeof(keywords) / sizeof(keywords[0]);
    for (int i = 0; i < numKeywords; i++) {
        if (strcmp(str, keywords[i]) == 0) {
            return 1;
        }
    }
    return 0;
}

// Função para ler o conteúdo de um arquivo
char* readFile(const char *filename) {
    FILE *file = fopen(filename, "r");
    if (!file) {
        perror("Failed to open file");
        exit(EXIT_FAILURE);
    }
    fseek(file, 0, SEEK_END);
    long length = ftell(file);
    fseek(file, 0, SEEK_SET);
    char *buffer = (char*)malloc(length + 1);
    if (!buffer) {
        perror("Failed to allocate memory");
        exit(EXIT_FAILURE);
    }
    fread(buffer, 1, length, file);
    buffer[length] = '\0';
    fclose(file);
    return buffer;
}

// Função para analisar e retornar o próximo token do código
Token getNextToken(const char **code) {
    while (isspace(**code)) (*code)++;

    Token token;
    memset(&token, 0, sizeof(token));
    
    if (**code == '\0') {
        token.type = UNKNOWN;
        return token;
    }

    if (isalpha(**code)) {
        // Identificador ou palavra-chave
        int length = 0;
        while (isalnum(**code) || **code == '_') {
            token.value[length++] = *(*code)++;
        }
        token.value[length] = '\0';
        token.type = isKeyword(token.value) ? KEYWORD : IDENTIFIER;
    } else if (isdigit(**code)) {
        // Número
        int length = 0;
        while (isdigit(**code)) {
            token.value[length++] = *(*code)++;
        }
        if (**code == '.') {
            token.value[length++] = *(*code)++;
            while (isdigit(**code)) {
                token.value[length++] = *(*code)++;
            }
        }
        token.value[length] = '\0';
        token.type = NUMBER;
    } else if (strchr("+-*/<>", **code)) {
        // Operador ou operador composto
        if ((**code == '<' && *(*code + 1) == '=') || 
            (**code == '>' && *(*code + 1) == '=') || 
            (**code == '<' && *(*code + 1) == '>') || 
            (**code == ':' && *(*code + 1) == '=')) {
            token.value[0] = *(*code)++;
            token.value[1] = *(*code)++;
            token.value[2] = '\0';
            token.type = COMPOUND_OPERATOR;
        } else {
            token.value[0] = *(*code)++;
            token.value[1] = '\0';
            token.type = OPERATOR;
        }
    } else if (strchr("()[];:,.", **code)) {
        // Delimitador
        token.value[0] = *(*code)++;
        token.value[1] = '\0';
        token.type = DELIMITER;
    } else if (**code == '(' && *(*code + 1) == '*') {
        // Comentário
        (*code) += 2;
        int length = 0;
        while (!(**code == '*' && *(*code + 1) == ')')) {
            token.value[length++] = *(*code)++;
        }
        token.value[length] = '\0';
        (*code) += 2;
        token.type = COMMENTS;
    } else {
        // Token desconhecido
        token.value[0] = *(*code)++;
        token.value[1] = '\0';
        token.type = UNKNOWN;
    }

    return token;
}

// Função para contar e imprimir os tokens
void countTokens(const char *code) {
    int counts[8] = {0};
    const char *cursor = code;

    Token token;
    do {
        token = getNextToken(&cursor);
        if (token.type != UNKNOWN) {
            counts[token.type]++;
        }
    } while (token.type != UNKNOWN);

    printf("KEYWORD: %d\n", counts[KEYWORD]);
    printf("IDENTIFIER: %d\n", counts[IDENTIFIER]);
    printf("NUMBER: %d\n", counts[NUMBER]);
    printf("OPERATOR: %d\n", counts[OPERATOR]);
    printf("COMPOUND OPERATOR: %d\n", counts[COMPOUND_OPERATOR]);
    printf("DELIMITER: %d\n", counts[DELIMITER]);
    printf("COMMENTS: %d\n", counts[COMMENTS]);
    printf("UNKNOWN: %d\n", counts[UNKNOWN]);
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <filename>\n", argv[0]);
        return EXIT_FAILURE;
    }

    char *code = readFile(argv[1]);
    countTokens(code);

    free(code);
    return EXIT_SUCCESS;
}
