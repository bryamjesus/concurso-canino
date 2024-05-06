USE [ConcursoCanino]
GO

/****** Object:  Trigger [dbo].[Tr_Fecha]    Script Date: 4/05/2024 16:58:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		  Bryam Talledo
-- Create date: 2024-05-03
-- Description: Validar que la fecha de registro no sea mayor a la fecha en
--              en la que se realizara el concurso
-- =============================================
CREATE TRIGGER [dbo].[TR_Validar_Fecha_Concurso]
	ON [dbo].[ParticipacionConcurso]
	AFTER INSERT, UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	DECLARE @COD_CONCURSO_INSERTED INT;
	DECLARE @FECHA_REALIZACION DATE;

	SELECT
		@FECHA_REALIZACION = c.FeRealizacion,
		@COD_CONCURSO_INSERTED = i.CoConcurso
	FROM
		Concurso c
	JOIN inserted i
		ON c.CoConcurso = i.CoConcurso

	IF (@FECHA_REALIZACION < GETDATE())
	BEGIN
		RAISERROR ('EL CONCURSO YA SE REALIZÓ', 16, 1);  
		ROLLBACK TRANSACTION;  
	END
END
ALTER TABLE [dbo].[ParticipacionConcurso] ENABLE TRIGGER [Tr_Fecha]
GO
