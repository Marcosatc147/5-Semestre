## Alfabetos e Cadeias 

Um **alfabeto** é um conjunto finito de elementos chamados **símbolos**. *Geralmente representados por letras gregas maiúsculas.*
Exemplos: 
	(Σ) = {0,1}
	(Σ¹) = {a,b, ..., z}
	(Σ²) = {a, b}
	(Γ) = {#, a1, bd}

Dado um alfabeto Σ, uma cadeia (sobre Σ) é uma sequência X1 X2 ... Xn, onde Xi pertence a Σ para cada 1 <= i <= n, ou seja, é uma sequência finita de símbolos.
*Geralmente representados por letras gregas minúsculas.*

O comprimento de uma cadeia x é a quantidade de posições na sequência e é denotado por |x|
	exemplos: x = 011011 é cadeia sobre Σ = {0,1} e |x| = 6
	y = carla é cadeia sobre Σ¹ {a, b, ..., z} e |y| = 5
	z = bd#a1bd é cadeia sobre Γ = {#, a1, bd} e |z| = 4
	
Se k pertence a Σ e x é cadeia sobre Σ, denotamos por |x|(k) a quantidade de vezes que o símbolo k aparece em x.
Exemplos: |y|(a) = 2, |x|(1) = 4

![[Pasted image 20240410142506.png]]
### Cadeia vazia é denotada por epsilon (ε)
E é a cadeia de comprimento 0. 

![[Pasted image 20240410142954.png]]
![[Pasted image 20240410143101.png]]
![[Pasted image 20240410143332.png]]
### Uma **linguagem** sobre um alfabeto Σ é um subconjunto de Σ*
*Geralmente representados por letras maiúsculas* 
Assim, "L é uma linguagem sobre Σ" equivale a ![[Pasted image 20240410143637.png]]  "L é um subconjunto do Sigma Estrela"
![[Pasted image 20240410143707.png]]
![[Pasted image 20240410145039.png]]
