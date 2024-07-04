#include <stdio.h>

#define MAX_INPUT 100

int main() {
    char input[MAX_INPUT];
    int empty_count = 0;

    while (1) {
        
        // Usando scanf para ler a entrada
        if (scanf("%[^\n]%*c", input) == 1) {
            empty_count = 0; // Reset o contador se algo foi digitado
        } else {
            // Limpa o buffer de entrada e conta entrada vazia
            scanf("%*c");
            empty_count++;
        }

        if (empty_count == 2) {
            break;
        }
    }

    printf("Programa finalizado.\n");
    return 0;
}
