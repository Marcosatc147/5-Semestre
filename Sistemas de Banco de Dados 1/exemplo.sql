CREATE OR REPLACE FUNCTION check_professor() 
RETURNS trigger 
AS $check_professor$
DECLARE
    discs_prof INTEGER;
BEGIN
    SELECT COUNT(*) INTO discs_prof
    FROM DISCIPLINA
    WHERE Professor = NEW.Aluno 
    AND Sigla = NEW.Sigla;
    
    IF discs_prof > 0 THEN
        RAISE EXCEPTION 'Um professor não pode se matricular em disciplinas que ele mesmo ministra';
    END IF;
    
    RETURN NEW;
END;
$check_professor$ LANGUAGE plpgsql;


DROP TRIGGER IF EXISTS check_matricula_de_professor ON MATRICULA;

CREATE TRIGGER check_matricula_de_professor
BEFORE INSERT ON MATRICULA
FOR EACH ROW EXECUTE FUNCTION check_professor();



INSERT INTO DISCIPLINA (Sigla, Nome, Professor) VALUES
('MAT101', 'Matemática Básica', 'Prof. João'),
('FIS101', 'Física I', 'Prof. Maria');

INSERT INTO MATRICULA (Aluno, Sigla) VALUES
('Prof. Joa', 'MAT101'); -- Isso deve disparar o trigger e gerar uma exceção

SELECT * FROM MATRICULA;



