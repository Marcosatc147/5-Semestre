CREATE TABLE Professor (
    ID SERIAL PRIMARY KEY,
    Nome VARCHAR(100),
    Titulacao VARCHAR(50)
);

CREATE OR REPLACE FUNCTION check_titulacao()
RETURNS trigger
AS $check_titulacao$
DECLARE 
	titulo_atual INTEGER;
	titulo_novo INTEGER;
BEGIN
	CASE OLD.Titulacao
		WHEN 'Bacharel' THEN titulo_atual := 1;
		WHEN 'Mestre' THEN titulo_atual := 2;
		WHEN 'Doutor' THEN titulo_atual := 3;
		WHEN 'Livre-docente' THEN titulo_atual :=  4;
		WHEN 'Titular' THEN titulo_atual := 5;
		WHEN 'Catedrático' THEN titulo_atual := 6;
	END CASE;

	CASE NEW.Titulacao
		WHEN 'Bacharel' THEN titulo_novo := 1;
		WHEN 'Mestre' THEN titulo_novo := 2;
		WHEN 'Doutor' THEN titulo_novo := 3;
		WHEN 'Livre-docente' THEN titulo_novo := 4;
		WHEN 'Titular' THEN titulo_novo := 5;
		WHEN 'Catedrático' THEN titulo_novo := 6;
	END CASE;

	IF titulo_novo < titulo_atual THEN
		RAISE EXCEPTION 'A titulação não pode ser atualizada para um status inferior';
	END IF;

	RETURN NEW;
END;
$check_titulacao$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS check_titulacao_trigger ON Professor;

CREATE TRIGGER check_titulacao_trigger
BEFORE UPDATE ON Professor
FOR EACH ROW EXECUTE PROCEDURE check_titulacao();


INSERT INTO Professor (Nome, Titulacao) VALUES
('Prof. A', 'Bacharel'),
('Prof. B', 'Mestre'),
('Prof. C', 'Doutor');

-- Isso deve falhar
UPDATE Professor 
SET Titulacao = 'Doutor' 
WHERE Nome = 'Prof. B';

SELECT * FROM Professor;
