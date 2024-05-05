USE [ConcursoCanino]
GO

/****** Object:  Trigger [dbo].[Tr_Validar_Puesto]    Script Date: 4/05/2024 16:12:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		  Bryam Jesus Talledo Garcia
-- Create date: 2024-05-04
-- Description:	Validar cuando se este ingrasando el puesto que no sea mayor al numero de participantes
--              que no sea mayor al numero de participantes
--              y que no vaya a utilizar un puesto que ya tiene otro concursante
-- =============================================
CREATE TRIGGER [dbo].[Tr_Validar_Puesto]
  ON [dbo].[ParticipacionConcurso]
  AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE 
		@CODIGO_CONCURSO_INSERTED INT,
		@CODIGO_CATEGORIA_INSERTED INT,
		@CANTIDAD_PARTICIPANTES INT,
		@CODIGO_PARTICIPANTE_INSERTED INT,
		@PUESTO_INSERTED INT,
		@PUESTO INT;

	SELECT
		@CODIGO_CONCURSO_INSERTED = i.CoConcurso,
		@CODIGO_CATEGORIA_INSERTED = i.CoCategoria,
		@PUESTO_INSERTED = i.NuPuesto,
		@CODIGO_PARTICIPANTE_INSERTED = i.NuParticipacionConcurso
	FROM inserted i;

	SELECT
		@CANTIDAD_PARTICIPANTES = COUNT(1)
	FROM
		ParticipacionConcurso pc
	WHERE
		pc.CoCategoria = @CODIGO_CATEGORIA_INSERTED
		AND pc.CoConcurso = @CODIGO_CONCURSO_INSERTED;

	IF @CANTIDAD_PARTICIPANTES < @PUESTO_INSERTED
	BEGIN
		RAISERROR ('EL PUESTO INGRESADO ES MAYOR A LA CANTIDAD DE PARTICIPANTES', 16, 1);  
		ROLLBACK TRANSACTION;
	END
	
	DECLARE @EXISTE_PUESTO_REPETIDO INT;
	SELECT
		@EXISTE_PUESTO_REPETIDO = COUNT(1)
	FROM
		ParticipacionConcurso pc
	WHERE
		pc.CoCategoria = @CODIGO_CATEGORIA_INSERTED
		AND pc.CoConcurso = @CODIGO_CONCURSO_INSERTED
		AND pc.NuParticipacionConcurso <> @CODIGO_PARTICIPANTE_INSERTED
		AND pc.NuPuesto = @PUESTO_INSERTED;

	IF @EXISTE_PUESTO_REPETIDO <> 0
	BEGIN
		RAISERROR ('EL PUESTO YA LO A OBTENIDO OTRO PARTICIPANTE', 16, 1);  
		ROLLBACK TRANSACTION;
	END
END
GO

ALTER TABLE [dbo].[ParticipacionConcurso] ENABLE TRIGGER [Tr_Validar_Puesto]
GO


