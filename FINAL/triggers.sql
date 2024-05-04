-- QUIERA INGRESAR UN EJEMPLARA VERIFIQUE SI ESTA DENTRO DEL RADNDO DE EDAD DE LA CATEGORIA
SELECT * FROM Raza_Concurso

USE [ConcursoCanino]
GO
/****** Object:  Trigger [dbo].[Tr_Insert_Particiacion]    Script Date: 3/05/2024 11:19:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Bryam Talledo
-- Create date: 2024-05-03
-- Description: Registro 
-- =============================================
ALTER TRIGGER [dbo].[Tr_Insert_Particiacion]
   ON [dbo].[ParticipacionConcurso]
   AFTER INSERT, UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@COD_CONCURSO_INSERTED int, 
		@COD_EJEMPLAR_INSERTED int, 
		@EXISTE_RAZA_CONCURSO int,
		@RAZA_EJEMPLAR int;

	SELECT 
		@COD_CONCURSO_INSERTED = i.CoConcurso,
		@COD_EJEMPLAR_INSERTED  = i.CoEjemplar
	FROM inserted i;

	SELECT 
		@RAZA_EJEMPLAR = e.CoRaza 
	FROM
		Ejemplar e 
	WHERE
		e.CoEjemplar = @COD_EJEMPLAR_INSERTED;

	IF @RAZA_EJEMPLAR = 0 -- <>
	BEGIN
		RAISERROR ('ERROR LA RAZA DEL EJEMPLAR NO EXISTE', 16, 1);  
		ROLLBACK TRANSACTION;  
	END

	SELECT
		@EXISTE_RAZA_CONCURSO = COUNT(1)
	FROM Raza_Concurso rc
	WHERE
		rc.CoConcurso = @COD_CONCURSO_INSERTED
		AND rc.CoRaza = @RAZA_EJEMPLAR

	IF @EXISTE_RAZA_CONCURSO <> 0
	BEGIN
		RAISERROR ('RAZA DEL PERRO NO ESTA PERMITIDO EN ESTE CONCURSO', 16, 1);  
		ROLLBACK TRANSACTION;  
	END
END


SELECT @EXISTE_RAZA_CONCURSO AS 'EXISTE RAZA CONCURSO',
		@COD_CONCURSO_INSERTED AS 'CODIGO CONCURSO INSERTADO', 
		@COD_EJEMPLAR_INSERTED AS 'CODIGO EJEMPLAR INSERTADO', 
		@EXISTE_RAZA_CONCURSO AS 'EXISTE RAZA CONCURSO',
		@RAZA_EJEMPLAR AS 'RAZA DEL EJEMPLAR';

    SELECT * FROM ParticipacionConcurso;
SELECT * FROM Raza
SELECT * FROM Raza_Concurso
SELECT * FROM Concurso
SELECT * FROM Ejemplar

INSERT INTO ParticipacionConcurso values ( 3,3,'AÑA JIJIJIJI', 'Excelente', 1, 130)

UPDATE ParticipacionConcurso SET NoManejador = 'ACTUALIZACION PRUEBA' WHERE NuParticipacionConcurso = 36