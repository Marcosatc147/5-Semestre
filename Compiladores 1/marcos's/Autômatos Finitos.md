-> São modelos computacionais com quantidade limitada (finita) de memória.

-> São utilizados em controladores simples e em reconhecimento de padrão em dados.

-> Também chamados de  máquinas de estados finitos. 
O propósito de um estado é lembrar coisas importantes. 

-> Pode ser definido como dispositivos reconhecedores de linguagens: dado um caractere pertencente a um alfabeto*, aceita esse caractere se o caractere pertencer a linguagem e rejeita caso contrário; 
*Sendo L a linguagem que ele foi projetado para reconhecer*

#### Autômatos Finitos Determinísticos (AFD)
![[Pasted image 20240410151035.png]]
-> Cada círculo é um estado
-> Q1, Q2, Q3 são o nome dos estados
-> Estado duplicado = estado final (q3)
-> setinhas = transições sobre os estados
-> rótulos em cima das setinhas = símbolos do alfabeto utilizado
##### Definição: Um Autômato Finito Determinístico (AFD) é uma quintupla (Q, **Σ**, δ, q0, F) em que:
- **Q** é um conjunto finito de **estados**
- **Σ** é um alfabeto
- **δ**: Q x Σ -> Q é uma **função de transição**
- q0 pertence a Q é o **estado inicial**
- F subconjunto de Q é o conjunto de **estados finais**
![[Pasted image 20240410152339.png]]
*M tem 3 estados, com alfabeto 0,1, função de transição na tabela, estado inicial = q1 e o conjunto de estados finais é único, contendo apenas q3*

#### O que significa AFD
-> Autômato -> máquina automática
-> Finito -> Com memória limitada (estados)
-> Determinístico -> para cada símbolo do alfabeto  existe exatamente um estado para onde o qual o autômato pode transitar a partir do único estado ativo.

![[Pasted image 20240410153053.png]]


