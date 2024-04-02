## Evolução dos Sistemas de Informação
Sistemas de Informação baseados em gerenciamento de arquivos:
- Cada unidade da organização possui seus programas e arquivos
- Programas curtos para tarefas específicas
- Dados armazenados em disco
- Cada arquivo usa uma estrutura de dados
![[Sistemas baseados em gerenciamento de arquivos.png]]
- Redundância <-> Inconsistência
## SIs baseados em arquivos
- Problemas: 
	- Redundância e inconsistência de dados
	- Dificuldade de acesso aos dados
	- Isolamento de dados
	- Anomalias no acesso concorrente
	- Segurança
- Dados gravados em discos usando estruturas de dados
- Acesso requer conhecimento destas estruturas -> Dependência de dados
	- ACOPLAMENTO FORTE
	- Se houver alteração na estrutura de dados, todos os programas terão que ser alterados
## Independência dos Dados
- Como tornar os programas independentes da estrutura de dados
	- Criando um sistema que gerencie a estrutura
## SGBD (Sistema de Gerenciamento de Banco de Dados)
- Composto por:
	- Conjunto de Dados
		- Bases de Dados, Tabelas e Índices, Tuplas
	- Conjunto de programas
		- Acesso e manipulação dos dados
- É um sistema de propósito geral:
	- Mantém um conjunto lógico e organizado de dados
	- Armazena grandes volumes de dados
	- Permite busca e atualização dos dados
	- É eficiente
	- É autônomo em relação às aplicações
![[SGBD.png]]
### SGBDs
- Requisitos Fundamentais:
	- Segurança
		- Física (mais comum no passado)
		- Lógica
			- Usernames e passwords
			- Perfis de usuário
	- Integridade
		- Consistência
		- Validade
	- Recuperação/ Tolerância a falhas:
		- Transações atômicas
		- Registros de Log
		- Backup
	- Controle da concorrência
- Restrições de integridade:
	- Definem o que é válido e o que não é válido
	- Exemplos:
		- Um funcionário não pode pertencer a mais do que um departamento
		- O preço de venda de um produto deverá ser superior ao seu custo
		- O código de cada produto deve ser único
- Componentes de um SGBD
	- Processador de consultas
	- Gerenciador de Armazenamento
	- Sistema <-> SGBD <-> Banco de Dados
### Utilizando um SGBD
1. Modelagem
	- Modelo Entidade/Relacionamento
	- Modelo Relacional
2. Definição
	- SQL DDL
3. Instanciação
	- SQL DDL/DML
4. Uso
	- SQL DML
- A interface dos banco de dados é definida pela linguagem declarativa SQL (DDL + DML)
	- Não-Procedural(Declarativo): exige apenas especificação de quais dados são necessários, e não de como obtê-los
#### SQL - Data Definition Language (DDL)
- Conjunto de comandos para definição do esquema da base de dados
- Principais elementos:
	- create
	- alter
	- drop
- Compilador/Interpretador DDL
#### SQL - Data Manipulation Language (DML)
- Conjunto de comandos para manipulação dos dados de maneira compatível com o esquema
- Principais elementos:
	- select
	- insert
	- delete
	- update
- Compilador/Interpretador DML