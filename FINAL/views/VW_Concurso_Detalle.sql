USE [ConcursoCanino]
GO

/****** Object:  View [dbo].[vw_Inscripcion_Concurso]    Script Date: 5/05/2024 01:35:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VW_Concurso_Detalle]
AS
SELECT
	con.CoConcurso 													AS 'codigoConcurso',
	con.NoConcurso 													AS 'nombreConcurso',
	cat.CoCategoria 												AS 'codigoCategoria',
	cat.NoCategoria 												AS 'nombreCategoria',
	con.FeRealizacion 											AS 'fechaRealizacion',
	concate.SsTarifaInscripcionCategoria 		AS 'tarifaInscripcion'
FROM 
	Concurso con
JOIN Concurso_Categoria concate
	ON con.CoConcurso = concate.CoConcurso
JOIN Categoria cat
	ON cat.CoCategoria = concate.CoCategoria
GO


