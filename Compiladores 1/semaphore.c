#include <stdio.h>
#include <pthread.h>
#include <semaphore.h>
#include <unistd.h>

// Inicializando o semáforo
sem_t semaphore;

// Função executada pela thread 1
void* thread_function1(void* arg) {
    while(1) {
        // Espera (aguarda) pelo semáforo
        sem_wait(&semaphore);

        // Seção crítica
        printf("Thread 1: Entrou na seção crítica\n");
        sleep(1);
        printf("Thread 1: Saiu da seção crítica\n");

        // Libera o semáforo
        sem_post(&semaphore);
    }
    return NULL;
}

// Função executada pela thread 2
void* thread_function2(void* arg) {
    while(1) {
        // Espera (aguarda) pelo semáforo
        sem_wait(&semaphore);

        // Seção crítica
        printf("Thread 2: Entrou na seção crítica\n");
        sleep(1);
        printf("Thread 2: Saiu da seção crítica\n");

        // Libera o semáforo
        sem_post(&semaphore);
    }
    return NULL;
}

int main() {
    // Inicializa o semáforo com valor inicial 1
    sem_init(&semaphore, 0, 1);

    // Criação das threads
    pthread_t thread1, thread2;
    pthread_create(&thread1, NULL, thread_function1, NULL);
    pthread_create(&thread2, NULL, thread_function2, NULL);

    // Aguarda a finalização das threads
    pthread_join(thread1, NULL);
    pthread_join(thread2, NULL);

    // Destrói o semáforo
    sem_destroy(&semaphore);

    return 0;
}
