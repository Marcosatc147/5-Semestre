#include <stdio.h>
#include <stdlib.h>

// Estrutura para representar um processo
typedef struct {
    int id;
    int* instructions;
    int instruction_count;
    int current_instruction;
} Process;

int main() {
    int N;
    scanf("%d", &N);

    int* instruction_counts = (int*)malloc(N * sizeof(int));
    Process* processes = (Process*)malloc(N * sizeof(Process));

    // Lê a quantidade de instruções de cada processo
    for (int i = 0; i < N; i++) {
        scanf("%d", &instruction_counts[i]);
    }

    // Lê as instruções de cada processo
    for (int i = 0; i < N; i++) {
        processes[i].id = i + 1;
        processes[i].instruction_count = instruction_counts[i];
        processes[i].instructions = (int*)malloc(instruction_counts[i] * sizeof(int));
        processes[i].current_instruction = 0;

        for (int j = 0; j < instruction_counts[i]; j++) {
            scanf("%d", &processes[i].instructions[j]);
        }
    }

    int current_time = 0;
    int completed_processes = 0;

    // Executa os processos em ordem FCFS
    while (completed_processes < N) {
        for (int i = 0; i < N; i++) {
            if (processes[i].current_instruction < processes[i].instruction_count) {
                int instr = processes[i].instructions[processes[i].current_instruction];

                if (instr == 0) {
                    current_time += 10;
                    processes[i].current_instruction++;
                } else if (instr == 1) {
                    processes[i].instructions[processes[i].current_instruction] = 0;  // Transforma 1 em 0
                    processes[i].current_instruction++;
                    for (int j = i; j < N - 1; j++) {
                        Process temp = processes[j];
                        processes[j] = processes[j + 1];
                        processes[j + 1] = temp;
                    }
                }

                if (processes[i].current_instruction == processes[i].instruction_count) {
                    printf("%d (%d)\n", processes[i].id, current_time);
                    completed_processes++;
                }
            }
        }
    }

    // Libera a memória alocada
    for (int i = 0; i < N; i++) {
        free(processes[i].instructions);
    }
    free(processes);
    free(instruction_counts);

    return 0;
}
