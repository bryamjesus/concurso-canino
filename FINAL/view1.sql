USE [ConcursoCanino]
GO

/****** Object:  View [dbo].[vw_Inscripcion_Concurso]    Script Date: 4/05/2024 04:45:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vw_Inscripcion_Concurso]
AS
SELECT
	con.CoConcurso AS 'codigoConcurso',
	con.NoConcurso AS 'nombreConcurso',
	cat.CoCategoria AS 'codigoCategoria',
	cat.NoCategoria AS 'nombreCategoria',
	con.FeRealizacion AS 'fechaRealizacion',
	concate.SsTarifaInscripcionCategoria AS 'tarifaInscripcion'
FROM 
	Concurso con
JOIN Concurso_Categoria concate
	ON con.CoConcurso = concate.CoConcurso
JOIN Categoria cat
	ON cat.CoCategoria = concate.CoCategoria
GO


