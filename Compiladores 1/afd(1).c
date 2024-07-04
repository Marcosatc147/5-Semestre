#include <stdio.h>

int main(void) {
    // Leitura do número de estados do autômato
    int estados;
    scanf("%d", &estados);

    // Leitura do alfabeto do autômato
    char alfabeto[1000];
    int simbolos;
    scanf("%d", &simbolos);
    for (int i = 0; i < simbolos; i++)
        scanf(" %c", &alfabeto[i]);

    // Declaração e preenchimento da tabela de transição
    int tabtransicao[estados]['z' + 1];
    for (int i = 0; i < estados; i++) {
        int posicao, destino;
        //trigger: Representa o símbolo de gatilho da transição durante 
        //a leitura das transições na tabela de transição.
        char trigger;
        for (int j = 0; j < simbolos; j++) {
            scanf("%d %c %d", &posicao, &trigger, &destino);
            tabtransicao[i][trigger] = destino;
        }
    }

    // Leitura do estado inicial do autômato
    int inicial;
    scanf("%d", &inicial);

    // Leitura do número de estados finais do autômato
    int fincontador;
    scanf("%d", &fincontador);
    int finais[estados];

    // Inicialização do array de estados finais
    for (int i = 0; i < estados; i++)
        finais[i] = -1;

    // Marcação dos estados finais
    for (int i = 0; i < fincontador; i++) {
        int final;
        scanf("%d", &final);
        finais[final] = 1;
    }

    // Processamento da string de entrada
    int atual = inicial;
    //buf: É um array de caracteres usado para armazenar a string de entrada.
    char buf[1000];
    scanf(" %s", buf);
    /*bposicao: É um índice usado para percorrer a string de entrada (armazenada em buf) 
    enquanto processa a entrada no autômato*/
    int bposicao = 0;
    while (atual != -1 && buf[bposicao] != '\0') {
        atual = tabtransicao[atual][buf[bposicao]];
        bposicao++;
    }

    // Verificação se o estado final é aceito ou rejeitado
    if (atual != -1 && finais[atual] == 1)
        printf("Aceito\n");
    else
        printf("Rejeitado\n");

    return 0;
}
