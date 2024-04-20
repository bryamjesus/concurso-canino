USE master
GO
IF DB_ID('ConcursoCanino') IS NOT NULL
	DROP DATABASE ConcursoCanino
GO
------ Crear la base de datos de ConcursoCanino
CREATE DATABASE ConcursoCanino
GO
USE ConcursoCanino
GO
------ Scripts para crear las tablas de la BD
CREATE TABLE Caracteristica (
	CoCaracteristica INT IDENTITY(1,1) NOT NULL,
	NoCaracteristica VARCHAR(50) NOT NULL,
	CONSTRAINT Caracteristica_PK PRIMARY KEY CLUSTERED (CoCaracteristica ASC)
)
GO
CREATE TABLE Comisario (
	CoComisario INT IDENTITY(1,1) NOT NULL,
	NoComisario VARCHAR(50) NOT NULL,
	ApeComisario VARCHAR(60) NOT NULL,
	FeNacimientoComisario DATE NULL,
	FISexoComisario CHAR(1) NOT NULL,
	CONSTRAINT Comisario_PK PRIMARY KEY CLUSTERED (CoComisario ASC)
)
GO
CREATE TABLE Grupo (
	CoGrupo INT IDENTITY(1,1) NOT NULL,
	NoGrupo VARCHAR(100) NOT NULL,
	TxDescripcionGrupo VARCHAR(500) NOT NULL,
	CONSTRAINT Grupo_PK PRIMARY KEY CLUSTERED (CoGrupo ASC)
)
GO
CREATE TABLE Director (
	CoDirector INT IDENTITY(1,1) NOT NULL,
	NoDirector VARCHAR(50) NOT NULL,
	ApeDirector VARCHAR(60) NOT NULL,
	FeNacimientoDirector DATE NULL,
	FISexoDirector CHAR(1),
	CONSTRAINT Director_PK PRIMARY KEY CLUSTERED (CoDirector ASC)
)
GO
CREATE TABLE Juez (
	CoJuez INT IDENTITY(1,1) NOT NULL,
	NoJuez VARCHAR(50) NOT NULL,
	ApeJuez VARCHAR(60) NOT NULL,
	FISexoJuez CHAR(1) NOT NULL,
	FeNacimientoJuez DATE NULL,
	FIAcreditacionJuez CHAR(1) DEFAULT 'N',
	CONSTRAINT Juez_PK PRIMARY KEY CLUSTERED (CoJuez ASC)
)
GO
CREATE TABLE Categoria (
	CoCategoria INT IDENTITY(1,1) NOT NULL,
	NoCategoria VARCHAR(50) NOT NULL,
	NuEdadMinima INT NOT NULL, 
	NuEdadMaxima INT NOT NULL,
	CONSTRAINT Categoria_PK PRIMARY KEY CLUSTERED (CoCategoria ASC),
	CONSTRAINT NuEdadMinima_CK CHECK(NuEdadMinima > 90),
	CONSTRAINT NuEdadMaxima_CK CHECK(NuEdadMaxima > 90)
)
GO
CREATE TABLE Certificado (
	CoCertificado CHAR(6) NOT NULL,
	TxDescripcionCertificado VARCHAR(100) NOT NULL,
	CONSTRAINT Certificado_PK PRIMARY KEY CLUSTERED (CoCertificado ASC)
)
GO
CREATE TABLE ClaseConcurso (
	CoClaseConcurso INT IDENTITY(1,1) NOT NULL,
	NoClaseConcurso VARCHAR(50) NOT NULL,
	TxDescripcionClaseConcurso VARCHAR(350) NULL,
	CONSTRAINT ClaseConcurso_PK PRIMARY KEY CLUSTERED (CoClaseConcurso ASC)
)
GO
CREATE TABLE Raza (
	CoRaza INT IDENTITY(1,1) NOT NULL,
	NoRaza VARCHAR(50) NOT NULL,
	TxtReseniaHistorica VARCHAR(500) NOT NULL, 
	TxAparienciaGeneral VARCHAR(500) NOT NULL,
	TxAptitudesResaltantes VARCHAR(500)  NULL,
	TxOtrosAtributosRaza VARCHAR(500) NULL,
	CoGrupo INT NOT NULL
	CONSTRAINT Raza_PK PRIMARY KEY CLUSTERED (CoRaza ASC),
	CONSTRAINT Raza_Grupo_FK FOREIGN KEY(CoGrupo) REFERENCES Grupo 
)
GO
CREATE TABLE Ejemplar (
	CoEjemplar INT IDENTITY(1,1) NOT NULL,
	NoEjemplar VARCHAR(50) NOT NULL,
	CoMicroship CHAR(10) NOT NULL,
	NoPropietario VARCHAR(50) NOT NULL,
	FeNacimiento DATE NOT NULL,
	TxLugarNacimiento VARCHAR(50) NOT NULL,
	FlSexo CHAR(1) NOT NULL,
	NuEdadEjemplar INT NOT NULL,
	CoRaza INT NOT NULL,
	CoPadre INT NULL,
	CoMadre INT NULL,
	CONSTRAINT Ejemplar_PK PRIMARY KEY CLUSTERED (CoEjemplar ASC),
	CONSTRAINT Ejemplar_Raza_FK FOREIGN KEY (CoRaza) REFERENCES Raza,
	CONSTRAINT Ejemplar_Padre_FK FOREIGN KEY (CoPadre) REFERENCES Ejemplar,
	CONSTRAINT Ejemplar_Madre_FK FOREIGN KEY (CoMadre) REFERENCES Ejemplar,
	CONSTRAINT FeNacimiento_CK CHECK (FeNacimiento > '20150101'),
	CONSTRAINT NuEdadEjemplar_CK CHECK (NuEdadEjemplar >= 90),
	CONSTRAINT FlSexo_CK CHECK (FlSexo IN ('M', 'H'))
)
GO
CREATE TABLE Concurso (
	CoConcurso INT IDENTITY(1,1) NOT NULL,
	NoConcurso VARCHAR(50) NOT NULL,
	NoEntidadOrganizadora VARCHAR(50) NOT NULL,
	FeRealizacion DATE NOT NULL, 
	NoCiudad VARCHAR(50) NOT NULL, 
	CoClaseConcurso INT NOT NULL,
	CoDirector INT NOT NULL,
	CONSTRAINT Concurso_PK PRIMARY KEY CLUSTERED (CoConcurso ASC),
	CONSTRAINT ConCurso_ClaseConcurso_FK FOREIGN KEY (CoClaseConcurso) REFERENCES ClaseConcurso, 
	CONSTRAINT ConCurso_Director_FK FOREIGN KEY (CoDirector) REFERENCES Director, 
)
GO
CREATE TABLE Concurso_Categoria(
	CoCategoria INT NOT NULL,
	CoConcurso INT NOT NULL,
	SsTarifaInscripcionCategoria MONEY NOT NULL,
	CONSTRAINT Concurso_Categoria_PK PRIMARY KEY CLUSTERED (CoCategoria, CoConcurso),
	CONSTRAINT Concurso_Categoria_Concurso_FK FOREIGN KEY (CoConcurso) REFERENCES Concurso,
	CONSTRAINT Concurso_Categoria_Categoria_FK FOREIGN KEY (CoCategoria) REFERENCES Categoria,
	CONSTRAINT SsTarifaInscripcionCategoria_CK CHECK (SsTarifaInscripcionCategoria > 0 and SsTarifaInscripcionCategoria < 200) 
)
GO
CREATE TABLE ParticipacionConcurso(
	NuParticipacionConcurso INT NOT NULL,
	CoCategoria INT NOT NULL, 
	CoConcurso INT NOT NULL, 
	NoManejador VARCHAR(50) NOT NULL,
	TxCalificacion VARCHAR(20) NULL,
	NuPuesto INT NULL,
	CoEjemplar INT NOT NULL,
	CONSTRAINT ParticipacionConcurso_PK PRIMARY KEY CLUSTERED (NuParticipacionConcurso, CoCategoria, CoConcurso),
	CONSTRAINT ParticipacionConcurso_Concurso_Categoria_FK FOREIGN KEY (CoCategoria, CoConcurso) REFERENCES Concurso_Categoria,
	CONSTRAINT ParticipacionConcurso_Ejemplar_FK FOREIGN KEY (CoEjemplar) REFERENCES Ejemplar,
	CONSTRAINT NuPuesto_CK CHECK (NuPuesto > 0),
	CONSTRAINT TxCalificacion_CK CHECK (TxCalificacion IN ('Excelente','Muy bueno','Bueno','Suficiente','Descalificado','Dispensado'))
)
GO
CREATE TABLE Concurso_Comisario(
	CoConcurso INT NOT NULL,
	CoComisario INT NOT NULL,
	CONSTRAINT Concurso_Comisario_PK PRIMARY KEY CLUSTERED (CoConcurso, CoComisario),
	CONSTRAINT Concurso_Comisario_Comisario_FK FOREIGN KEY (CoComisario) REFERENCES Comisario,
	CONSTRAINT Concurso_Comisario_Concurso_FK FOREIGN KEY (CoConcurso) REFERENCES Concurso
)
GO
CREATE TABLE Concurso_Juez(
	CoConcurso INT NOT NULL,
	CoJuez INT NOT NULL,
	CONSTRAINT Concurso_Juez_PK PRIMARY KEY CLUSTERED (CoConcurso, CoJuez),
	CONSTRAINT Concurso_Juez_Juez_FK FOREIGN KEY (CoJuez) REFERENCES Juez,
	CONSTRAINT Concurso_Juez_Concurso_FK FOREIGN KEY (CoConcurso) REFERENCES Concurso
)
GO
CREATE TABLE Ejemplar_Certificado (
	NuParticipacionConcurso INT NOT NULL,
	CoCategoria INT NOT NULL,
	CoConcurso INT NOT NULL,
	CoEjemplar INT NOT NULL,
	CoCertificado CHAR(6) NOT NULL,
	CONSTRAINT Ejemplar_Certificado_PK PRIMARY KEY CLUSTERED (NuParticipacionConcurso, CoCategoria, CoConcurso, CoEjemplar, CoCertificado),
	CONSTRAINT Ejemplar_Certificado_ParticipacionConcurso_FK FOREIGN KEY (NuParticipacionConcurso, CoCategoria, CoConcurso) REFERENCES ParticipacionConcurso,
	CONSTRAINT Ejemplar_Certificado_Ejemplar_FK FOREIGN KEY (CoEjemplar) REFERENCES Ejemplar,
	CONSTRAINT Ejemplar_Certificado_Certificado_FK FOREIGN KEY (CoCertificado) REFERENCES Certificado
)
GO
CREATE TABLE Certificado_ClaseConcurso(
	CoClaseConcurso INT NOT NULL,
	CoCertificado CHAR(6) NOT NULL,
	CONSTRAINT Certificado_ClaseConcurso_PK PRIMARY KEY CLUSTERED (CoClaseConcurso, CoCertificado),
	CONSTRAINT Certificado_ClaseConcurso_Certificado_FK FOREIGN KEY (CoCertificado) REFERENCES Certificado,
	CONSTRAINT Certificado_ClaseConcurso_ClaseConcurso_FK FOREIGN KEY (CoClaseConcurso) REFERENCES ClaseConcurso
)
GO
CREATE TABLE Caracteristica_Raza(
	CoCaracteristica INT NOT NULL,
	CoRaza INT NOT NULL,
	TxDescripcionCaracteristica VARCHAR(200) NULL,
	CONSTRAINT Caracteristica_Raza_PK PRIMARY KEY CLUSTERED (CoCaracteristica, CoRaza),
	CONSTRAINT Caracteristica_Raza_Caracteristica_FK FOREIGN KEY (CoCaracteristica) REFERENCES Caracteristica,
	CONSTRAINT Caracteristica_Raza_Raza_FK FOREIGN KEY (CoRaza) REFERENCES Raza
)
GO
CREATE TABLE Raza_Concurso(
	CoConcurso INT NOT NULL,
	CoRaza  INT NOT NULL,
	CONSTRAINT Raza_Concurso_PK PRIMARY KEY CLUSTERED (CoConcurso, CoRaza),
	CONSTRAINT Raza_Concurso_Concurso_FK FOREIGN KEY (CoConcurso) REFERENCES Concurso,
	CONSTRAINT Raza_Concurso_Raza_FK FOREIGN KEY (CoRaza) REFERENCES Raza
)
GO
----- Scripts para los inserts en las tablas de la BD
SET IDENTITY_INSERT Caracteristica ON
GO
INSERT Caracteristica (CoCaracteristica, NoCaracteristica) VALUES 
(1, 'cabeza'),
(2, 'cráneo'),
(3, 'orejas'),
(4, 'cola'),
(5, 'mandíbula'),
(6, 'color'),
(7, 'extremidades')
GO
SET IDENTITY_INSERT Caracteristica OFF
GO
SET IDENTITY_INSERT Categoria ON
GO
INSERT Categoria (CoCategoria, NoCategoria, NuEdadMinima, NuEdadMaxima) VALUES 
(1, 'Cachorros A', 91, 180),
(2, 'Cachorros B', 181, 270),
(3, 'Jóvenes', 271, 540),
(4, 'Adultos', 541, 3000)
GO
SET IDENTITY_INSERT Categoria OFF
GO
INSERT Certificado (CoCertificado, TxDescripcionCertificado) VALUES 
('COLACB','COLACB - certificado de aptitud al campeonato latinoamericano de belleza'),
('CACIB','CACIB - certificado de aptitud de campeonato internacional de belleza'),
('CAJP','CAJP - certificado de aptitud al campeón joven peruano')
GO
SET IDENTITY_INSERT ClaseConcurso ON
GO
INSERT ClaseConcurso (CoClaseConcurso, NoClaseConcurso, TxDescripcionClaseConcurso) VALUES 
(1, 'Clase Concurso 1', 'Clase 1'),
(2, 'Clase Concurso 2', 'Clase 2'),
(3, 'Clase Concurso 3', 'Clase 3')
GO
SET IDENTITY_INSERT ClaseConcurso OFF
GO
SET IDENTITY_INSERT Comisario ON
GO
INSERT Comisario (CoComisario, NoComisario, ApeComisario, FeNacimientoComisario, FISexoComisario) VALUES 
(1, 'Marco Antonio','Trejo Lemus','19901108', 'M'),
(2, 'Laura Lucero','Sobrevilla Trejo', '19920605', 'F'),
(3, 'Maria de la luz','Trejo Campos', '19850203', 'F'),
(4, 'Trinidad','Trejo Bautista','19780117','F'),
(5, 'Marcel', 'Sobrevilla Trejo','19861109', 'F'),
(6, 'Daniel', 'Andela Campos', '19950908', 'M'),
(7, 'Miguel','Hernandez Quispe', '19980112','M')
GO
SET IDENTITY_INSERT Comisario OFF
GO
INSERT Certificado_ClaseConcurso(CoClaseConcurso, CoCertificado) VALUES 
(1, 'COLACB'),
(1, 'CACIB'),
(1, 'CAJP'),
(2, 'COLACB'),
(2, 'CACIB'),
(2, 'CAJP'),
(3, 'COLACB'),
(3, 'CACIB'),
(3, 'CAJP')
GO
SET IDENTITY_INSERT Director ON
GO
INSERT Director (CoDirector, NoDirector, ApeDirector, FeNacimientoDirector, FISexoDirector) VALUES 
(1, 'Fernando','Soria Gutierrez', '19920302', 'M'),
(2, 'Daniel','Zambujo Conde','19900508','M'),
(3, 'Pedro','Manzano Galvez', '19650921','M'),
(4, 'Juana','Montero Robles','19751115','F'),
(5, 'Ricardo','Gómez Hinostroza','19850302','M'),
(6, 'Elena','García Peña','20000306','F'),
(7, 'Juan','Perez Ortega','19950609','M')
GO
SET IDENTITY_INSERT Director OFF
GO
SET IDENTITY_INSERT Grupo ON
GO
INSERT Grupo (CoGrupo, NoGrupo, TxDescripcionGrupo) VALUES 
(1, 'Perros de pastoreo', 'Perros entrenados para ayudar a pastorear y proteger el ganado.'),
(2, 'Perros boyeros', 'Perros utilizados para guiar y controlar ganado, especialmente en granjas.'),
(3, 'Terriers de talla grande y mediana', 'Terriers con mayor tamaño, conocidos por su valentía y habilidades de caza.'),
(4, 'Perros de compañía', 'Perros criados para vivir con humanos y ofrecer compañía y apoyo emocional.')
GO
SET IDENTITY_INSERT Grupo OFF
GO
SET IDENTITY_INSERT Concurso ON
GO
INSERT Concurso (CoConcurso, NoConcurso, NoEntidadOrganizadora, FeRealizacion, NoCiudad, CoClaseConcurso, CoDirector) VALUES 
(1, 'Concurso Primavera', 'Kennel Club del Perú', CAST('2023-10-01' AS Date), 'Lima', 1, 4),
(2, 'Concurso Verano', 'Kennel Club del Perú', CAST('2024-01-05' AS Date), 'Lima', 1, 3),
(3, 'Concurso Invierno', 'Kennel Club del Perú', CAST('2024-06-15' AS Date), 'Lima', 1, 2),
(4, 'Concruso Otoño', 'Kennel Club del Perú', CAST('2024-04-01' AS Date), 'Lima', 1, 1)
GO
SET IDENTITY_INSERT Concurso OFF
GO
INSERT Concurso_Comisario(CoConcurso, CoComisario) VALUES 
(1, 1),
(1, 2),
(2, 3),
(2, 4),
(3, 5),
(3, 6),
(4, 1),
(4, 7)
GO
INSERT Concurso_Categoria (CoCategoria, CoConcurso, SsTarifaInscripcionCategoria) VALUES 
(1, 1, 100),
(1, 2, 90),
(1, 3, 50),
(1, 4, 40),
(2, 1, 100),
(2, 2, 90),
(2, 3, 50),
(2, 4, 40),
(3, 1, 100),
(3, 2, 90),
(3, 3, 50),
(3, 4, 40),
(4, 1, 100),
(4, 2, 90),
(4, 3, 50),
(4, 4, 40)
GO
SET IDENTITY_INSERT Raza ON
GO
INSERT Raza(CoRaza, NoRaza, TxtReseniaHistorica, TxAparienciaGeneral, TxAptitudesResaltantes, TxOtrosAtributosRaza, CoGrupo) VALUES 
(1, 'Pastor Aleman', 'Sus orígenes se remontan a finales del siglo XIX, cuando en Alemania se inició un programa de crianza para guarda y protección de los rebaños de carneros en contra de los lobos. El capitán de caballería del ejército alemán, Maximilian von Stephanitz, es considerado el padre de la raza', 'robusto y flexible, ligeramente alargado, cuerpo musculoso, sus mandíbulas deben cerrar en tijera. Es un perro de compañía muy bueno con los niños ya que es un perro muy equilibrado y fácil de adiestrar.', NULL, NULL, 1),
(2, 'Dóberman', 'Esta raza debe su nombre a Karl Friedrich Louis Dobermann, un vigilante nocturno y recaudador de impuestos que entre 1834 y 1894, se encargaba de la custodia de una perrera en la ciudad de Apolda (Turingia, Alemania).', 'Tiene el cuerpo cuadrado, la cabeza tiene los planos del hocico y del cráneo paralelos, depresión frontonasal (stop) muy ligera, ojos pequeños y oscuros. Orejas de inserción alta, cuello largo y elegante, el cuerpo es musculoso, aunque no se le note, con los miembros rectos, la línea superior es recta y el pelo corto pegado al cuerpo.', NULL, NULL, 1),
(3, 'Bóxer', 'La mayoría de los historiadores caninos están de acuerdo en que los ancestros de los bóxer son los perros bullenbeisser. Estos bullenbeissers (o mordedores de toros) eran perros de caza, usados sobre todo para el jabalí y el ciervo. Tales expediciones para la caza de animales salvajes solían costar la vida a varios perros, ya que la caza era horrible y penosa tanto para las personas como para los perros', 'Entre sus rasgos físicos se encuentran una cabeza fuerte, mandíbula inferior prognática, cuya presión mandibular es generalmente de 122 kg/cm', NULL, NULL, 1)
GO
SET IDENTITY_INSERT Raza OFF
GO
INSERT Raza_Concurso (CoRaza, CoConcurso) VALUES 
(1, 1),
(1, 2),
(1, 3),
(2, 1),
(2, 2),
(2, 3),
(3, 1),
(3, 2),
(3, 3)
GO
SET IDENTITY_INSERT Juez ON
GO
INSERT Juez(CoJuez, NoJuez, ApeJuez, FeNacimientoJuez, FISexoJuez, FIAcreditacionJuez) VALUES 
(1, 'John', 'Smith', '19900811', 'M', 'N'),
(2, 'Alexander', 'Dominguez', '19910203', 'M', 'I'),
(3, 'Fidel', 'Martinez', '19820506', 'M', 'I'),
(4, 'Renato', 'Ibarra', '19850206', 'M', 'N'),
(5, 'Jaime', 'Ayovi', '19920608', 'M', 'I'),
(6, 'Carlos', 'Gruezo', '19991018', 'M', 'N'),
(7, 'Edison', 'Mendez', '19751119', 'M', 'I')
GO
SET IDENTITY_INSERT Juez OFF
GO
INSERT Concurso_Juez(CoJuez, CoConcurso) VALUES 
(1, 1),
(1, 3),
(2, 1),
(2, 2),
(3, 1),
(3, 2),
(3, 3),
(4, 1),
(4, 2),
(5, 1),
(5, 2),
(6, 1),
(6, 2),
(7, 1),
(7, 2)
GO
SET IDENTITY_INSERT Ejemplar ON
GO
INSERT Ejemplar (CoEjemplar, NoEjemplar, CoMicroship, NoPropietario, FeNacimiento, TxLugarNacimiento, FlSexo, NuEdadEjemplar, CoPadre, CoMadre, CoRaza) VALUES
(1,'Max Quiatra','878JU89', 'Samuel Jackson', CAST('20231210' AS Date), 'Lima - Perú', 'M', 131 , NULL, NULL, 1),
(2, 'Mia', '364ND29', 'Gillermo del Toro', CAST('20240103' AS Date), 'Ica - Perú', 'H', 107 ,NULL, NULL, 2),
(3, 'Kiara', '283LP32','Ramon de la Fuente', CAST('20231214' AS Date), 'Lima - Perú', 'H', 127,NULL, NULL, 2),
(4, N'Zeus', '989KO29','Eduardo Perez', CAST('20230815' AS Date), 'Lima - Perú', 'M', 248 ,NULL, NULL, 3),
(5, N'Sasha','123DF34', 'Teresa García', CAST('20221010' AS Date), 'Lima - Perú', 'H', 557 ,NULL, NULL, 1),
(6, N'Maya', '090CX90','Roberto Lopez', CAST('20221120' AS Date), 'Lima - Perú', 'H', 516,NULL, NULL, 2),
(7, N'Toby','273KK21', 'Alvaro Medina', CAST('20231230' AS Date), 'Lima - Perú', 'M', 111 ,NULL, NULL, 1)
GO
SET IDENTITY_INSERT Ejemplar OFF
GO
INSERT ParticipacionConcurso(NuParticipacionConcurso, CoEjemplar, NoManejador, NuPuesto, TxCalificacion, CoCategoria, CoConcurso) VALUES 
(1, 1, 'Samuel Jackson', 1, 'Muy bueno', 2, 1),
(2, 2, 'Gillermo del Toro', 2, 'Bueno', 2, 1),
(3, 3, 'Ramon de la Fuente', 3, 'Suficiente', 2, 1),
(4, 4, 'Eduardo Perez', 1, 'Muy bueno', 2, 2),
(5, 5, 'Teresa García', 2, 'Bueno', 2, 2),
(6, 6, 'Roberto Lopez', 3, 'Suficiente', 2, 2),
(7, 7, 'Alvaro Medina', 4, 'Dispensado', 2, 2)
GO
INSERT Caracteristica_Raza(TxDescripcionCaracteristica, CoRaza, CoCaracteristica) VALUES 
('Cabeza', 1, 1),
('Craneo', 1, 2),
('Orejas', 1, 3),
('Cola', 1, 4),
('Mandíbula', 1, 5),
('Color', 1, 6),
('Extremidades', 1, 7),
('Cabeza', 2, 1),
('Craneo', 2, 2),
('Orejas', 2, 3),
('Cola', 2, 4),
('Mandíbula', 2, 5),
('Color', 2, 6),
('Extremidades', 2, 7),
('Cabeza', 3, 1),
('Craneo', 3, 2),
('Orejas', 3, 3),
('Cola', 3, 4),
('Mnadíbula', 3, 5),
('Color', 3, 6),
('Extremidades', 3, 7)
GO
INSERT Ejemplar_Certificado (CoCertificado, CoEjemplar, NuParticipacionConcurso, CoCategoria, CoConcurso) VALUES 
('COLACB', 1, 1, 2, 1),
('CACIB', 4, 4, 2, 2)
GO
