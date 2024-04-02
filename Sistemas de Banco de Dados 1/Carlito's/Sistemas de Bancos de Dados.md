![[Pasted image 20240331180001.png]]
# Arquitetura Cliente/Servidor
- **Arquitetura de uma Camada (Single-Tier):**
    - Neste modelo, tanto a lógica de aplicação quanto os dados residem no mesmo local, geralmente no dispositivo do usuário.
    - Adiciona-se simplicidade ao desenvolvimento e implementação.
    - Problemas: Dificuldade em escalar e manter, falta de separação de preocupações, baixa segurança e desempenho limitado.
    - ![[Pasted image 20240331181059.png]]
- **Arquitetura de Duas Camadas (Two-Tier):**
    - Introduz a separação entre a camada de apresentação (cliente) e a camada de dados (servidor).
    - O cliente lida com a interface do usuário e a lógica de apresentação, enquanto o servidor gerencia os dados e a lógica de negócios.
    - Problemas: Limitações de escalabilidade, já que o servidor lida com todas as solicitações e respostas, levando a gargalos de desempenho e dificuldades de manutenção conforme a complexidade do sistema aumenta.
    - ![[Pasted image 20240331181045.png]]
- **Arquitetura de Três Camadas (Three-Tier):**
    - Divide a aplicação em três camadas distintas: apresentação, lógica de negócios e dados.
    - A camada de apresentação (cliente) lida apenas com a interface do usuário, a camada de lógica de negócios (servidor intermediário ou aplicação) processa as regras de negócios e a camada de dados (servidor de banco de dados) gerencia o armazenamento e a recuperação de dados.
    - Problemas: Embora resolva alguns problemas de escalabilidade e manutenção em comparação com a arquitetura de duas camadas, ainda pode sofrer com gargalos de desempenho e dificuldades de escalabilidade em ambientes de alta demanda.
    - ![[Pasted image 20240331181032.png]]
- **Arquitetura de Quatro Camadas (Four-Tier):**
    - Introduz uma camada adicional, geralmente chamada de camada de serviços ou middleware, entre a camada de lógica de negócios e a camada de dados.
    - Essa camada de serviços fornece funcionalidades compartilhadas e serviços reutilizáveis, como autenticação, autorização, gerenciamento de transações e acesso a dados.
    - Problemas: A introdução dessa camada adiciona complexidade ao sistema e pode aumentar os custos de desenvolvimento e manutenção. Além disso, se mal projetada ou implementada, pode se tornar um ponto único de falha e afetar a escalabilidade e o desempenho do sistema
    - ![[Pasted image 20240331181009.png]]
# Desenvolvimento de Sistemas de Banco de Dados
![[Pasted image 20240331181334.png]]
- Esquema
	- Definição
	- Estátivo
- Instância
	- Manipulação
	- Dinâmica
## Esquema e Instância
- Esquema pode ser definido em 3 níveis
	- Three-Schema Architecture (ou arquitetura ANSI/SPARC)
		- múltiplas visões para os usuários
		- armazenamento da descrição da base de dados(esquema) em diferentes níveis de abstração
			- escondendo detalhes e complexidade nos diferentes níveis
			- visão mais geral ou mais específica
		- Independência de dados
			- capacidade de modificar o esquema em determinado nível sem afetar o esquema do nível superior (desde que não ocorra downgrade)
			- SGBD pode suportar:
				- independência física
				- independência lógica
					- aplicativos não precisam ser reescritos
		- ![[Pasted image 20240401080906.png]]
			- Nível Interno - esquema físico
				- descreve **estrutura física** de armazenamento da base de dados
					- como os dados estão armazenados
			- Nível Conceitual - esquema - conceitual e/ou lógico
				- descreve a **estrutura da base de dados** sem detalhes de estrutura de armazenamento físico
					- **quais dados** estão armazenados e **como estão relacionados**
				- descrição do esquema/conceitual 
					- modelo conceitual  (ex: **MER**)
					- modelo de implementação (ex: **Modelo Relacional**)
			- Nível Externo - sub-esquemas
				- define as **visões dos usuários**
					- descreve a parte de dados em que cada grupo de usuários tem interesse
				- descrição de sub-esquemas:
					- modelo conceitual (ex: MER)
					- modelo de implementação (ex: Modelo Relacional)
![[Pasted image 20240401083912.png]]
## Projeto Conceitual
- **esquema conceitual**
	- níveis conceitual/lógico e externo/de visão
	- baseado nos requisitos de dados
	- objetivos:
		- estrutura da base de dados
		- semântica
		- relacionamentos
		- restrições
	- independente do SGBD
	- pode incluir especificações em alto nível de:
		- aplicações
		- características funcionais das transações
	- modelo conceitual
## Projeto lógico
- esquema lógico
- níveis conceitual/lógico e externo/de visão
- mapeamento do modelo conceitual para o modelo SGBD
- Passo 1 - mapeamento independente de um SGBD específico
	- depende do paradigma (relacional, OO, relacional-objeto)
- Passo 2 - ajustes de acordo com as características e restrições do modelo implementado por um SGBD específico
## Projeto físico
- esquema físico
	- nível interno
- estruturas físicas de armazenamento
	- organização de registros físicos
	- índices
	- número de discos, processadores, memória...
- critérios:
	- tempo de resposta
	- espaço utilizado
	- número de transações
# Modelagem de Dados
![[Pasted image 20240401085038.png]]
- Modelo de dados – “definição abstrata, autônoma e lógica dos objetos, operadores e outros elementos que, juntos, constituem a máquina abstrata com a qual os usuários interagem”.
	- objetos -> estrutura dos dados
	- operadores -> comportamento dos dados