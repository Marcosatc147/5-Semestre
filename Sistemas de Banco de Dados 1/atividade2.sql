CREATE TABLE Disciplina2 (
    Codigo SERIAL PRIMARY KEY,
    Nome VARCHAR(100),
    Creditos INTEGER,
    Semestre VARCHAR(10)
);
CREATE TABLE Matricula2 (
    Aluno INT,
    DisciplinaCodigo INT,
    Nota NUMERIC,
    FOREIGN KEY (DisciplinaCodigo) REFERENCES Disciplina2(Codigo)
);

CREATE OR REPLACE FUNCTION valide_credito()
RETURNS trigger
AS $valide_credito$
DECLARE
	total_creditos INTEGER;
BEGIN
	--calculo do total de credito
	SELECT SUM(d.Creditos) INTO total_creditos
	FROM Matricula2 m
	JOIN Disciplina2 d ON m.DisciplinaCodigo = d.Codigo
	WHERE m.Aluno = NEW.Aluno
	AND d.Semestre = (SELECT Semestre FROM Disciplina2 WHERE Codigo = NEW.DisciplinaCodigo);

	-- Se total null trata como 0
	IF total_creditos IS NULL THEN
		total_creditos := 0;
	END IF;

	-- Adiciona os créditos com os que ja tinham na matriculo
	SELECT INTO total_creditos (total_creditos + d.Creditos)
	FROM Disciplina2 d
	WHERE d.Codigo = NEW.DisciplinaCodigo;

	--Verifica o total
	IF total_creditos > 20 THEN
		RAISE EXCEPTION 'O alunno não pode se matricular em mais de 20 créditos por semestre';

	END IF;
	RETURN NEW;

END;
$valide_credito$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS check_credito_trigger ON Matricula2;

CREATE TRIGGER check_credito_trigger
BEFORE INSERT ON Matricula2
FOR EACH ROW EXECUTE PROCEDURE valide_credito();


INSERT INTO Disciplina2 (Nome, Creditos, Semestre) VALUES
('Matemática', 5, '2024-1'),
('Física', 6, '2024-1'),
('Química', 4, '2024-1'),
('Programação', 6, '2024-1'),
('Biologia', 3, '2024-1'),
('História', 4, '2024-1'),
('Geografia', 3, '2024-1'),
('Literatura', 3, '2024-1');

-- Isso deve falhar se o total de créditos exceder 30
INSERT INTO Matricula2 (Aluno, DisciplinaCodigo) VALUES
('Aluno1', 1),
('Aluno1', 2),
('Aluno1', 3),
('Aluno1', 4),
('Aluno1', 5),
('Aluno1', 6),
('Aluno1', 7),
('Aluno1', 8); -- Total de créditos: 40 (deve gerar uma exceção)


	
SELECT * FROM Matricula2;

ALTER TABLE Matricula2
ADD COLUMN Nota FLOAT;


CREATE OR REPLACE FUNCTION calcula_media()
RETURNS trigger
AS $calcula_media$
BEGIN
    -- Recalcular a média após a inserção ou atualização
    UPDATE Disciplina2 d
    SET nota_media = (
        SELECT AVG(m.Nota)
        FROM Matricula2 m
        WHERE m.DisciplinaCodigo = d.Codigo
    )
    WHERE d.Codigo = NEW.DisciplinaCodigo;

    RETURN NEW;
END;
$calcula_media$ LANGUAGE plpgsql;


DROP TRIGGER IF EXISTS atualiza_media ON Disciplina2;

CREATE TRIGGER atualiza_media
AFTER INSERT OR UPDATE OR DELETE ON Matricula2
FOR EACH ROW EXECUTE PROCEDURE calcula_media();

-- Inserindo disciplinas
INSERT INTO Disciplina2 (Codigo, Nome, Semestre) VALUES (1, 'Matemática', 2024);
INSERT INTO Disciplina2 (Codigo, Nome, Semestre) VALUES (2, 'Física', 2024);

-- Inserindo matrículas e notas
INSERT INTO Matricula2 (Aluno, DisciplinaCodigo, Nota) VALUES (101, 1, 7.5);
INSERT INTO Matricula2 (Aluno, DisciplinaCodigo, Nota) VALUES (102, 4, 8.0);
INSERT INTO Matricula2 (Aluno, DisciplinaCodigo, Nota) VALUES (103, 4, 6.5);

UPDATE Matricula2 SET Nota = 9.0 WHERE Aluno = 101 AND DisciplinaCodigo = 1;

SELECT * FROM Matricula2;
SELECT * FROM Disciplina2;
