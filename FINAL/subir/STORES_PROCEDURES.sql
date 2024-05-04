USE [ConcursoCanino]
GO

/****** Object:  StoredProcedure [dbo].[sp_registro_can_concurso]    Script Date: 4/05/2024 04:48:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		    Bryam Jesus Talledo Garcia
-- Create date:   2024-05-04
-- Description:	  Registro de un participante
-- =============================================
CREATE PROCEDURE [dbo].[sp_registro_can_concurso]
	@NOMBRE_EJEMPLAR VARCHAR(50),
	@NOMBRE_PROPIETARIO VARCHAR(50),
	@CODIGO_MICROSHIP CHAR(10),
	@CODIGO_CONCURSO INT,
	@NOMBRE_MANEJADOR VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		DECLARE
			@CODIGO_EJEMPLAR INT,
			@CODIGO_RAZA INT,
			@EDAD_EJEMPLAR INT;

		SELECT
			@CODIGO_EJEMPLAR = e.CoEjemplar,
			@CODIGO_RAZA = e.CoRaza,
			@EDAD_EJEMPLAR = e.NuEdadEjemplar
		FROM Ejemplar e
		WHERE
			e.NoEjemplar = @NOMBRE_EJEMPLAR
			AND e.NoPropietario = @NOMBRE_PROPIETARIO
			AND e.CoMicroship = @CODIGO_MICROSHIP;
		
		IF @CODIGO_EJEMPLAR IS NULL AND @CODIGO_RAZA IS NULL
		BEGIN
			THROW 50001, 'No se encontró el ejemplar con los datos proporcionados.', 1;
			--THROW 50000, 'El can no se encontró', 1;
		END

		PRINT 'ANTES '
		DECLARE @EDAD_MINIMA int, @EDAD_MAXIMA int, @CODIGO_CATEGORIA int, @CODIGO_CATEGORIA_CAN INT;
		-- VALIDACION DE EDAD
		DECLARE rando_edad_cursor CURSOR FOR
		SELECT 
			c.NuEdadMinima, c.NuEdadMaxima, c.CoCategoria
		FROM 
			Concurso_Categoria cc
		JOIN Categoria c
			on cc.CoCategoria = c.CoCategoria
		WHERE cc.CoConcurso = @CODIGO_CONCURSO

		OPEN rando_edad_cursor
		FETCH NEXT FROM rando_edad_cursor INTO @EDAD_MINIMA, @EDAD_MAXIMA, @CODIGO_CATEGORIA
		WHILE @@FETCH_STATUS = 0
		BEGIN
			PRINT  'ENTRO'
			IF (@EDAD_MINIMA <= @EDAD_EJEMPLAR AND  @EDAD_EJEMPLAR <= @EDAD_MAXIMA)
			BEGIN 
				SET @CODIGO_CATEGORIA_CAN = @CODIGO_CATEGORIA
			END
			FETCH NEXT FROM rando_edad_cursor INTO @EDAD_MINIMA, @EDAD_MAXIMA, @CODIGO_CATEGORIA
		END
		CLOSE rando_edad_cursor
		DEALLOCATE rando_edad_cursor

		IF(@CODIGO_CATEGORIA_CAN IS NULL OR @CODIGO_CATEGORIA_CAN = '')
		BEGIN
			THROW 50002, 'No existe categoria para la edad del ejemplar en el Concurso', 1;
		END
		
		DECLARE @CODIGO_PARTICIPACION_CONCURSO INT;

		INSERT INTO 
			ParticipacionConcurso (CoConcurso, CoCategoria, NoManejador,CoEjemplar)
		VALUES
			(@CODIGO_CONCURSO, @CODIGO_CATEGORIA_CAN, @NOMBRE_MANEJADOR, @CODIGO_EJEMPLAR);
		
		SET @CODIGO_PARTICIPACION_CONCURSO = SCOPE_IDENTITY();

		SELECT 
			@CODIGO_PARTICIPACION_CONCURSO AS 'codigoParticipacion',
			@NOMBRE_EJEMPLAR AS 'nombreEjemplar',
			@NOMBRE_PROPIETARIO AS 'nombrePropietario',
			@NOMBRE_MANEJADOR AS 'nombreManejador',
			inscon.nombreConcurso,
			inscon.nombreCategoria,
			inscon.tarifaInscripcion,
			inscon.fechaRealizacion
		FROM vw_Inscripcion_Concurso inscon
		WHERE
			inscon.codigoCategoria = @CODIGO_CATEGORIA_CAN
			AND inscon.codigoConcurso = @CODIGO_CONCURSO;
	END TRY
	BEGIN CATCH
		SELECT 
			ERROR_PROCEDURE() AS ErrorProcedure,
			ERROR_MESSAGE() AS ErrorMessage;  
	END CATCH	
END
GO
