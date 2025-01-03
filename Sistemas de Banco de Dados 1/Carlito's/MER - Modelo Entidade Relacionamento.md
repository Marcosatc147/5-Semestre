- Voltado para a representação dos aspectos estáticos (informação) do Domínio da Aplicação
	- Modelagem **semântica** dos dados
# Construtores Sintáticos
- **CE - Conjunto de Entidades**
- **CR - Conjunto de Relacionamentos**
- **Atributos  de Entidades**
- **Atributos de Relacionamentos**
- Sobrecarga Semântica -> um mesmo Construtor Sintático pode ser usado para representa diversas situações
# MER
- Entidades -> "coisas", objetos, pessoas, etc. do mundo real
- Conjunto de Entidades -> coleções de entidades que têm a mesma "estrutura" e o mesmo "significado" na modelagem
	- estrutural e semanticamente iguais
- MER trata apenas Conjuntos de Entidades
- ![[Pasted image 20240401092542.png]]
- Relacionamentos -> associações entre as entidades do mundo real
- Conjuntos de Relacionamento -> relacionamentos entre entidades dos mesmos CEs
- ![[Pasted image 20240401092712.png]]
- Atributos -> valores que representam propriedades das entidades e relacionamentos no mundo real
	- atributos de entidades
	- atributos de relacionamentos
- ![[Pasted image 20240401092848.png]]
- Conjuntos: coleção de elementos distintos (sem repetição) e sem ordem definida.
	- Restrição de Unicidade
		- Todo conjunto de entidades deve ter um atributo, ou um conjunto de atributos, cujo valor identifique univocamente cada entidade no conjunto -> Chave
		- Chave: principal meio de acesso a uma entidade
- Chave Simples
	- ![[Pasted image 20240401093537.png]]
- Chave Composta
	- entidade precisa de mais de um atributo para identificação
	- a concatenação de todos estes atributos indica a chave única
	- ![[Pasted image 20240401093836.png]]
- *Observação:* os CEs sempre possuem atributos, mas os CRs podem existir mesmo que não tenham atributos próprios
- Tipos de atributos
	- Simples (atômico): não dividido; uma única parte
	- Composto: dividido em partes; possui sub-atributos
		- ![[Pasted image 20240402083124.png]]
	- Monovalorado: pode assumir um único valor para uma/um entidade/ relacionamento em particular
	- Multivalorado: pode assumir mais de um valor para uma/um entidade/relacionamento em particular
		- ![[Pasted image 20240402083319.png]]
	- Armazenado: atributo da entidade
	- Derivado: valor pode ser obtido a partir dos valores de outros atributos da entidade ou informações armazenadas em seus relacionamentos
		- ![[Pasted image 20240402083528.png]]
	- Conjunto de Relacionamentos - Papéis
		- Cada CE que participa de um CR tem um PAPEL
		- Indicação opcional
			- pode facilitar entendimento da modelagem
		- ![[Pasted image 20240402083857.png]]
		- Deve ser feita sempre que houver ambiguidade na interpretação do CR
		- Auto-Relacionamento
			- um mesmo CE desempenha mais de um papel num mesmo CR
			- ![[Pasted image 20240402084203.png]]
		- Conjunto de Relacionamentos - Cardinalidade
			- Cardinalidade -> Restrição estrutural
			- Cardinalidade determina o número de relacionamentos dos quias cada entidade pode participar
			- ![[Pasted image 20240402084456.png]]
		- Conjunto de Relacionamentos - Restrição de Participação
			- Restrição de Participação -> Restrição Estrutural
				- Participação Total
				- Participação Parcial
			- Participação Total
			- ![[Pasted image 20240402092559.png]]
				- toda entidade **Disciplina** deve (obrigatoriamente) participar de um relacionamento **Possui** -> deve estar associado a uma entidade **Curso**
				- **toda entidade** de um CE deve participar, obrigatoriamente, de **ao menos um relacionamento** do CR
				- uma entidade só existe se estiver associada a outra entidade por meio de um relacionamento
			- Participação Parcial
				- nem todas as entidades de um CE participam de um CR
					- uma entidade pode existir sem estar associada a outra
					- ![[Pasted image 20240402093059.png]]
		- Conjunto de Relacionamentos - Entidade Fraca
			- não tem atributos que possam identificá-la univocamente na semântica do domínio de aplicação
				- não tem chave (semântica) própria
				- sua identificação depende de um relacionamento com uma entidade de outro conjunto
				- ![[Pasted image 20240402093509.png]]
				- Chave Parcial: um ou mais atributos de CEs fracas podem identificar univocamente as entidades fracas *relacionadas a um mesmo owner*.
				- ![[Pasted image 20240402095931.png]]
				- Conjunto de Entidades Fracas
					- possui **participação total** no CR (chamado de **CR identificador**)
					- a cardinalidade do CR é sempre 1:N ou 1:1, mas nunca N:M
				- Observação: o conceito de entidade fraca é mais ligado à semântica do domínio da aplicação do que à existência ou não de atributos que possam ser chave
				- Quando modelar como Entidade Fraca?
					- quando tiver muitos atributos
					- quando a entidade fraca participar de outros relacionamentos além daquele que a identifica
				- ![[Pasted image 20240402100501.png]]
		- Conjunto de Relacionamentos - Grau
			- Grau do CR é o número de CEs envolvidos
				- Dois CEs -> CR Binário
				- Três CEs -> CR Ternário
				- ...
			- ![[Pasted image 20240402100940.png]]
		- Relacionamento Ternário
			- Cardinalidades possíveis para ternários
				- 1:1:1
				- 1:1:N
				- 1:N:M
				- N:M:P
			- Podemos tentar "quebrar" o relacionamento ternário em vários binários?
				- problema -> perda de informações semântica
				- a informação representada por um conjunto de relacionamentos ternário nem sempre pode ser obtido apenas com CRs BInários
			- Mesmo Conjunto de Entidades com vários papéis
				- ![[Pasted image 20240402101616.png]]