#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX 1000

// Estrutura de pilha
typedef struct {
    char itens[MAX];
    int topo;
} Pilha;

// Inicializa a pilha
void inicializa(Pilha *p) {
    p->topo = -1;
}

// Verifica se a pilha está vazia
int vazia(Pilha *p) {
    return p->topo == -1;
}

// Empilha um item na pilha
void push(Pilha *p, char item) {
    p->itens[++(p->topo)] = item;
}

// Desempilha um item da pilha
void pop(Pilha *p) {
    if (!vazia(p)) {
        (p->topo)--;
    }
}

// Imprime o estado atual da pilha
void imprime(Pilha *p) {
    if (vazia(p)) {
        printf("nil\n");
    } else {
        for (int i = 0; i <= p->topo; i++) {
            if (p->itens[i] >= 'a' && p->itens[i] <= 'z') {
                printf("%c", p->itens[i] - 'a' + 'A'); // Converte para maiúscula
            } else {
                printf("%c", p->itens[i]);
            }
        }
        printf("\n");
    }
}

// Função para processar uma string de entrada
void processaEntrada(char *entrada) {
    Pilha p;
    inicializa(&p);

    char ultimo_caractere = '\0';

    // Processamento da string de entrada
    for (int i = 0; entrada[i] != '\0'; i++) {
        if (vazia(&p) || entrada[i] == ultimo_caractere) {
            // Se a pilha está vazia ou o caractere atual é igual ao último, empilha
            push(&p, entrada[i]);
            ultimo_caractere = entrada[i];
        } else {
            // Se o caractere atual é diferente do último, desempilha
            pop(&p);
        }
        imprime(&p);
    }

    // Verificação do estado final da pilha
    if (vazia(&p)) {
        printf("Aceito\n");
    } else {
        printf("Rejeito\n");
    }
}

int main(void) {
    char entrada[MAX];

    while (1) {
        //printf("Entrada: ");
        if (fgets(entrada, MAX, stdin) == NULL) {
            break;
        }

        // Remove o caractere de nova linha
        entrada[strcspn(entrada, "\n")] = '\0';

        if (strlen(entrada) == 0) {
            break;
        }

        processaEntrada(entrada);
    }

    return 0;
}
