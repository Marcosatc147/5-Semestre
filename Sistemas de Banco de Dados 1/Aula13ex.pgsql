CREATE TABLE Aluno (
    NMatricula INT PRIMARY KEY,
    nome VARCHAR(100) UNIQUE NOT NULL,
    Idade INT,    
    DataNasc DATE
);
CREATE TABLE Professor (
    NFunc INT PRIMARY KEY,
    nome VARCHAR(100) UNIQUE NOT NULL,
    Idade INT,
    Titulacao VARCHAR(100)
);
CREATE TABLE Disciplina (
    Sigla CHAR(7) PRIMARY KEY, -- AAA1234
    Nome VARCHAR(100) NOT NULL,
    NCred INT NOT NULL,
    Professor VARCHAR(100),
    Livro VARCHAR(100),

    FOREIGN KEY (Professor) REFERENCES Professor(nome)
);
CREATE TABLE Turma (
    Sigla CHAR(7),
    Numero INT,
    NAlunos INT,
    PRIMARY KEY (Sigla, Numero),
    FOREIGN KEY (Sigla) REFERENCES Disciplina(Sigla)
);
CREATE TABLE Matrícula (
    Sigla CHAR(7),
    Numero INT,
    Aluno INT,
    Ano INT,
    Nota NUMERIC(5, 2), --Nota NUMERIC(5, 2): Nota com até 5 dígitos no total e 2 casas decimais.
    PRIMARY KEY (Sigla, Numero, Aluno, Ano),
    FOREIGN KEY (Sigla, Numero) REFERENCES Turma(Sigla, Numero),
    FOREIGN KEY (Aluno) REFERENCES Aluno(NMatricula)
);

