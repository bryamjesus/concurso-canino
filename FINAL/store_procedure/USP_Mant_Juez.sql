USE [ConcursoCanino]
GO

/****** Object:  StoredProcedure [dbo].[uSp_Mant_Juez]    Script Date: 5/05/2024 22:31:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Bryam Jesus Talledo Garcia
-- Create date: 2024-05-05
-- Description:	Mantenimiento de la tabla Juez
-- =============================================
CREATE PROCEDURE [dbo].[USP_Mant_Juez]
	@CODIGO				INT,
	@NOMBRE				VARCHAR(50),
	@APELLIDO			VARCHAR(60),
	@SEXO				CHAR(1),
	@FECHA_NACIMIENTO	DATE,
	@ACREDITACION		CHAR(1),
	@MODO				VARCHAR(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    BEGIN TRY
		IF @MODO = 'GET_ALL'
		BEGIN
			SELECT
				j.CoJuez,
				j.NoJuez,
				j.ApeJuez,
				j.FISexoJuez,
				j.FeNacimientoJuez,
				j.FIAcreditacionJuez
			FROM
				Juez j
		END

		IF @MODO = 'GET_ONE'
		BEGIN
			SELECT
				j.CoJuez,
				j.NoJuez,
				j.ApeJuez,
				j.FISexoJuez,
				j.FeNacimientoJuez,
				j.FIAcreditacionJuez
			FROM
				Juez j
			WHERE
				j.CoJuez = @CODIGO;
		END

		IF @MODO = 'INSERT'
		BEGIN
			INSERT INTO Juez
			(
				NoJuez,
				ApeJuez,
				FISexoJuez,
				FeNacimientoJuez,
				FIAcreditacionJuez
			)
			VALUES
			(
				@NOMBRE,
				@APELLIDO,
				@SEXO,
				@FECHA_NACIMIENTO,
				@ACREDITACION
			)
		END

		IF @MODO = 'UPDATE'
		BEGIN
			UPDATE Juez
			SET
				NoJuez				= @NOMBRE,
				ApeJuez				= @APELLIDO,
				FISexoJuez			= @SEXO,
				FeNacimientoJuez	= @FECHA_NACIMIENTO,
				FIAcreditacionJuez	= @ACREDITACION
			WHERE
				CoJuez = @CODIGO
		END

		IF @MODO = 'DELETE'
		BEGIN
			DELETE FROM Juez
			WHERE
				CoJuez = @CODIGO
		END
	END TRY
	BEGIN CATCH
		SELECT 
			ERROR_MESSAGE() AS 'Mensaje Error',
			ERROR_LINE() AS 'Linea Error',
			ERROR_PROCEDURE() AS 'Procedimiento Almacenado';
	END CATCH
END
GO


