-- ================================================
-- Autor : Bryam Jesus Talledo Garcia
-- Muestrame el:
--			- Nombre del Ejemplar
--			- Raza 
--			- Propietario
--			- Lugar de nacimiento
--			- Sexo
-- de los perros que no llegaron a ganar ningun concurso.
-- ===============================================
USE ConcursoCanino;

GO;

SELECT DISTINCT
	e.NoEjemplar,
	r.NoRaza,
	e.NoPropietario,
	e.FeNacimiento,
	e.FlSexo
FROM
	Ejemplar e
	INNER JOIN ParticipacionConcurso pc ON pc.CoEjemplar = e.CoEjemplar
	INNER JOIN Raza r ON r.CoRaza = e.CoRaza
WHERE
	e.CoEjemplar NOT IN (
		SELECT DISTINCT
			pc.CoEjemplar
		FROM
			ParticipacionConcurso pc
		WHERE
			NuPuesto = 1
	);

GO;

-- ================================================
-- Autor : Bryam Jesus Talledo Garcia
-- El concurso que tiene menos jueces.
-- Mostrar los datos del concurso con el nombre del director y la clase del concurso,
-- ===============================================
SELECT
	c.CoConcurso,
	c.NoConcurso,
	c.NoEntidadOrganizadora,
	c.FeRealizacion,
	c.NoCiudad,
	d.NoDirector + ' ' + d.ApeDirector AS 'Nombre Director',
	cc.NoClaseConcurso
FROM
	Concurso c
	INNER JOIN Director d ON c.CoDirector = d.CoDirector
	INNER JOIN ClaseConcurso cc ON cc.CoClaseConcurso = c.CoClaseConcurso
WHERE
	c.CoConcurso = (
		SELECT
			TOP 1 cj.CoConcurso
		FROM
			Concurso_Juez cj
		GROUP BY
			cj.CoConcurso
		ORDER BY
			COUNT(cj.CoJuez) ASC
	)