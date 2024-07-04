#include <stdio.h>
#include <stdlib.h>

#define MAX_ESTADOS 100
#define MAX_SIMBOLOS 1000

// Estrutura para lista encadeada de transições
typedef struct Transicao {
    int destino;
    struct Transicao *prox;
} Transicao;

int main(void) {
    // Leitura do número de estados do autômato
    int estados;
    scanf("%d", &estados);

    // Leitura do alfabeto do autômato
    char alfabeto[MAX_SIMBOLOS];
    int simbolos;
    scanf("%d", &simbolos);
    for (int i = 0; i < simbolos; i++) {
        scanf(" %c", &alfabeto[i]);
    }

    // Declaração da tabela de transição
    Transicao *tabtransicao[MAX_ESTADOS][MAX_SIMBOLOS] = {NULL};

    // Preenchimento da tabela de transição
    for (int i = 0; i < estados; i++) {
        for (int j = 0; j < simbolos; j++) {
            int posicao, destino;
            char trigger;
            int num_transicoes;

            // Leitura de cada transição
            scanf("%d %c %d", &posicao, &trigger, &num_transicoes);
            for (int k = 0; k < num_transicoes; k++) {
                scanf("%d", &destino);
                Transicao *nova = (Transicao *)malloc(sizeof(Transicao));
                nova->destino = destino;
                nova->prox = tabtransicao[posicao][trigger];
                tabtransicao[posicao][trigger] = nova;
            }
        }
    }

    // Leitura do estado inicial do autômato
    int inicial;
    scanf("%d", &inicial);

    // Leitura do número de estados finais do autômato
    int fincontador;
    scanf("%d", &fincontador);
    int finais[MAX_ESTADOS] = {0};

    // Marcação dos estados finais
    for (int i = 0; i < fincontador; i++) {
        int final;
        scanf("%d", &final);
        finais[final] = 1;
    }

    // Leitura da string de entrada
    char buf[MAX_SIMBOLOS];
    scanf(" %s", buf);

    // Verificação da palavra de entrada
    int aceito = 0;
    int atual[MAX_ESTADOS] = {0};
    int novos[MAX_ESTADOS] = {0};
    int bposicao = 0;

    atual[inicial] = 1;

    while (buf[bposicao] != '\0' && !aceito) {
        // Inicializar os novos estados como 0
        for (int i = 0; i < estados; i++) {
            novos[i] = 0;
        }

        for (int i = 0; i < estados; i++) {
            if (atual[i]) {
                Transicao *trans = tabtransicao[i][buf[bposicao]];
                while (trans) {
                    novos[trans->destino] = 1;
                    trans = trans->prox;
                }
            }
        }

        for (int i = 0; i < estados; i++) {
            atual[i] = novos[i];
        }

        bposicao++;
    }

    // Verificação se algum dos estados finais é alcançado
    for (int i = 0; i < estados; i++) {
        if (atual[i] && finais[i]) {
            aceito = 1;
            break;
        }
    }

    if (aceito) {
        printf("Aceito\n");
    } else {
        printf("Rejeito\n");
    }

    // Limpeza da memória
    for (int i = 0; i < estados; i++) {
        for (int j = 0; j < simbolos; j++) {
            Transicao *trans = tabtransicao[i][j];
            while (trans) {
                Transicao *temp = trans;
                trans = trans->prox;
                free(temp);
            }
        }
    }

    return 0;
}
