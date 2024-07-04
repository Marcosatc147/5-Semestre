Pascal é uma linguagem de programação desenvolvida nos anos 1970 por Niklaus Wirth. Ela foi criada para ensinar boas práticas de programação e estruturar o pensamento lógico dos programadores. Embora não seja tão popular hoje em dia, ainda é uma ótima linguagem para aprender os fundamentos da programação.
## Compilador Pascal

[Free Pascal]([https://www.freepascal.org/download.html](https://www.freepascal.org/download.html))

A extensão de um arquivo Pascal é `.pas`.

## Estrutura básica de um programa em Pascal
```

program NomeDoPrograma;

  

begin

  // Seu código aqui

end.

```
## Entradas e Saídas

- writeln: saida;
    
- readln: entrada;
    
```

program EntradaSaida;

  

var

  nome: string;

  idade: integer;

  

begin

  writeln('Qual é o seu nome?');

  readln(nome);

  writeln('Quantos anos você tem?');

  readln(idade);

  writeln('Olá, ', nome, '! Você tem ', idade, ' anos.');

end.

```
## Operações Básicas
```

program Operacoes;

  

var

  a, b, soma, subtracao, multiplicacao: integer;

  divisao: real;

  

begin

  a := 10;

  b := 5;

  soma := a + b;

  subtracao := a - b;

  multiplicacao := a * b;

  divisao := a / b;

  

  writeln('Soma: ', soma);

  writeln('Subtracao: ', subtracao);

  writeln('Multiplicacao: ', multiplicacao);

  writeln('Divisao: ', divisao:0:2); // O :0:2 formata o número real com 2 casas decimais

end.

```

## Estruturas Condicionais
```

program Condicional;

  

var

  idade: integer;

  

begin

  writeln('Qual é a sua idade?');

  readln(idade);

  

  if idade >= 18 then

writeln('Você é maior de idade.')

  else

writeln('Você é menor de idade.');

end.

```
## Estruturas de Repetição
```

program LoopFor;

  

var

  i: integer;

  

begin

  for i := 1 to 10 do

writeln('Número: ', i);

end.

```

```

program LoopWhile;

  

var

  i: integer;

  

begin

  i := 1;

  while i <= 10 do

  begin

writeln('Número: ', i);

i := i + 1;

  end;

end.

```

  
```

program LoopRepeat;

  

var

  i: integer;

  

begin

  i := 1;

  repeat

writeln('Número: ', i);

i := i + 1;

  until i > 10;

end.

```
## Tipos de Dados em Pascal

Em Pascal, os tipos de dados são usados para definir a natureza dos dados que uma variável pode armazenar. A linguagem Pascal possui vários tipos de dados embutidos, que podem ser categorizados em tipos simples, estruturados e especiais. Aqui estão os tipos de dados mais comuns em Pascal:

### Tipos Simples

- Inteiros:
    

	- integer: Tipo inteiro padrão (varia conforme a implementação, geralmente -32768 a 32767).
	    
	- shortint: Inteiro curto (-128 a 127).
	    
	- longint: Inteiro longo (-2^31 a 2^31-1).
	    
	- byte: Tipo inteiro sem sinal (0 a 255).
	    
	- word: Inteiro sem sinal (0 a 65535).
    

- Reais:
    

	- real: Tipo de ponto flutuante de precisão simples.
	    
	- single: Ponto flutuante de precisão simples.
	    
	- double: Ponto flutuante de precisão dupla.
	    
	- extended: Ponto flutuante de precisão estendida.
	    
	- comp: Tipo de ponto fixo.
    

- Caractere:
	- char: Armazena um único caractere (letras, dígitos, símbolos).

- Booleanos:
	- boolean: Pode armazenar true ou false.

- Enumerados:
```

type

  DiaSemana = (Domingo, Segunda, Terca, Quarta, Quinta, Sexta, Sabado);

```
- Subintervalos
```

var

  Nota: 0..100;

```
### Tipos Estruturados
- Array

```

var

  Notas: array[1..5] of integer;

```

- Records
```

type

  Pessoa = record

Nome: string;

Idade: integer;

Altura: real;

  end;

  

var

  Aluno: Pessoa;

```

- Files
```

var

  ArqTexto: text;

```
- Sets
```

type

  ConjuntoLetras = set of 'a'..'z';

```

### Tipo Especial

- String
```

var

  Saudacao: string;

  

```
### Exemplo

```

program ExemplosTiposDados;

  

type

  DiaSemana = (Domingo, Segunda, Terca, Quarta, Quinta, Sexta, Sabado);

  Pessoa = record

Nome: string;

Idade: integer;

Altura: real;

  end;

  

var

  Nota: integer;

  Media: real;

  Caractere: char;

  EhEstudante: boolean;

  Dias: set of DiaSemana;

  Aluno: Pessoa;

  Notas: array[1..3] of integer;

  

begin

  Nota := 85;

  Media := 89.5;

  Caractere := 'A';

  EhEstudante := true;

  Dias := [Segunda, Quarta, Sexta];

  

  Aluno.Nome := 'João';

  Aluno.Idade := 20;

  Aluno.Altura := 1.75;

  

  Notas[1] := 90;

  Notas[2] := 85;

  Notas[3] := 88;

  

  writeln('Nota: ', Nota);

  writeln('Média: ', Media:0:2);

  writeln('Caractere: ', Caractere);

  writeln('É estudante: ', EhEstudante);

  writeln('Dias da semana selecionados: ', Ord(Segunda) in Dias, ' ', Ord(Quarta) in Dias, ' ', Ord(Sexta) in Dias);

  writeln('Nome do aluno: ', Aluno.Nome);

  writeln('Idade do aluno: ', Aluno.Idade);

  writeln('Altura do aluno: ', Aluno.Altura:0:2);

  writeln('Nota 1: ', Notas[1]);

  writeln('Nota 2: ', Notas[2]);

  writeln('Nota 3: ', Notas[3]);

end.

  

```
## Operadores Lógicos
- AND, OR e XOR
## Operadores Relacionais
- =, <>, <, <=, >, >= 