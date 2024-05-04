USE [ConcursoCanino]
GO

/****** Object:  Trigger [dbo].[Tr_Insert_Particiacion]    Script Date: 4/05/2024 15:57:59 ******/
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
CREATE TRIGGER [dbo].[Tr_Fecha]
	ON [dbo].[ParticipacionConcurso]
  AFTER INSERT, UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
  DECLARE 
		@COD_CONCURSO_INSERTED INT;

	-- Obteniendo los datos que estamos insertando === --
	SELECT 
		@COD_CONCURSO_INSERTED = i.CoConcurso
	FROM inserted i;

	-- === Validar la fecha de realizacion === --
	DECLARE @FECHA_REALIZACION DATE;
	SELECT
		@FECHA_REALIZACION = c.FeRealizacion
	FROM
		Concurso c
	WHERE
		c.CoConcurso = @COD_CONCURSO_INSERTED;

	IF (@FECHA_REALIZACION < GETDATE())
	BEGIN
		RAISERROR ('EL CONCURSO YA SE REALIZÓ', 16, 1);  
		ROLLBACK TRANSACTION;  
	END
END
ALTER TABLE [dbo].[ParticipacionConcurso] ENABLE TRIGGER [Tr_Fecha]
GO
