# Abstrações no MER-X
- MER-X (MER Estendido)
	- suporte a abstrações de dados
		- abstração de agregação
		- abstração de generalização/especialização
- *Conceito geral:* construção de **objetos compostos** a partir de **objetos componentes**
	- Ideia: elementos de modelagem podem **associar-se** criando outros elementos que **representam essa associação**
## Abstração de Agregação
- Agregação no MER-X:
	- Agregando atributos a CE
		- os valores dos atributos compõem a entidade
	- Agregando CE e CR
		- combinar entidades relacionadas por meio de um relacionamento e compor entidades agregadas (de nível abstrato)
	- Também denominada Entidade Associativa
- ![[Pasted image 20240402104526.png]]
- Indícios de uso da Agregação
	- semanticamente, as mesmas instâncias de um CE participam de mais de um relacionamento (instância) do mesmo CR
	- o CR possui um identificador próprio
	- necessidade de associar dois relacionamentos