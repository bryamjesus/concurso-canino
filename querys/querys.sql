-- ALTER TABLE ParticipacionConcurso
-- ADD CONSTRAINT UQ_NuParticipacionConcurso UNIQUE (NuParticipacionConcurso);

SELECT * FROM Caracteristica;
SELECT * FROM Caracteristica_Raza;
SELECT * FROM Raza;
SELECT * FROM Raza_Concurso WHERE CoConcurso = 1;
SELECT * FROM Ejemplar;


SELECT * FROM Categoria;
SELECT * FROM Certificado;
SELECT * FROM Certificado_ClaseConcurso;
SELECT * FROM ClaseConcurso;
SELECT * FROM Comisario;
SELECT * FROM Juez;
SELECT * FROM Concurso_Juez;