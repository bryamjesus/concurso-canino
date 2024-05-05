USE [ConcursoCanino]
GO

/****** Object:  Trigger [dbo].[Tr_Insert_Particiacion]    Script Date: 4/05/2024 15:57:59 ******/
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
		@COD_CONCURSO_INSERTED INT,
		@COD_EJEMPLAR_INSERTED INT,
		@COD_CATEGORIA_INSERTED INT,
		@PUESTO_INSERTED INT,
		@CALIFICACION_INSERTED VARCHAR(20);
		

	-- Obteniendo los datos que estamos insertando === --
	SELECT 
		@COD_CONCURSO_INSERTED = i.CoConcurso,
		@COD_EJEMPLAR_INSERTED = i.CoEjemplar,
		@COD_CATEGORIA_INSERTED = i.CoCategoria,
		@PUESTO_INSERTED = i.NuPuesto,
		@CALIFICACION_INSERTED = i.TxCalificacion
	FROM inserted i;

	-- === Validar que no se este registrando el campo PUESTO ni Calificacion, solo eso es para cuando de Update === --
	IF ((NOT EXISTS (SELECT * FROM DELETED)) AND (@PUESTO_INSERTED IS NOT NULL OR @CALIFICACION_INSERTED IS NOT NULL))
	BEGIN
		RAISERROR ('NO PUEDE REGISTRAR PUESTO NI CALIFICACION CUANDO REGISTRA UN PARTICIPANTE', 16, 1);  
		ROLLBACK TRANSACTION;
	END
	
	-- === Obteniendo el valores del ejemplar === --
	DECLARE
		@RAZA_EJEMPLAR INT,
		@EDAD_EJEMPLAR INT;

	SELECT 
		@RAZA_EJEMPLAR = e.CoRaza,
		@EDAD_EJEMPLAR = e.NuEdadEjemplar
	FROM
		Ejemplar e 
	WHERE
		e.CoEjemplar = @COD_EJEMPLAR_INSERTED;
	
	-- === Validando que el ejemplar exista === --
	IF @RAZA_EJEMPLAR = 0 OR @RAZA_EJEMPLAR IS NULL OR @RAZA_EJEMPLAR = '' -- <>
	BEGIN
		RAISERROR ('ERROR LA RAZA DEL EJEMPLAR NO EXISTE', 16, 1);  
		ROLLBACK TRANSACTION;  
	END

	-- === Verificando que la raza del ejemplar este aceptado para el concurso === --
	DECLARE @EXISTE_RAZA_CONCURSO int;

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

	-- === Validar de la edad === --
	DECLARE @EDAD_MINIMA int, @EDAD_MAXIMA int;

	SELECT 
		@EDAD_MINIMA = c.NuEdadMinima,
		@EDAD_MAXIMA = c.NuEdadMaxima
	FROM Categoria c
	WHERE 
		c.CoCategoria = @COD_CATEGORIA_INSERTED

	IF NOT(@EDAD_MINIMA <= @EDAD_EJEMPLAR AND  @EDAD_EJEMPLAR <= @EDAD_MAXIMA)
	BEGIN
		RAISERROR ('LA EDAD DEL PERRO NO ESTA PERMITIDO PARA ESTA CATEGORIA DEL CONCURSO',16, 1);  
		ROLLBACK TRANSACTION;  
	END

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
GO

ALTER TABLE [dbo].[ParticipacionConcurso] ENABLE TRIGGER [Tr_Insert_Particiacion]
GO


