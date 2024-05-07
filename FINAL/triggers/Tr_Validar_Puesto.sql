USE [ConcursoCanino]
GO

/****** Object:  Trigger [dbo].[TR_Validar_Puesto]    Script Date: 6/05/2024 01:36:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		  Bryam Jesus Talledo Garcia
-- Create date: 2024-05-04
-- Description:	Validar cuando se esté ingresando el puesto que no sea mayor al número de participantes
--              que no sea mayor al número de participantes
--              y que no vaya a utilizar un puesto que ya tiene otro concursante
-- =============================================
CREATE TRIGGER [dbo].[TR_Validar_Puesto]
  ON [dbo].[ParticipacionConcurso]
  AFTER UPDATE, INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE 
		@CODIGO_CONCURSO_INSERTED INT,
		@CODIGO_CATEGORIA_INSERTED INT,
		@CODIGO_PARTICIPANTE_INSERTED INT,
		@PUESTO_INSERTED INT,
    @CALIFICACION_INSERTED VARCHAR(20);

	SELECT
		@CODIGO_CONCURSO_INSERTED = i.CoConcurso,
		@CODIGO_CATEGORIA_INSERTED = i.CoCategoria,
		@PUESTO_INSERTED = i.NuPuesto,
		@CODIGO_PARTICIPANTE_INSERTED = i.NuParticipacionConcurso,
    @CALIFICACION_INSERTED = i.TxCalificacion
	FROM inserted i;

  -- === Validar que no se este registrando el campo PUESTO ni Calificacion, solo eso es para cuando de Update === --
	IF ((NOT EXISTS (SELECT * FROM DELETED)) AND (@PUESTO_INSERTED IS NOT NULL OR @CALIFICACION_INSERTED IS NOT NULL))
	BEGIN
		RAISERROR ('NO PUEDE REGISTRAR PUESTO NI CALIFICACION CUANDO REGISTRA UN PARTICIPANTE', 16, 1);  
		ROLLBACK TRANSACTION;
	END
  ELSE
  BEGIN
    
    DECLARE @CANTIDAD_PARTICIPANTES INT;

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
END
GO

ALTER TABLE [dbo].[ParticipacionConcurso] ENABLE TRIGGER [TR_Validar_Puesto]
GO


