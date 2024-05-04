USE [ConcursoCanino]
GO

/****** Object:  Trigger [dbo].[Tr_Insert_Particiacion]    Script Date: 4/05/2024 04:52:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Bryam Talledo
-- Create date: 2024-05-03
-- Description: Registro de [ParticipacionConcurso]
-- =============================================
CREATE TRIGGER [dbo].[Tr_Insert_Particiacion]
   ON [dbo].[ParticipacionConcurso]
   AFTER INSERT, UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@COD_CONCURSO_INSERTED int,
		@COD_EJEMPLAR_INSERTED int,
		@COD_CATEGORIA_INSERTED int, 
		@EXISTE_RAZA_CONCURSO int,
		@RAZA_EJEMPLAR int,
		@EDAD_EJEMPLAR int,
		@RANGO_EDAD int;

	-- OBTENIENDO LOS DATOS QUE ESTAMOS INSERTANDO
	SELECT 
		@COD_CONCURSO_INSERTED = i.CoConcurso,
		@COD_EJEMPLAR_INSERTED = i.CoEjemplar,
		@COD_CATEGORIA_INSERTED = i.CoCategoria
	FROM inserted i;

	-- Obteniendo el valores del ejemplar
	SELECT 
		@RAZA_EJEMPLAR = e.CoRaza,
		@EDAD_EJEMPLAR = e.NuEdadEjemplar
	FROM
		Ejemplar e 
	WHERE
		e.CoEjemplar = @COD_EJEMPLAR_INSERTED;
	
	-- validando que el ejemplar exista
	IF @RAZA_EJEMPLAR = 0 -- <>
	BEGIN
		RAISERROR ('ERROR LA RAZA DEL EJEMPLAR NO EXISTE', 16, 1);  
		ROLLBACK TRANSACTION;  
	END

	-- Verificando que la raza del ejemplar este aceptado para el concurso
	SELECT
		@EXISTE_RAZA_CONCURSO = COUNT(1)
	FROM Raza_Concurso rc
	WHERE
		rc.CoConcurso = @COD_CONCURSO_INSERTED
		AND rc.CoRaza = @RAZA_EJEMPLAR

	IF @EXISTE_RAZA_CONCURSO = 0
	BEGIN
		RAISERROR ('RAZA DEL PERRO NO ESTA PERMITIDO EN ESTE CONCURSO', 16, 1);  
		ROLLBACK TRANSACTION;  
	END

	-- VALIDACION DE LA EDAD
	DECLARE @NuEdadMinima int, @NuEdadMaxima int;
	SELECT 
		@NuEdadMinima = c.NuEdadMinima,
		@NuEdadMaxima = c.NuEdadMaxima
	FROM Categoria c
	WHERE c.CoCategoria = @COD_CATEGORIA_INSERTED

	IF NOT(@NuEdadMinima <= @EDAD_EJEMPLAR AND  @EDAD_EJEMPLAR <= @NuEdadMaxima)
	BEGIN
		RAISERROR ('LA EDAD DEL PERRO NO ESTA PERMITIDO PARA ESTA CATEGORIA DEL CONCURSO', 16, 1);  
		ROLLBACK TRANSACTION;  
	END

	DECLARE @FECHA_REALIZACION DATE;
	SELECT
		@FECHA_REALIZACION = c.FeRealizacion
	FROM
		Concurso c
	WHERE
		c.CoConcurso = @COD_CONCURSO_INSERTED;

	IF (@FECHA_REALIZACION < GETDATE())
	BEGIN
		RAISERROR ('El concurso ya se realizó', 16, 1);  
		ROLLBACK TRANSACTION;  
	END
END
GO

ALTER TABLE [dbo].[ParticipacionConcurso] ENABLE TRIGGER [Tr_Insert_Particiacion]
GO