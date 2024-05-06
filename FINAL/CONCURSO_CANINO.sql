USE master
GO

GO
IF DB_ID('ConcursoCanino') IS NOT NULL
	alter database ConcursoCanino set single_user with rollback immediate
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
	CONSTRAINT ParticipacionConcurso_NuParticipacionConcurso UNIQUE(NuParticipacionConcurso),
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
(7, 'Miguel','Hernandez Quispe', '19980112','M'),
(8, 'Sofía', 'García López', '19901025', 'F'),
(9, 'Diego', 'Martínez García', '19870415', 'M'),
(10, 'Ana', 'Fernández Rodríguez', '19930228', 'F');
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
(1,'Perros Pastores y Boyeros', 'Perros que tradicionalmente se han utilizado para pastorear ganado y trabajar como perros boyeros.'),
(2,'Perros de Tipo Pinscher y Schnauzer, Molosoides, Perros Tipo Montaña y Boyeros Suizos.', 'Este grupo abarca una variedad de razas, desde los pequeños Pinschers y Schnauzers hasta los grandes Molosos y Boyeros Suizos.'),
(3, 'Terriers', 'Este grupo incluye razas terrier que se caracterizan por su valentía y habilidades de caza'),
(4, 'Teckels', 'Son perros también conocidos como Dachshunds o perros salchicha, que son conocidos por sus cuerpos largos y bajos.'),
(5, 'Perros tipo Spitz y tipo Primitivo', 'Este grupo incluye razas de perros tipo spitz y primitivas que a menudo tienen características físicas distintivas, como orejas puntiagudas y colas enroscadas.'),
(6, 'Sabuesos y Perros de Rastro y Razas Afines', 'Este grupo incluye razas de perros utilizadas para rastrear y cazar presas.'),
(7, 'Perros de Muestra y Cobradores', 'Este grupo incluye razas que tradicionalmente se han utilizado para la caza y recuperación de aves'),
(8,'Perros Cobradores de Agua', 'Este grupo incluye razas de perros que históricamente han sido utilizadas para recuperar presas de agua'),
(9, 'Perros de Compañía', 'Este grupo incluye razas de perros que se crían principalmente para ser compañeros de vida.'),
(10, 'Lebreles', 'Este grupo incluye razas de perros lebreles que históricamente se han utilizado para cazar presas a alta velocidad')
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
(101,'Pastor Alemán', 'El Pastor Alemán es una raza de perro originaria de Alemania, conocida por su inteligencia y versatilidad. Se crió originalmente para pastorear ovejas, pero también ha sido utilizada en diversas funciones, como perro policía, perro de búsqueda y rescate, perro guía para ciegos, entre otros.', 'El Pastor Alemán es un perro de tamaño mediano a grande, musculoso y bien proporcionado. Tiene una cabeza en forma de cuña con orejas erguidas, ojos oscuros y expresivos, y una cola larga y peluda. Su pelaje es doble y puede ser de diferentes colores, siendo el negro y fuego el más común.', 'Entre las aptitudes resaltantes del Pastor Alemán se encuentran su inteligencia, lealtad, valentía y capacidad de trabajo. Son excelentes perros de trabajo y compañía, capaces de aprender rápidamente y adaptarse a diversas situaciones.', 'El Pastor Alemán requiere ejercicio regular y estimulación mental para mantenerse feliz y saludable. Es importante una socialización temprana y un entrenamiento consistente para mantener su equilibrio emocional y comportamiento estable.', 1),
(102, 'Border Collie', 'El Border Collie es una raza de perro originaria de la frontera entre Escocia e Inglaterra, conocida por su excepcional inteligencia y habilidades en el trabajo con ovejas. Es considerado uno de los perros pastores más trabajadores y versátiles del mundo.', 'El Border Collie es un perro de tamaño mediano, ágil y atlético, con una expresión alerta e inteligente. Su pelaje puede ser de diferentes colores, siendo el negro y blanco el más común. Tiene una cola larga y peluda que suele llevar en posición baja.', 'Las aptitudes resaltantes del Border Collie incluyen su extraordinaria inteligencia, agilidad, resistencia y capacidad de aprendizaje. Son perros altamente motivados para el trabajo y la actividad física, pero también pueden ser excelentes compañeros de vida para personas activas y dedicadas.', 'El Border Collie requiere una estimulación mental y física adecuada para mantenerse feliz y saludable. Necesitan actividades que desafíen su mente, como el entrenamiento de obediencia, el agility y el pastoreo.', 1),
(103, 'Rottweiler', 'El Rottweiler es una raza de perro antigua originaria de Alemania, utilizada históricamente como perro de pastoreo y de trabajo. Se destaca por su fuerza, valentía y lealtad hacia su familia.', 'El Rottweiler es un perro de tamaño grande y musculoso, con una cabeza ancha y orejas triangulares caídas. Su pelaje es corto y denso, generalmente de color negro con marcas marrones o rojizas en las patas, pecho y hocico. Tiene una cola que se amputa tradicionalmente.', 'Entre las aptitudes resaltantes del Rottweiler se encuentran su lealtad, valentía, confianza y determinación. Son perros de trabajo y protección muy capaces, pero también pueden ser compañeros leales y afectuosos en el hogar.', 'El Rottweiler necesita una socialización temprana y un entrenamiento firme y consistente para desarrollar un comportamiento equilibrado y estable. Requiere ejercicio regular y actividades que estimulen su mente para mantenerse física y mentalmente saludable.', 1),
(104, 'Pastor de Anatolia', 'El Pastor de Anatolia es una raza de perro antigua originaria de Turquía, utilizada tradicionalmente como perro guardián de ganado. Es conocido por su fuerza, resistencia y habilidades protectoras.', 'El Pastor de Anatolia es un perro grande y poderoso, con una estructura ósea robusta y musculatura bien desarrollada. Tiene una cabeza grande y ancha, orejas triangulares caídas y una cola larga y peluda que lleva enroscada sobre su espalda. Su pelaje es denso y puede ser de varios colores, incluyendo el blanco, crema, gris y atigrado.', 'Entre las aptitudes resaltantes del Pastor de Anatolia se encuentran su valentía, lealtad, instinto protector y capacidad para trabajar en condiciones difíciles. Son perros guardianes confiables y eficientes, capaces de proteger el ganado y el hogar de intrusos y depredadores.', 'El Pastor de Anatolia requiere una socialización temprana y un entrenamiento firme y consistente para desarrollar un comportamiento equilibrado y estable. Necesitan mucho espacio y ejercicio para mantenerse saludables y felices.', 1),
(105, 'Pastor Australiano', 'El Pastor Australiano es una raza de perro originaria de Estados Unidos, a pesar de su nombre. Se crió para pastorear ganado, especialmente ovejas, y es conocido por su inteligencia, energía y agilidad.', 'El Pastor Australiano es un perro de tamaño mediano, atlético y bien proporcionado, con una expresión alerta e inteligente. Tiene un pelaje de longitud media a larga, con una variedad de colores y patrones, incluyendo el azul merle, negro, rojo y tricolor. Sus ojos suelen ser de colores diferentes, lo que le da una apariencia distintiva.', 'Entre las aptitudes resaltantes del Pastor Australiano se encuentran su inteligencia, energía, agilidad y lealtad. Son perros de trabajo altamente motivados y versátiles, capaces de realizar una variedad de tareas en el campo y en competiciones de deportes caninos.', 'El Pastor Australiano necesita una estimulación mental y física adecuada para evitar el aburrimiento y comportamientos no deseados. Requiere ejercicio regular y actividades que desafíen su mente, como el pastoreo y el agility.', 1),
(201, 'Doberman', 'El Doberman es una raza de perro de origen alemán. Fue desarrollado a finales del siglo XIX por Karl Friedrich Louis Dobermann, un recaudador de impuestos de Alemania, con la intención de crear un perro guardián feroz y leal.', 'El Doberman es un perro de tamaño mediano a grande, de constitución musculosa y elegante. Tiene una cabeza larga y plana, orejas erguidas y cortadas, y una cola corta y natural. Su pelaje es corto, liso y de color negro y fuego.', 'El Doberman es conocido por su inteligencia, valentía y lealtad hacia su familia. Es un excelente perro guardián y de protección, pero también puede ser cariñoso y afectuoso con sus seres queridos.', 'El Doberman requiere ejercicio regular y entrenamiento adecuado para mantener su mente y cuerpo activos. También necesita socialización temprana para ser un buen compañero de vida.', 2),
(202, 'Boxer', 'El Boxer es una raza de perro de origen alemán. Se desarrolló a finales del siglo XIX a partir de antiguas razas de perros de pelea europeas, como el Bullenbeisser y el Bulldog.', 'El Boxer es un perro de tamaño mediano, de constitución musculosa y atlética. Tiene una cabeza ancha y cuadrada, orejas erguidas y cortadas, y una cola corta y natural. Su pelaje es corto, liso y de color leonado o atigrado.', 'El Boxer es conocido por su valentía, energía y lealtad hacia su familia. Es un excelente perro guardián y de protección, pero también puede ser juguetón y afectuoso con los niños.', 'El Boxer requiere ejercicio regular y entrenamiento adecuado para mantener su mente y cuerpo activos. También necesita socialización temprana para ser un buen compañero de vida.', 2),
(203, 'Gran Danés', 'El Gran Danés es una raza de perro de origen alemán. Se cree que se desarrolló a partir de antiguas razas de perros de caza utilizadas en Europa Central para cazar jabalíes y ciervos.', 'El Gran Danés es un perro gigante, de constitución musculosa y poderosa. Tiene una cabeza grande y cuadrada, orejas caídas y colgadas, y una cola larga y gruesa. Su pelaje es corto, liso y de color leonado, atigrado, negro o azul.', 'El Gran Danés es conocido por su nobleza, gentileza y afecto hacia su familia. A pesar de su tamaño imponente, es un perro amable y cariñoso, especialmente con los niños.', 'El Gran Danés requiere ejercicio regular y entrenamiento adecuado debido a su tamaño. También necesita socialización temprana para ser un buen compañero de vida.', 2),
(204, 'San Bernardo', 'El San Bernardo es una raza de perro de origen suizo. Se desarrolló en los Alpes suizos como un perro de rescate utilizado por los monjes del Hospicio de San Bernardo para ayudar a los viajeros perdidos en la montaña.', 'El San Bernardo es un perro gigante, de constitución musculosa y robusta. Tiene una cabeza grande y ancha, orejas caídas y colgadas, y una cola larga y gruesa. Su pelaje es largo, denso y de color blanco y rojo.', 'El San Bernardo es conocido por su amabilidad, gentileza y devoción hacia las personas. Es un excelente perro de compañía y de familia, especialmente para los niños.', 'El San Bernardo requiere ejercicio moderado y cuidado regular de su pelaje y piel. También necesita socialización temprana para ser un buen compañero de vida.', 2),
(205, 'Dogo Argentino', 'El Dogo Argentino es una raza de perro de origen argentino. Se desarrolló a principios del siglo XX por el Dr. Antonio Nores Martínez, un médico argentino, con la intención de crear un perro de caza versátil y poderoso.', 'El Dogo Argentino es un perro de tamaño grande, de constitución musculosa y atlética. Tiene una cabeza grande y ancha, orejas caídas y colgadas, y una cola larga y gruesa. Su pelaje es corto, liso y de color blanco.', 'El Dogo Argentino es conocido por su valentía, tenacidad y lealtad hacia su familia. Es un excelente perro de caza mayor, guarda y protección, pero también puede ser cariñoso y afectuoso con los niños.', 'El Dogo Argentino requiere ejercicio regular y entrenamiento adecuado para mantener su mente y cuerpo activos. También necesita socialización temprana para ser un buen compañero de vida.', 2),
(301, 'Scottish Terrier', 'El Scottish Terrier es una raza de perro originaria de Escocia, conocida por su apariencia distintiva y personalidad valiente. Se crió originalmente para la caza de animales pequeños, como tejones y zorros, en las tierras altas de Escocia.', 'El Scottish Terrier es un perro de tamaño pequeño a mediano, compacto y musculoso, con una cabeza larga y estrecha, orejas pequeñas y erguidas, y una cola corta. Su pelaje es duro y áspero, con una capa exterior resistente a la intemperie y una capa interna suave.', 'Entre las aptitudes resaltantes del Scottish Terrier se encuentran su valentía, tenacidad y lealtad. A pesar de su tamaño, son perros valientes y decididos, capaces de enfrentarse a animales mucho más grandes. También son excelentes compañeros de vida y protectores de su familia.', 'El Scottish Terrier requiere ejercicio regular y estimulación mental para mantenerse feliz y saludable. Su pelaje necesita cuidados regulares, incluyendo cepillado y recorte para mantener su apariencia y salud.', 3),
(302, 'Bull Terrier', 'El Bull Terrier es una raza de perro originaria de Inglaterra, desarrollada a principios del siglo XIX para la pelea de perros y luego refinada para ser un compañero de vida. Es conocido por su cabeza única y personalidad juguetona.', 'El Bull Terrier es un perro de tamaño mediano, musculoso y atlético, con una cabeza grande y redondeada y orejas pequeñas y erguidas. Su pelaje es corto y brillante, y puede ser de varios colores, incluyendo el blanco, atigrado y tricolor. Tiene una cola corta que se lleva en posición horizontal.', 'Entre las aptitudes resaltantes del Bull Terrier se encuentran su energía, lealtad y afecto hacia su familia. Son perros juguetones y divertidos, pero también pueden ser protectores y valientes cuando sea necesario.', 'El Bull Terrier requiere ejercicio regular y actividades que estimulen su mente para evitar el aburrimiento y comportamientos destructivos. También necesitan socialización temprana y entrenamiento consistente para desarrollar un comportamiento equilibrado y estable.', 3),
(303, 'West Highland White Terrier', 'El West Highland White Terrier, también conocido como Westie, es una raza de perro originaria de Escocia, desarrollada para la caza de animales pequeños, como ratones y tejones. Es conocido por su pelaje blanco y personalidad vivaz.', 'El West Highland White Terrier es un perro de tamaño pequeño, compacto y robusto, con una cabeza ancha y redondeada, orejas pequeñas y erguidas, y una cola corta y recta. Su pelaje es duro y áspero, con una capa exterior blanca y una capa interna suave.', 'Entre las aptitudes resaltantes del West Highland White Terrier se encuentran su valentía, inteligencia y afecto hacia su familia. A pesar de su tamaño, son perros decididos y valientes, capaces de enfrentarse a animales más grandes.', 'El West Highland White Terrier requiere ejercicio regular y actividades que estimulen su mente para mantenerse feliz y saludable. Su pelaje necesita cuidados regulares, incluyendo cepillado y recorte para mantener su apariencia y salud.', 3),
(304, 'Airedale Terrier', 'El Airedale Terrier es una raza de perro originaria de Inglaterra, conocida como el "Rey de los Terriers" debido a su tamaño y habilidades versátiles. Se crió originalmente para la caza de animales grandes, como nutrias y tejones.', 'El Airedale Terrier es un perro de tamaño mediano a grande, musculoso y bien proporcionado, con una cabeza larga y estrecha, orejas pequeñas y erguidas, y una cola larga que se lleva en alto. Su pelaje es duro y áspero, con una capa exterior resistente y una capa interna suave.', 'Entre las aptitudes resaltantes del Airedale Terrier se encuentran su valentía, inteligencia y versatilidad. Son perros enérgicos y activos, capaces de desempeñarse en una variedad de roles, incluyendo perro guardián, perro de trabajo y compañero de vida.', 'El Airedale Terrier requiere ejercicio regular y estimulación mental para mantenerse feliz y saludable. Su pelaje necesita cuidados regulares, incluyendo cepillado y recorte para mantener su apariencia y salud.', 3),
(305, 'Staffordshire Bull Terrier', 'El Staffordshire Bull Terrier es una raza de perro originaria de Inglaterra, desarrollada para la pelea de toros y luego refinada para ser un compañero de vida. Es conocido por su fuerza, coraje y afecto hacia su familia.', 'El Staffordshire Bull Terrier es un perro de tamaño mediano, musculoso y compacto, con una cabeza ancha y redondeada, orejas pequeñas y erguidas, y una cola corta. Su pelaje es corto y denso, y puede ser de varios colores, incluyendo el rojo, atigrado y blanco.', 'Entre las aptitudes resaltantes del Staffordshire Bull Terrier se encuentran su fuerza, coraje y afecto hacia su familia. A pesar de su pasado como perro de pelea, son perros amables y cariñosos, especialmente con los niños.', 'El Staffordshire Bull Terrier requiere ejercicio regular y actividades que estimulen su mente para mantenerse feliz y saludable. También necesitan socialización temprana y entrenamiento consistente para desarrollar un comportamiento equilibrado y estable.', 3),
(401, 'Dachshund (perro salchicha)', 'El Dachshund, también conocido como perro salchicha, es una raza de perro originaria de Alemania, criada para la caza de animales pequeños, como tejones y conejos. Su nombre se traduce como "perro texugo".', 'El Dachshund es un perro de tamaño pequeño a mediano, con un cuerpo largo y bajo, patas cortas y orejas largas y caídas. Tiene una cola larga y delgada, y su pelaje puede ser de tres tipos: pelo corto, pelo largo o pelo duro. Los colores más comunes son el rojo, el negro y el marrón.', 'Entre las aptitudes resaltantes del Dachshund se encuentran su valentía, inteligencia y tenacidad. A pesar de su tamaño, son perros valientes y decididos, capaces de enfrentarse a animales mucho más grandes. También son excelentes cazadores y compañeros de vida.', 'El Dachshund requiere ejercicio regular y actividades que estimulen su mente para mantenerse feliz y saludable. Su pelaje necesita cuidados regulares, incluyendo cepillado y recorte para mantener su apariencia y salud.', 4),
(402, 'Teckel de pelo duro', 'El Teckel de pelo duro es una variedad de la raza Dachshund, reconocida por su pelaje áspero y denso. Se utiliza principalmente para la caza de animales pequeños en terrenos difíciles, como bosques y matorrales.', 'El Teckel de pelo duro es similar al Dachshund estándar en términos de tamaño y forma, con un cuerpo largo y bajo, patas cortas y orejas largas y caídas. Su pelaje es áspero y denso, con una capa exterior resistente y una capa interna suave.', 'Al igual que el Dachshund estándar, el Teckel de pelo duro es valiente, inteligente y tenaz. Son excelentes cazadores y compañeros de vida, capaces de enfrentarse a animales más grandes con determinación y coraje.', 'El Teckel de pelo duro requiere ejercicio regular y actividades que estimulen su mente para mantenerse feliz y saludable. Su pelaje necesita cuidados regulares, incluyendo cepillado y recorte para mantener su apariencia y salud.', 4),
(403, 'Teckel de pelo largo', 'El Teckel de pelo largo es otra variedad de la raza Dachshund, reconocida por su pelaje largo y sedoso. Se utiliza principalmente como perro de compañía, aunque también puede participar en la caza menor debido a sus habilidades naturales de rastreo y caza.', 'El Teckel de pelo largo es similar al Dachshund estándar en términos de tamaño y forma, con un cuerpo largo y bajo, patas cortas y orejas largas y caídas. Su pelaje es largo y sedoso, con una capa exterior suave y una capa interna densa.', 'A pesar de su apariencia más delicada, el Teckel de pelo largo conserva las aptitudes resaltantes de valentía, inteligencia y tenacidad de la raza Dachshund. Son perros leales y cariñosos, ideales como compañeros de vida.', 'El Teckel de pelo largo requiere ejercicio regular y actividades que estimulen su mente para mantenerse feliz y saludable. Su pelaje necesita cuidados regulares, incluyendo cepillado y recorte para evitar enredos y mantener su apariencia y salud.', 4),
(404, 'Teckel de pelo corto', 'El Teckel de pelo corto es otra variedad de la raza Dachshund, reconocida por su pelaje corto y liso. Se utiliza principalmente para la caza de animales pequeños en terrenos difíciles, como bosques y matorrales.', 'El Teckel de pelo corto es similar al Dachshund estándar en términos de tamaño y forma, con un cuerpo largo y bajo, patas cortas y orejas largas y caídas. Su pelaje es corto y liso, con una capa exterior resistente y una capa interna suave.', 'Al igual que el Dachshund estándar, el Teckel de pelo corto es valiente, inteligente y tenaz. Son excelentes cazadores y compañeros de vida, capaces de enfrentarse a animales más grandes con determinación y coraje.', 'El Teckel de pelo corto requiere ejercicio regular y actividades que estimulen su mente para mantenerse feliz y saludable. Su pelaje necesita cuidados regulares, incluyendo cepillado y recorte para mantener su apariencia y salud.', 4),
(405, 'Teckel miniatura', 'El Teckel miniatura es una variedad de la raza Dachshund, reconocida por su tamaño pequeño y su pelaje corto o largo. Aunque comparte las mismas características generales que el Dachshund estándar, se cría específicamente para ser un perro de compañía.', 'El Teckel miniatura es similar al Dachshund estándar en términos de forma y apariencia, pero más pequeño en tamaño. Puede tener pelaje corto o largo, con una variedad de colores y patrones. Su cuerpo es largo y bajo, con patas cortas y orejas largas y caídas.', 'El Teckel miniatura conserva las aptitudes resaltantes de valentía, inteligencia y lealtad de la raza Dachshund, pero en un tamaño más compacto. Son perros cariñosos y afectuosos, ideales como compañeros de vida en hogares más pequeños.', 'El Teckel miniatura requiere ejercicio regular y actividades que estimulen su mente para mantenerse feliz y saludable. Su pelaje necesita cuidados regulares, incluyendo cepillado y recorte para mantener su apariencia y salud.', 4),
(501, 'Akita Inu', 'El Akita Inu es una antigua raza japonesa que se originó en la región montañosa del norte de Japón. Se utilizaba originalmente para la caza mayor, como jabalíes y osos, así como para la protección de la familia y el hogar.', 'El Akita Inu es un perro grande y poderoso, con una estructura muscular robusta y una apariencia majestuosa. Tiene una cabeza grande y ancha, orejas pequeñas y erectas, y un pelaje denso y tupido que puede ser de varios colores, incluyendo rojo, atigrado y blanco.', 'El Akita Inu es valiente, leal e independiente. Tiene un fuerte instinto de protección hacia su familia y territorio, lo que lo convierte en un excelente perro guardián. También es conocido por su dignidad y autocontrol.', 'El Akita Inu requiere una socialización temprana y un entrenamiento consistente debido a su naturaleza dominante. Además, necesita ejercicio diario y un cuidado regular de su pelaje para mantener su salud y apariencia.', 5),
(502, 'Siberian Husky', 'El Siberian Husky es una antigua raza de perro originaria del noreste de Siberia. Fue criado por la tribu Chukchi como perro de trabajo y transporte en condiciones extremas de frío y nieve.', 'El Siberian Husky es un perro de tamaño mediano, ágil y compacto, con una expresión viva y alerta. Tiene orejas triangulares erguidas, ojos almendrados y una cola peluda en forma de pluma que se lleva sobre el lomo. Su pelaje es denso y doble, con una variedad de colores y marcaciones.', 'El Siberian Husky es conocido por su resistencia, velocidad y resistencia. Es un excelente perro de trineo y deportista, capaz de cubrir largas distancias a velocidades moderadas. También es cariñoso y amigable, lo que lo convierte en un gran compañero de familia.', 'El Siberian Husky necesita mucho ejercicio y estimulación mental para evitar el aburrimiento y comportamientos destructivos. Su pelaje necesita cuidados regulares, especialmente durante las temporadas de muda.', 5),
(503, 'Chow Chow', 'El Chow Chow es una raza antigua que se originó en China hace miles de años. Originalmente se criaba para una variedad de propósitos, incluyendo la caza, la protección y el trabajo agrícola.', 'El Chow Chow es un perro de tamaño mediano a grande, con una estructura compacta y musculosa. Tiene una cabeza ancha y plana, orejas pequeñas y redondeadas, y una cola peluda que se lleva sobre el lomo. Su pelaje es denso y liso, con una melena distintiva alrededor del cuello.', 'El Chow Chow es conocido por su independencia y dignidad. Tiende a ser reservado con extraños pero leal y afectuoso con su familia. Es un perro guardián natural y protector de su hogar y seres queridos.', 'El Chow Chow requiere una socialización temprana y un entrenamiento consistente para controlar su naturaleza independiente y protectora. También necesita cuidados regulares de su pelaje para prevenir enredos y mantener su apariencia.', 5),
(504, 'Samoyedo', 'El Samoyedo es una raza antigua que se originó en Siberia, donde fue criado por la tribu Samoyed para pastorear renos, tirar de trineos y proporcionar calor durante las noches frías.', 'El Samoyedo es un perro de tamaño mediano, bien proporcionado y robusto, con una expresión amistosa y alegre. Tiene orejas triangulares erguidas, ojos oscuros y almendrados, y una cola peluda en forma de pluma que se lleva sobre el lomo. Su pelaje es doble y denso, con una capa interna suave y una capa externa resistente.', 'El Samoyedo es conocido por su amabilidad, afecto y espíritu juguetón. Tiene una personalidad extrovertida y sociable, lo que lo convierte en un gran compañero de familia y perro de terapia. También es inteligente y fácil de entrenar.', 'El Samoyedo necesita ejercicio regular y actividades que estimulen su mente para mantenerse feliz y saludable. Su pelaje necesita cuidados regulares, especialmente durante las temporadas de muda, para evitar enredos y mantener su apariencia.', 5),
(505, 'Shiba Inu', 'El Shiba Inu es una raza japonesa antigua que se originó en la región montañosa de Japón. Originalmente se criaba para la caza de aves y pequeños mamíferos en terrenos montañosos y boscosos.', 'El Shiba Inu es un perro pequeño y compacto, con una estructura muscular sólida y una expresión alerta y digna. Tiene orejas pequeñas y triangulares erguidas, ojos oscuros y almendrados, y una cola peluda que se lleva sobre el lomo. Su pelaje es doble y denso, con una variedad de colores y marcaciones.', 'El Shiba Inu es conocido por su independencia, valentía y lealtad. Tiene una personalidad animada y enérgica, pero también puede ser reservado con extraños. Es un perro de compañía maravilloso para familias activas y personas solteras.', 'El Shiba Inu necesita ejercicio regular y socialización temprana para mantenerse feliz y saludable. Su pelaje necesita cuidados regulares, incluyendo cepillado y recorte para mantener su apariencia y salud.', 5),
(601, 'Beagle', 'El Beagle es una raza de perro de caza originaria de Inglaterra. Se cree que desciende de perros utilizados para la caza de conejos y liebres en la Edad Media.', 'El Beagle es un perro de tamaño pequeño a mediano, con una estructura compacta y musculosa. Tiene orejas largas y caídas, ojos marrones grandes y expresivos, y una cola recta y erecta. Su pelaje es corto, denso y resistente, con una variedad de colores.', 'El Beagle es conocido por su agudeza olfativa y su habilidad para rastrear presas. Es un perro de caza excelente que puede seguir un rastro durante horas sin descanso. También es amigable, enérgico y adecuado para familias y niños.', 'El Beagle necesita ejercicio regular y estimulación mental para mantenerse feliz y saludable. También necesita cuidados regulares de su pelaje para prevenir enredos y mantener su apariencia.', 6),
(602, 'Bloodhound', 'El Bloodhound es una raza antigua de perros de caza que se originó en Bélgica. Se cree que desciende de perros de rastreo traídos a Europa por los fenicios hace miles de años.', 'El Bloodhound es un perro de tamaño grande y musculoso, con una cabeza grande y arrugada, orejas largas y caídas, y una piel suelta y arrugada. Tiene una expresión triste y melancólica y un pelaje corto y grueso que puede ser de varios colores.', 'El Bloodhound es conocido por tener el sentido del olfato más agudo de todas las razas de perros. Es un rastreador excepcional que puede seguir un rastro antiguo durante días sin descanso. También es amable, gentil y adecuado para familias y niños.', 'El Bloodhound necesita ejercicio regular y un espacio amplio para moverse debido a su tamaño y energía. También necesita cuidados regulares de su piel y orejas para prevenir problemas de salud.', 6),
(603, 'Basset Hound', 'El Basset Hound es una raza de perro de caza que se originó en Francia. Fue criado para la caza de animales pequeños como conejos y liebres.', 'El Basset Hound es un perro de tamaño mediano a grande, con una estructura corta y robusta. Tiene orejas largas y caídas, ojos marrones tristes y una cola recta y erecta. Su pelaje es corto, denso y resistente, con una variedad de colores.', 'El Basset Hound es conocido por su olfato excepcional y su habilidad para rastrear presas en terrenos difíciles. Es un perro de caza tenaz que puede seguir un rastro durante horas sin descanso. También es amable, relajado y adecuado para familias y niños.', 'El Basset Hound necesita ejercicio regular y una dieta controlada para evitar problemas de peso debido a su tendencia a la obesidad. También necesita cuidados regulares de su piel y orejas para prevenir infecciones.', 6),
(604, 'Foxhound Americano', 'El Foxhound Americano es una raza de perro de caza que se originó en los Estados Unidos. Fue criado para la caza de zorros y otros animales de caza mayor.', 'El Foxhound Americano es un perro de tamaño mediano a grande, con una estructura atlética y musculosa. Tiene orejas largas y caídas, ojos marrones brillantes y una cola recta y erecta. Su pelaje es corto, denso y resistente, con una variedad de colores.', 'El Foxhound Americano es conocido por su resistencia y su habilidad para seguir un rastro durante largas distancias. Es un perro de caza apasionado que trabaja bien en grupos y es adecuado para cazadores experimentados. También es amable, sociable y adecuado para familias y niños.', 'El Foxhound Americano necesita ejercicio regular y mucho espacio para moverse debido a su naturaleza enérgica y atlética. También necesita socialización temprana y entrenamiento consistente para controlar su instinto de caza.', 6),
(605, 'Coonhound', 'El Coonhound es una raza de perro de caza que se originó en los Estados Unidos. Fue criado para la caza de mapaches y otros animales de caza mayor.', 'El Coonhound es un perro de tamaño mediano a grande, con una estructura muscular y atlética. Tiene orejas largas y caídas, ojos marrones expresivos y una cola recta y erecta. Su pelaje es corto, denso y resistente, con una variedad de colores.', 'El Coonhound es conocido por su olfato agudo y su habilidad para seguir un rastro durante largas distancias. Es un perro de caza apasionado que trabaja bien en grupos y es adecuado para cazadores experimentados. También es amable, leal y adecuado para familias y niños.', 'El Coonhound necesita ejercicio regular y mucho espacio para moverse debido a su naturaleza enérgica y atlética. También necesita socialización temprana y entrenamiento consistente para controlar su instinto de caza.', 6),
(701, 'Labrador Retriever', 'El Labrador Retriever es una raza de perro originaria de Terranova, en Canadá. En sus inicios, se utilizaba como perro de pesca para ayudar a los pescadores a recuperar las redes y el pescado que se escapaba del anzuelo.', 'El Labrador Retriever es un perro de tamaño mediano a grande, de constitución musculosa y atlética. Tiene una cabeza ancha y cuadrada, orejas caídas y colgadas, y una cola gruesa y fuerte. Su pelaje es corto, denso y resistente al agua, en colores negro, amarillo o chocolate.', 'El Labrador Retriever es conocido por su amabilidad, inteligencia y disposición para el trabajo. Es un excelente perro de compañía, guía, rescate y detección, además de ser muy adecuado para la convivencia con niños y otras mascotas.', 'El Labrador Retriever requiere ejercicio regular y estimulación mental para mantenerse feliz y saludable. También necesita socialización temprana para desarrollar una personalidad equilibrada.', 7),
(702, 'Golden Retriever', 'El Golden Retriever es una raza de perro originaria de Escocia. Fue desarrollado a finales del siglo XIX por Lord Tweedmouth, con la intención de crear un perro de caza versátil, capaz de recuperar presas tanto en tierra como en agua.', 'El Golden Retriever es un perro de tamaño mediano, de constitución musculosa y elegante. Tiene una cabeza ancha y redondeada, orejas caídas y colgadas, y una cola larga y plumosa. Su pelaje es largo, denso y de color dorado o crema.', 'El Golden Retriever es conocido por su amabilidad, inteligencia y disposición para el trabajo. Es un excelente perro de compañía, caza, guía, rescate y detección, además de ser muy adecuado para la convivencia con niños y otras mascotas.', 'El Golden Retriever requiere ejercicio regular y estimulación mental para mantenerse feliz y saludable. También necesita socialización temprana para desarrollar una personalidad equilibrada.', 7),
(703, 'Setter Irlandés', 'El Setter Irlandés es una raza de perro originaria de Irlanda. Se cree que se desarrolló a partir de antiguas razas de perros de caza españoles, llevados a Irlanda por los comerciantes españoles en el siglo XVI.', 'El Setter Irlandés es un perro de tamaño mediano a grande, de constitución atlética y elegante. Tiene una cabeza alargada y estilizada, orejas caídas y colgadas, y una cola larga y plumosa. Su pelaje es largo, sedoso y de color rojo o rojo y blanco.', 'El Setter Irlandés es conocido por su elegancia, energía y pasión por la caza. Es un excelente perro de caza de aves, además de ser muy adecuado para la convivencia con la familia.', 'El Setter Irlandés requiere ejercicio regular y estimulación mental para mantenerse feliz y saludable. También necesita entrenamiento adecuado para desarrollar su instinto de caza.', 7),
(704, 'Cocker Spaniel', 'El Cocker Spaniel es una raza de perro originaria de Gales e Inglaterra. Se desarrolló a partir de antiguas razas de perros de caza españoles, llevados a las Islas Británicas por los romanos en el siglo I a.C.', 'El Cocker Spaniel es un perro de tamaño mediano, de constitución compacta y atlética. Tiene una cabeza redondeada y expresiva, orejas largas y caídas, y una cola corta y bien cubierta de pelo. Su pelaje es largo, sedoso y de colores variados.', 'El Cocker Spaniel es conocido por su alegría, inteligencia y habilidades de caza. Es un excelente perro de caza de aves, además de ser muy adecuado para la convivencia con la familia y los niños.', 'El Cocker Spaniel requiere ejercicio regular y cuidado adecuado de su pelaje para mantenerse feliz y saludable. También necesita socialización temprana para desarrollar una personalidad equilibrada.', 7),
(705, 'Springer Spaniel Inglés', 'El Springer Spaniel Inglés es una raza de perro originaria de Inglaterra. Se desarrolló a partir de antiguas razas de perros de caza españoles y franceses, llevados a las Islas Británicas por los normandos en el siglo XI.', 'El Springer Spaniel Inglés es un perro de tamaño mediano, de constitución atlética y compacta. Tiene una cabeza alargada y expresiva, orejas largas y caídas, y una cola corta y bien cubierta de pelo. Su pelaje es largo, sedoso y de colores variados.', 'El Springer Spaniel Inglés es conocido por su entusiasmo, inteligencia y habilidades de caza. Es un excelente perro de caza de aves, además de ser muy adecuado para la convivencia con la familia y los niños.', 'El Springer Spaniel Inglés requiere ejercicio regular y cuidado adecuado de su pelaje para mantenerse feliz y saludable. También necesita socialización temprana para desarrollar una personalidad equilibrada.', 7),
(801, 'Labrador Retriever', 'El Labrador Retriever es una raza de perro de origen canadiense y británico. Originalmente fue criado como perro de trabajo para ayudar en la pesca de las costas de Terranova.', 'El Labrador Retriever es un perro de tamaño mediano a grande, con una estructura musculosa y bien proporcionada. Tiene una cabeza ancha y expresiva, orejas caídas y una cola gruesa y tupida. Su pelaje es corto, denso y resistente, con una variedad de colores.', 'El Labrador Retriever es conocido por su naturaleza amigable, juguetona y obediente. Es un perro versátil que se desempeña bien en una variedad de roles, incluyendo compañía, trabajo de búsqueda y rescate, y asistencia a personas con discapacidad. También es inteligente, adaptable y fácil de entrenar.', 'El Labrador Retriever necesita ejercicio regular y estimulación mental para mantenerse feliz y saludable. También necesita cuidados regulares de su pelaje y uñas para prevenir problemas de salud.', 8),
(802, 'Golden Retriever', 'El Golden Retriever es una raza de perro de origen británico. Fue criado como perro de caza para recuperar presas acuáticas durante la caza.', 'El Golden Retriever es un perro de tamaño mediano a grande, con una estructura musculosa y bien proporcionada. Tiene una cabeza ancha y expresiva, orejas caídas y una cola larga y peluda. Su pelaje es denso, resistente al agua y de color dorado a crema.', 'El Golden Retriever es conocido por su naturaleza amigable, gentil y confiable. Es un perro versátil que se desempeña bien en una variedad de roles, incluyendo compañía, trabajo de búsqueda y rescate, y terapia asistida con animales. También es inteligente, adaptable y fácil de entrenar.', 'El Golden Retriever necesita ejercicio regular y estimulación mental para mantenerse feliz y saludable. También necesita cuidados regulares de su pelaje y uñas para prevenir problemas de salud.', 8),
(803, 'Chesapeake Bay Retriever', 'El Chesapeake Bay Retriever es una raza de perro de origen estadounidense. Fue criado como perro de caza para recuperar presas acuáticas en la región de Chesapeake Bay.', 'El Chesapeake Bay Retriever es un perro de tamaño mediano a grande, con una estructura musculosa y robusta. Tiene una cabeza ancha y poderosa, orejas caídas y una cola larga y gruesa. Su pelaje es denso, aceitoso y resistente al agua, con una variedad de colores que van desde el marrón al siena.', 'El Chesapeake Bay Retriever es conocido por su valentía, resistencia y habilidades de recuperación en el agua. Es un perro trabajador y dedicado que se desempeña bien en entornos acuáticos y condiciones climáticas adversas. También es inteligente, leal y protector de su familia.', 'El Chesapeake Bay Retriever necesita ejercicio regular y actividades acuáticas para mantenerse físicamente y mentalmente estimulado. También necesita cuidados regulares de su pelaje y uñas para prevenir problemas de salud.', 8),
(804, 'Barbet', 'El Barbet es una raza de perro de origen francés. Fue criado como perro de caza acuática y recuperación de aves acuáticas en Francia.', 'El Barbet es un perro de tamaño mediano, con una estructura robusta y atlética. Tiene una cabeza ancha y redondeada, orejas largas y caídas, y una cola larga y peluda. Su pelaje es denso, rizado y resistente al agua, con una variedad de colores sólidos o bicolor.', 'El Barbet es conocido por su habilidad para recuperar presas en el agua y su naturaleza cariñosa y sociable. Es un perro inteligente, amigable y fácil de entrenar que se lleva bien con niños y otras mascotas. También es versátil y se desempeña bien en actividades deportivas como la agilidad y el seguimiento.', 'El Barbet necesita ejercicio regular y tiempo para jugar y socializar con su familia. También necesita cuidados regulares de su pelaje para prevenir enredos y mantener su apariencia.', 8),
(805, 'Perro de Agua Español', 'El Perro de Agua Español es una raza de perro de origen español. Fue criado como perro de trabajo para recuperar presas en el agua y ayudar en la pesca y la caza.', 'El Perro de Agua Español es un perro de tamaño mediano, con una estructura atlética y musculosa. Tiene una cabeza triangular y expresiva, orejas caídas y una cola larga y esponjosa. Su pelaje es denso, rizado y resistente al agua, con una variedad de colores sólidos o bicolor.', 'El Perro de Agua Español es conocido por su habilidad para nadar y trabajar en el agua. Es un perro inteligente, valiente y leal que se desempeña bien en una variedad de roles, incluyendo compañía, trabajo de búsqueda y rescate, y deportes acuáticos. También es afectuoso, amigable y adaptable a diferentes entornos.', 'El Perro de Agua Español necesita ejercicio regular y actividades acuáticas para mantenerse físicamente y mentalmente saludable. También necesita cuidados regulares de su pelaje para prevenir enredos y mantener su apariencia.', 8),
(901, 'Bulldog Francés', 'El Bulldog Francés es una raza de perro pequeña de origen francés. Se desarrolló como una versión en miniatura del Bulldog Inglés durante la Revolución Industrial en Inglaterra, cuando los trabajadores ingleses emigraron a Francia.', 'El Bulldog Francés es un perro de tamaño pequeño y robusto, con una estructura compacta y musculosa. Tiene una cabeza grande y cuadrada, orejas grandes y erectas, y una cola corta y recta. Su pelaje es corto, suave y brillante, con una variedad de colores sólidos o moteados.', 'El Bulldog Francés es conocido por su naturaleza afectuosa, juguetona y cariñosa. Es un excelente compañero de vida que se lleva bien con personas de todas las edades, incluyendo niños y personas mayores. También es inteligente, adaptable y fácil de entrenar.', 'El Bulldog Francés tiende a tener problemas respiratorios debido a su estructura facial aplanada. Necesita ejercicio moderado y cuidados regulares de su piel y pliegues faciales para prevenir problemas de salud.', 9),
(902, 'Bichón Frisé', 'El Bichón Frisé es una raza de perro pequeña de origen mediterráneo. Se cree que se desarrolló a partir de perros acuáticos del antiguo mundo mediterráneo, como el Barbet y el Water Spaniel.', 'El Bichón Frisé es un perro de tamaño pequeño y elegante, con una estructura compacta y bien proporcionada. Tiene una cabeza redonda y expresiva, orejas caídas y una cola enroscada sobre la espalda. Su pelaje es rizado, lanoso y de color blanco puro.', 'El Bichón Frisé es conocido por su naturaleza alegre, juguetona y afectuosa. Es un excelente compañero de vida que se lleva bien con personas de todas las edades, incluyendo niños y personas mayores. También es inteligente, adaptable y fácil de entrenar.', 'El Bichón Frisé necesita cuidados regulares de su pelaje para mantenerlo limpio y libre de enredos. También necesita ejercicio moderado y estimulación mental para mantenerse feliz y saludable.', 9),
(903, 'Cavalier King Charles Spaniel', 'El Cavalier King Charles Spaniel es una raza de perro de origen británico. Se desarrolló en el siglo XVII como una versión en miniatura del King Charles Spaniel, que era popular entre la realeza británica.', 'El Cavalier King Charles Spaniel es un perro de tamaño pequeño y delicado, con una estructura bien proporcionada y elegante. Tiene una cabeza redonda y expresiva, orejas largas y caídas, y una cola larga y enroscada sobre la espalda. Su pelaje es largo, sedoso y de colores sólidos o bicolor.', 'El Cavalier King Charles Spaniel es conocido por su naturaleza cariñosa, gentil y sociable. Es un excelente compañero de vida que se lleva bien con personas de todas las edades, incluyendo niños y personas mayores. También es inteligente, afectuoso y fácil de entrenar.', 'El Cavalier King Charles Spaniel necesita cuidados regulares de su pelaje para prevenir enredos y mantener su apariencia. También necesita ejercicio moderado y tiempo para socializar con su familia.', 9),
(904, 'Maltés', 'El Maltés es una raza de perro pequeña de origen mediterráneo. Se cree que se desarrolló a partir de perros enanos del antiguo Egipto y Roma.', 'El Maltés es un perro de tamaño pequeño y delicado, con una estructura compacta y bien proporcionada. Tiene una cabeza redonda y expresiva, orejas largas y caídas, y una cola larga y enroscada sobre la espalda. Su pelaje es largo, sedoso y de color blanco puro.', 'El Maltés es conocido por su naturaleza cariñosa, afectuosa y leal. Es un excelente compañero de vida que se lleva bien con personas de todas las edades, incluyendo niños y personas mayores. También es inteligente, adaptable y fácil de entrenar.', 'El Maltés necesita cuidados regulares de su pelaje para mantenerlo limpio y libre de enredos. También necesita ejercicio moderado y estimulación mental para mantenerse feliz y saludable.', 9),
(905, 'Pomerania', 'El Pomerania, también conocido como Spitz Alemán Enano, es una raza de perro pequeña de origen europeo. Se cree que se desarrolló a partir de perros de trineo en la región de Pomerania, en Europa Central.', 'El Pomerania es un perro pequeño y compacto, con una estructura musculosa y bien proporcionada. Tiene una cabeza triangular y expresiva, orejas pequeñas y erectas, y una cola larga y peluda que se lleva sobre el dorso. Su pelaje es denso, doble y de color variado, con una melena distintiva alrededor del cuello.', 'El Pomerania es conocido por su naturaleza vivaz, juguetona y valiente. A pesar de su tamaño pequeño, es un perro alerta y enérgico que disfruta de la compañía humana. También es inteligente, leal y fácil de entrenar.', 'El Pomerania necesita cuidados regulares de su pelaje para prevenir enredos y mantener su apariencia. También necesita ejercicio moderado y estimulación mental para mantenerse feliz y saludable.', 9),
(1001, 'Galgo Español', 'El Galgo Español es una raza de perro de origen español. Se cree que se desarrolló a partir de antiguos perros de caza utilizados por los celtas y los romanos en la Península Ibérica.', 'El Galgo Español es un perro esbelto y elegante, con una estructura musculosa y bien proporcionada. Tiene una cabeza larga y estrecha, orejas pequeñas y erguidas, y una cola larga y delgada. Su pelaje es corto, liso y de colores variados, con manchas o moteado.', 'El Galgo Español es conocido por su velocidad y resistencia excepcionales. Es uno de los lebreles más rápidos del mundo, capaz de alcanzar velocidades de hasta 45 millas por hora. También es ágil, atlético y tiene un instinto de caza fuertemente desarrollado.', 'El Galgo Español necesita ejercicio diario y espacio para correr libremente. También necesita socialización temprana y entrenamiento adecuado para ser un buen compañero de vida.', 10),
(1002, 'Whippet', 'El Whippet es una raza de perro de origen británico. Se desarrolló en el siglo XIX como una versión más pequeña y ágil del Greyhound, utilizado para la caza de liebres en Inglaterra.', 'El Whippet es un perro elegante y atlético, con una estructura musculosa y bien proporcionada. Tiene una cabeza larga y estrecha, orejas pequeñas y erguidas, y una cola larga y delgada. Su pelaje es corto, liso y de colores variados, con manchas o moteado.', 'El Whippet es conocido por su velocidad y agilidad excepcionales. Es uno de los lebreles más rápidos del mundo, capaz de alcanzar velocidades de hasta 35 millas por hora. También es gentil, afectuoso y tiene un temperamento equilibrado.', 'El Whippet es un perro adaptable que se adapta bien a la vida en interiores y exteriores. Necesita ejercicio diario y socialización temprana para ser un buen compañero de vida.', 10),
(1003, 'Greyhound', 'El Greyhound es una raza de perro de origen británico. Se cree que se desarrolló a partir de antiguos lebreles utilizados por los celtas y los romanos en las Islas Británicas.', 'El Greyhound es un perro esbelto y musculoso, con una estructura aerodinámica y elegante. Tiene una cabeza larga y estrecha, orejas pequeñas y erguidas, y una cola larga y delgada. Su pelaje es corto, liso y de colores variados, con manchas o moteado.', 'El Greyhound es conocido por su velocidad y resistencia excepcionales. Es uno de los lebreles más rápidos del mundo, capaz de alcanzar velocidades de hasta 45 millas por hora. También es gentil, tranquilo y tiene un temperamento equilibrado.', 'El Greyhound es un perro tranquilo y relajado en el hogar, pero necesita ejercicio diario y espacio para correr libremente. También necesita socialización temprana y entrenamiento adecuado para ser un buen compañero de vida.', 10),
(1004, 'Borzoi', 'El Borzoi, también conocido como Galgo Ruso, es una raza de perro de origen ruso. Se desarrolló en la antigua Rusia como un perro de caza utilizado por la aristocracia para cazar lobos, liebres y otros animales de caza mayor.', 'El Borzoi es un perro elegante y musculoso, con una estructura esbelta y poderosa. Tiene una cabeza larga y estrecha, orejas pequeñas y erguidas, y una cola larga y curvada. Su pelaje es largo, sedoso y de colores variados, con manchas o moteado.', 'El Borzoi es conocido por su velocidad, agilidad y resistencia excepcionales. Es uno de los lebreles más grandes del mundo, capaz de alcanzar velocidades de hasta 40 millas por hora. También es gentil, reservado y tiene un temperamento independiente.', 'El Borzoi es un perro tranquilo y reservado en el hogar, pero necesita ejercicio diario y espacio para correr libremente. También necesita socialización temprana y entrenamiento adecuado para ser un buen compañero de vida.', 10),
(1005, 'Saluki', 'El Saluki es una raza de perro de origen mediooriental. Se cree que se desarrolló en la antigua Persia como un perro de caza utilizado por la realeza para cazar gacelas y otros animales de caza mayor.', 'El Saluki es un perro esbelto y elegante, con una estructura musculosa y bien proporcionada. Tiene una cabeza larga y estrecha, orejas largas y caídas, y una cola larga y curvada. Su pelaje es largo, sedoso y de colores variados, con manchas o moteado.', 'El Saluki es conocido por su velocidad y resistencia excepcionales. Es uno de los lebreles más antiguos del mundo, capaz de alcanzar velocidades de hasta 40 millas por hora. También es gentil, independiente y tiene un temperamento reservado.', 'El Saluki es un perro tranquilo y reservado en el hogar, pero necesita ejercicio diario y espacio para correr libremente. También necesita socialización temprana y entrenamiento adecuado para ser un buen compañero de vida.', 10)


SET IDENTITY_INSERT Raza OFF
GO
INSERT Raza_Concurso (CoRaza, CoConcurso) VALUES 
(101, 1), (101, 2), (101, 3), (101, 4),
(102, 1), (102, 2), (102, 3), (102, 4),
(103, 1), (103, 2), (103, 3), (103, 4),
(104, 1), (104, 2), (104, 3), (104, 4),
(105, 1), (105, 2), (105, 3), (105, 4),
(201, 1), (201, 2), (201, 3), (201, 4),
(202, 1), (202, 2), (202, 3), (202, 4),
(203, 1), (203, 2), (203, 3), (203, 4),
(204, 1), (204, 2), (204, 3), (204, 4),
(205, 1), (205, 2), (205, 3), (205, 4),
(301, 1), (301, 2), (301, 3), (301, 4),
(302, 1), (302, 2), (302, 3), (302, 4),
(303, 1), (303, 2), (303, 3), (303, 4),
(304, 1), (304, 2), (304, 3), (304, 4),
(305, 1), (305, 2), (305, 3), (305, 4),
(401, 1), (401, 2), (401, 3), (401, 4),
(402, 1), (402, 2), (402, 3), (402, 4),
(403, 1), (403, 2), (403, 3), (403, 4),
(404, 1), (404, 2), (404, 3), (404, 4),
(405, 1), (405, 2), (405, 3), (405, 4),
(501, 1), (501, 2), (501, 3), (501, 4),
(502, 1), (502, 2), (502, 3), (502, 4),
(503, 1), (503, 2), (503, 3), (503, 4),
(504, 1), (504, 2), (504, 3), (504, 4),
(505, 1), (505, 2), (505, 3), (505, 4),
(601, 1), (601, 2), (601, 3), (601, 4),
(602, 1), (602, 2), (602, 3), (602, 4),
(603, 1), (603, 2), (603, 3), (603, 4),
(604, 1), (604, 2), (604, 3), (604, 4),
(605, 1), (605, 2), (605, 3), (605, 4),
(701, 1), (701, 2), (701, 3), (701, 4),
(702, 1), (702, 2), (702, 3), (702, 4),
(703, 1), (703, 2), (703, 3), (703, 4),
(704, 1), (704, 2), (704, 3), (704, 4),
(705, 1), (705, 2), (705, 3), (705, 4),
(801, 1), (801, 2), (801, 3), (801, 4),
(802, 1), (802, 2), (802, 3), (802, 4),
(803, 1), (803, 2), (803, 3), (803, 4),
(804, 1), (804, 2), (804, 3), (804, 4),
(805, 1), (805, 2), (805, 3), (805, 4),
(901, 1), (901, 2), (901, 3), (901, 4),
(902, 1), (902, 2), (902, 3), (902, 4),
(903, 1), (903, 2), (903, 3), (903, 4),
(904, 1), (904, 2), (904, 3), (904, 4),
(905, 1), (905, 2), (905, 3), (905, 4),
(1001, 1), (1001, 2), (1001, 3), (1001, 4),
(1002, 1), (1002, 2), (1002, 3), (1002, 4),
(1003, 1), (1003, 2), (1003, 3), (1003, 4),
(1004, 1), (1004, 2), (1004, 3), (1004, 4),
(1005, 1), (1005, 2), (1005, 3), (1005, 4);
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
(1, 'Max', 'A1B2C3D', 'Juan Pérez', CAST('20230130' AS Date), 'Lima - Peru', 'M', DATEDIFF(DAY, CAST('20230130' AS Date), '20240421'), NULL, NULL, 101),
(2, 'Luna', 'E4F5G6H', 'María García', CAST('20230320' AS Date), 'Arequipa - Peru', 'H', DATEDIFF(DAY, CAST('20230320' AS Date), '20240421'), NULL, NULL, 101),
(3, 'Rocky', 'I7J8K9L', 'José Rodríguez', CAST('20230710' AS Date), 'Cusco - Peru', 'M', DATEDIFF(DAY, CAST('20230710' AS Date), '20240421'), NULL, NULL, 101),
(4, 'Bella', 'M1N2O3P', 'Ana López', CAST('20230205' AS Date), 'Trujillo - Peru', 'H', DATEDIFF(DAY, CAST('20230205' AS Date), '20240421'), NULL, NULL, 102),
(5, 'Thor', 'Q4R5S6T', 'Pedro Ramírez', CAST('20230515' AS Date), 'Piura - Peru', 'M', DATEDIFF(DAY, CAST('20230515' AS Date), '20240421'), NULL, NULL, 102),
(6, 'Lola', 'U7V8W9X', 'Sofía Martínez', CAST('20230925' AS Date), 'Iquitos - Peru', 'H', DATEDIFF(DAY, CAST('20230925' AS Date), '20240421'), NULL, NULL, 102),
(7, 'Maxi', 'Y1Z2A3B', 'Martín Pérez', CAST('20230410' AS Date), 'Tacna - Peru', 'M', DATEDIFF(DAY, CAST('20230410' AS Date), '20240421'), NULL, NULL, 103),
(8, 'Luna', 'C4D5E6F', 'Lucía García', CAST('20230630' AS Date), 'Chiclayo - Peru', 'H', DATEDIFF(DAY, CAST('20230630' AS Date), '20240421'), NULL, NULL, 103),
(9, 'Rocky', 'G7H8I9J', 'Andrea Rodríguez', CAST('20230120' AS Date), 'Huancayo - Peru', 'M', DATEDIFF(DAY, CAST('20230120' AS Date), '20240421'), NULL, NULL, 103),
(10, 'Bella', 'K1L2M3N', 'Mario López', CAST('20230415' AS Date), 'Ica - Peru', 'H', DATEDIFF(DAY, CAST('20230415' AS Date), '20240421'), NULL, NULL, 104),
(11, 'Thor', 'O4P5Q6R', 'Carla Ramírez', CAST('20230805' AS Date), 'Ayacucho - Peru', 'M', DATEDIFF(DAY, CAST('20230805' AS Date), '20240421'), NULL, NULL, 104),
(12, 'Lola', 'S7T8U9V', 'Natalia Martínez', CAST('20230225' AS Date), 'Chimbote - Peru', 'H', DATEDIFF(DAY, CAST('20230225' AS Date), '20240421'), NULL, NULL, 104),
(13, 'Maxi', 'W1X2Y3Z', 'Camila Pérez', CAST('20230620' AS Date), 'Puno - Peru', 'M', DATEDIFF(DAY, CAST('20230620' AS Date), '20240421'), NULL, NULL, 105),
(14, 'Luna', 'A4B5C6D', 'Diego García', CAST('20231010' AS Date), 'Huaraz - Peru', 'H', DATEDIFF(DAY, CAST('20231010' AS Date), '20240421'), NULL, NULL, 105),
(15, 'Rocky', 'E7F8G9H', 'Valeria Rodríguez', CAST('20230430' AS Date), 'Tarapoto - Peru', 'M', DATEDIFF(DAY, CAST('20230430' AS Date), '20240421'), NULL, NULL, 105),
(16, 'Bella', 'I1J2K3L', 'Fernando López', CAST('20230210' AS Date), 'Cajamarca - Peru', 'H', DATEDIFF(DAY, CAST('20230210' AS Date), '20240421'), NULL, NULL, 201),
(17, 'Thor', 'M4N5O6P', 'Laura Ramírez', CAST('20230530' AS Date), 'Huánuco - Peru', 'M', DATEDIFF(DAY, CAST('20230530' AS Date), '20240421'), NULL, NULL, 201),
(18, 'Lola', 'Q7R8S9T', 'Gabriel Martínez', CAST('20230920' AS Date), 'Tumbes - Peru', 'H', DATEDIFF(DAY, CAST('20230920' AS Date), '20240421'), NULL, NULL, 201),
(19, 'Maxi', 'U1V2W3X', 'Patricia Pérez', CAST('20230305' AS Date), 'Jaén - Peru', 'M', DATEDIFF(DAY, CAST('20230305' AS Date), '20240421'), NULL, NULL, 202),
(20, 'Luna', 'Y4Z5A6B', 'Daniel García', CAST('20230625' AS Date), 'Huaral - Peru', 'H', DATEDIFF(DAY, CAST('20230625' AS Date), '20240421'), NULL, NULL, 202),
(21, 'Rocky', 'C7D8E9F', 'Ana Rodríguez', CAST('20231015' AS Date), 'Moyobamba - Peru', 'M', DATEDIFF(DAY, CAST('20231015' AS Date), '20240421'), NULL, NULL, 202),
(22, 'Bella', 'G1H2I3J', 'Diego López', CAST('20230405' AS Date), 'Cerro de Pasco - Peru', 'H', DATEDIFF(DAY, CAST('20230405' AS Date), '20240421'), NULL, NULL, 203),
(23, 'Thor', 'K4L5M6N', 'Valentina Ramírez', CAST('20230725' AS Date), 'Chincha - Peru', 'M', DATEDIFF(DAY, CAST('20230725' AS Date), '20240421'), NULL, NULL, 203),
(24, 'Lola', 'O7P8Q9R', 'Jorge Martínez', CAST('20230115' AS Date), 'Catacaos - Peru', 'H', DATEDIFF(DAY, CAST('20230115' AS Date), '20240421'), NULL, NULL, 203),
(25, 'Maxi', 'S1T2U3V', 'Mariana Pérez', CAST('20230510' AS Date), 'Chulucanas - Peru', 'M', DATEDIFF(DAY, CAST('20230510' AS Date), '20240421'), NULL, NULL, 204),
(26, 'Luna', 'W4X5Y6Z', 'Carlos García', CAST('20230830' AS Date), 'Huacho - Peru', 'H', DATEDIFF(DAY, CAST('20230830' AS Date), '20240421'), NULL, NULL, 204),
(27, 'Rocky', 'A1B2C3D', 'Jessica Rodríguez', CAST('20230220' AS Date), 'Puerto Maldonado - Peru', 'M', DATEDIFF(DAY, CAST('20230220' AS Date), '20240421'), NULL, NULL, 204),
(28, 'Bella', 'E4F5G6H', 'David López', CAST('20230615' AS Date), 'Tingo María - Peru', 'H', DATEDIFF(DAY, CAST('20230615' AS Date), '20240421'), NULL, NULL, 205),
(29, 'Thor', 'I7J8K9L', 'Laura Ramírez', CAST('20231005' AS Date), 'San Martín - Peru', 'M', DATEDIFF(DAY, CAST('20231005' AS Date), '20240421'), NULL, NULL, 205),
(30, 'Lola', 'M1N2O3P', 'Gabriel Martínez', CAST('20230325' AS Date), 'Moquegua - Peru', 'H', DATEDIFF(DAY, CAST('20230325' AS Date), '20240421'), NULL, NULL, 205),
(31, 'Maxi', 'Q4R5S6T', 'Patricia Pérez', CAST('20230720' AS Date), 'Huancavelica - Peru', 'M', DATEDIFF(DAY, CAST('20230720' AS Date), '20240421'), NULL, NULL, 301),
(32, 'Luna', 'U7V8W9X', 'Daniel García', CAST('20230110' AS Date), 'Chancay - Peru', 'H', DATEDIFF(DAY, CAST('20230110' AS Date), '20240421'), NULL, NULL, 301),
(33, 'Rocky', 'Y1Z2A3B', 'Ana Rodríguez', CAST('20230430' AS Date), 'Tarma - Peru', 'M', DATEDIFF(DAY, CAST('20230430' AS Date), '20240421'), NULL, NULL, 301),
(34, 'Bella', 'C4D5E6F', 'Diego López', CAST('20230825' AS Date), 'Mollendo - Peru', 'H', DATEDIFF(DAY, CAST('20230825' AS Date), '20240421'), NULL, NULL, 302),
(35, 'Thor', 'G7H8I9J', 'Valentina Ramírez', CAST('20230215' AS Date), 'Puerto Supe - Peru', 'M', DATEDIFF(DAY, CAST('20230215' AS Date), '20240421'), NULL, NULL, 302),
(36, 'Lola', 'K1L2M3N', 'Jorge Martínez', CAST('20230605' AS Date), 'Zarumilla - Peru', 'H', DATEDIFF(DAY, CAST('20230605' AS Date), '20240421'), NULL, NULL, 302),
(37, 'Maxi', 'O4P5Q6R', 'Mariana Pérez', CAST('20230930' AS Date), 'Tingo María - Peru', 'M', DATEDIFF(DAY, CAST('20230930' AS Date), '20240421'), NULL, NULL, 303),
(38, 'Luna', 'S7T8U9V', 'Carlos García', CAST('20230320' AS Date), 'Chancay - Peru', 'H', DATEDIFF(DAY, CAST('20230320' AS Date), '20240421'), NULL, NULL, 303),
(39, 'Rocky', 'W1X2Y3Z', 'Jessica Rodríguez', CAST('20230710' AS Date), 'Tarma - Peru', 'M', DATEDIFF(DAY, CAST('20230710' AS Date), '20240421'), NULL, NULL, 303),
(40, 'Bella', 'A4B5C6D', 'David López', CAST('20231005' AS Date), 'Mollendo - Peru', 'H', DATEDIFF(DAY, CAST('20231005' AS Date), '20240421'), NULL, NULL, 304),
(41, 'Thor', 'E7F8G9H', 'Laura Ramírez', CAST('20230325' AS Date), 'Puerto Supe - Peru', 'M', DATEDIFF(DAY, CAST('20230325' AS Date), '20240421'), NULL, NULL, 304),
(42, 'Lola', 'I1J2K3L', 'Gabriel Martínez', CAST('20230715' AS Date), 'Zarumilla - Peru', 'H', DATEDIFF(DAY, CAST('20230715' AS Date), '20240421'), NULL, NULL, 304),
(43, 'Maxi', 'M4N5O6P', 'Patricia Pérez', CAST('20230105' AS Date), 'Tingo María - Peru', 'M', DATEDIFF(DAY, CAST('20230105' AS Date), '20240421'), NULL, NULL, 305),
(44, 'Luna', 'Q7R8S9T', 'Daniel García', CAST('20230425' AS Date), 'Chancay - Peru', 'H', DATEDIFF(DAY, CAST('20230425' AS Date), '20240421'), NULL, NULL, 305),
(45, 'Rocky', 'U1V2W3X', 'Ana Rodríguez', CAST('20230815' AS Date), 'Tarma - Peru', 'M', DATEDIFF(DAY, CAST('20230815' AS Date), '20240421'), NULL, NULL, 305),
(46, 'Bella', 'Y4Z5A6B', 'Diego López', CAST('20230110' AS Date), 'Mollendo - Peru', 'H', DATEDIFF(DAY, CAST('20230110' AS Date), '20240421'), NULL, NULL, 401),
(47, 'Thor', 'C7D8E9F', 'Valentina Ramírez', CAST('20230430' AS Date), 'Puerto Supe - Peru', 'M', DATEDIFF(DAY, CAST('20230430' AS Date), '20240421'), NULL, NULL, 401),
(48, 'Lola', 'G1H2I3J', 'Jorge Martínez', CAST('20230820' AS Date), 'Zarumilla - Peru', 'H', DATEDIFF(DAY, CAST('20230820' AS Date), '20240421'), NULL, NULL, 401),
(49, 'Maxi', 'K4L5M6N', 'Mariana Pérez', CAST('20230210' AS Date), 'Tingo María - Peru', 'M', DATEDIFF(DAY, CAST('20230210' AS Date), '20240421'), NULL, NULL, 402),
(50, 'Luna', 'O7P8Q9R', 'Carlos García', CAST('20230531' AS Date), 'Chancay - Peru', 'H', DATEDIFF(DAY, CAST('20230531' AS Date), '20240421'), NULL, NULL, 402),
(51, 'Rocky', 'S1T2U3V', 'Jessica Rodríguez', CAST('20230920' AS Date), 'Tarma - Peru', 'M', DATEDIFF(DAY, CAST('20230920' AS Date), '20240421'), NULL, NULL, 402),
(52, 'Bella', 'W4X5Y6Z', 'David López', CAST('20230115' AS Date), 'Mollendo - Peru', 'H', DATEDIFF(DAY, CAST('20230115' AS Date), '20240421'), NULL, NULL, 403),
(53, 'Thor', 'A1B2C3D', 'Laura Ramírez', CAST('20230405' AS Date), 'Puerto Supe - Peru', 'M', DATEDIFF(DAY, CAST('20230405' AS Date), '20240421'), NULL, NULL, 403),
(54, 'Lola', 'E4F5G6H', 'Gabriel Martínez', CAST('20230725' AS Date), 'Zarumilla - Peru', 'H', DATEDIFF(DAY, CAST('20230725' AS Date), '20240421'), NULL, NULL, 403),
(55, 'Maxi', 'I7J8K9L', 'Patricia Pérez', CAST('20230220' AS Date), 'Tingo María - Peru', 'M', DATEDIFF(DAY, CAST('20230220' AS Date), '20240421'), NULL, NULL, 404),
(56, 'Luna', 'M1N2O3P', 'Daniel García', CAST('20230610' AS Date), 'Chancay - Peru', 'H', DATEDIFF(DAY, CAST('20230610' AS Date), '20240421'), NULL, NULL, 404),
(57, 'Rocky', 'Q4R5S6T', 'Ana Rodríguez', CAST('20231005' AS Date), 'Tarma - Peru', 'M', DATEDIFF(DAY, CAST('20231005' AS Date), '20240421'), NULL, NULL, 404),
(58, 'Bella', 'U7V8W9X', 'Diego López', CAST('20230325' AS Date), 'Mollendo - Peru', 'H', DATEDIFF(DAY, CAST('20230325' AS Date), '20240421'), NULL, NULL, 405),
(59, 'Thor', 'Y1Z2A3B', 'Valentina Ramírez', CAST('20230715' AS Date), 'Puerto Supe - Peru', 'M', DATEDIFF(DAY, CAST('20230715' AS Date), '20240421'), NULL, NULL, 405),
(60, 'Lola', 'C4D5E6F', 'Jorge Martínez', CAST('20231005' AS Date), 'Zarumilla - Peru', 'H', DATEDIFF(DAY, CAST('20231005' AS Date), '20240421'), NULL, NULL, 405),
(61, 'Maxi', 'G7H8I9J', 'Mariana Pérez', CAST('20230330' AS Date), 'Tingo María - Peru', 'M', DATEDIFF(DAY, CAST('20230330' AS Date), '20240421'), NULL, NULL, 501),
(62, 'Luna', 'K1L2M3N', 'Carlos García', CAST('20230720' AS Date), 'Chancay - Peru', 'H', DATEDIFF(DAY, CAST('20230720' AS Date), '20240421'), NULL, NULL, 501),
(63, 'Rocky', 'O4P5Q6R', 'Jessica Rodríguez', CAST('20230110' AS Date), 'Tarma - Peru', 'M', DATEDIFF(DAY, CAST('20230110' AS Date), '20240421'), NULL, NULL, 501),
(64, 'Bella', 'S7T8U9V', 'David López', CAST('20230405' AS Date), 'Mollendo - Peru', 'H', DATEDIFF(DAY, CAST('20230405' AS Date), '20240421'), NULL, NULL, 502),
(65, 'Thor', 'W1X2Y3Z', 'Laura Ramírez', CAST('20230725' AS Date), 'Puerto Supe - Peru', 'M', DATEDIFF(DAY, CAST('20230725' AS Date), '20240421'), NULL, NULL, 502),
(66, 'Lola', 'A4B5C6D', 'Gabriel Martínez', CAST('20231120' AS Date), 'Zarumilla - Peru', 'H', DATEDIFF(DAY, CAST('20231120' AS Date), '20240421'), NULL, NULL, 502),
(67, 'Maxi', 'E7F8G9H', 'Patricia Pérez', CAST('20230510' AS Date), 'Tingo María - Peru', 'M', DATEDIFF(DAY, CAST('20230510' AS Date), '20240421'), NULL, NULL, 503),
(68, 'Luna', 'I1J2K3L', 'Daniel García', CAST('20230830' AS Date), 'Chancay - Peru', 'H', DATEDIFF(DAY, CAST('20230830' AS Date), '20240421'), NULL, NULL, 503),
(69, 'Rocky', 'M4N5O6P', 'Ana Rodríguez', CAST('20230220' AS Date), 'Tarma - Peru', 'M', DATEDIFF(DAY, CAST('20230220' AS Date), '20240421'), NULL, NULL, 503),
(70, 'Bella', 'Q7R8S9T', 'Diego López', CAST('20230615' AS Date), 'Mollendo - Peru', 'H', DATEDIFF(DAY, CAST('20230615' AS Date), '20240421'), NULL, NULL, 504),
(71, 'Thor', 'U1V2W3X', 'Valentina Ramírez', CAST('20231005' AS Date), 'Puerto Supe - Peru', 'M', DATEDIFF(DAY, CAST('20231005' AS Date), '20240421'), NULL, NULL, 504),
(72, 'Lola', 'Y4Z5A6B', 'Jorge Martínez', CAST('20230325' AS Date), 'Zarumilla - Peru', 'H', DATEDIFF(DAY, CAST('20230325' AS Date), '20240421'), NULL, NULL, 504),
(73, 'Maxi', 'C7D8E9F', 'Mariana Pérez', CAST('20230720' AS Date), 'Tingo María - Peru', 'M', DATEDIFF(DAY, CAST('20230720' AS Date), '20240421'), NULL, NULL, 505),
(74, 'Luna', 'G1H2I3J', 'Carlos García', CAST('20230110' AS Date), 'Chancay - Peru', 'H', DATEDIFF(DAY, CAST('20230110' AS Date), '20240421'), NULL, NULL, 505),
(75, 'Rocky', 'K4L5M6N', 'Jessica Rodríguez', CAST('20230430' AS Date), 'Tarma - Peru', 'M', DATEDIFF(DAY, CAST('20230430' AS Date), '20240421'), NULL, NULL, 505),
(76, 'Bella', 'O7P8Q9R', 'David López', CAST('20230825' AS Date), 'Mollendo - Peru', 'H', DATEDIFF(DAY, CAST('20230825' AS Date), '20240421'), NULL, NULL, 601),
(77, 'Thor', 'S1T2U3V', 'Laura Ramírez', CAST('20230215' AS Date), 'Puerto Supe - Peru', 'M', DATEDIFF(DAY, CAST('20230215' AS Date), '20240421'), NULL, NULL, 601),
(78, 'Lola', 'W4X5Y6Z', 'Gabriel Martínez', CAST('20230605' AS Date), 'Zarumilla - Peru', 'H', DATEDIFF(DAY, CAST('20230605' AS Date), '20240421'), NULL, NULL, 601),
(79, 'Maxi', 'A1B2C3D', 'Patricia Pérez', CAST('20230930' AS Date), 'Tingo María - Peru', 'M', DATEDIFF(DAY, CAST('20230930' AS Date), '20240421'), NULL, NULL, 602),
(80, 'Luna', 'E4F5G6H', 'Daniel García', CAST('20230320' AS Date), 'Chancay - Peru', 'H', DATEDIFF(DAY, CAST('20230320' AS Date), '20240421'), NULL, NULL, 602),
(81, 'Rocky', 'I7J8K9L', 'Ana Rodríguez', CAST('20230710' AS Date), 'Tarma - Peru', 'M', DATEDIFF(DAY, CAST('20230710' AS Date), '20240421'), NULL, NULL, 602),
(82, 'Bella', 'M1N2O3P', 'Diego López', CAST('20230105' AS Date), 'Mollendo - Peru', 'H', DATEDIFF(DAY, CAST('20230105' AS Date), '20240421'), NULL, NULL, 603),
(83, 'Thor', 'Q4R5S6T', 'Valentina Ramírez', CAST('20230425' AS Date), 'Puerto Supe - Peru', 'M', DATEDIFF(DAY, CAST('20230425' AS Date), '20240421'), NULL, NULL, 603),
(84, 'Lola', 'U7V8W9X', 'Jorge Martínez', CAST('20230815' AS Date), 'Zarumilla - Peru', 'H', DATEDIFF(DAY, CAST('20230815' AS Date), '20240421'), NULL, NULL, 603),
(85, 'Maxi', 'Y1Z2A3B', 'Mariana Pérez', CAST('20230110' AS Date), 'Tingo María - Peru', 'M', DATEDIFF(DAY, CAST('20230110' AS Date), '20240421'), NULL, NULL, 604),
(86, 'Luna', 'C4D5E6F', 'Carlos García', CAST('20230405' AS Date), 'Chancay - Peru', 'H', DATEDIFF(DAY, CAST('20230405' AS Date), '20240421'), NULL, NULL, 604),
(87, 'Rocky', 'G7H8I9J', 'Jessica Rodríguez', CAST('20230725' AS Date), 'Tarma - Peru', 'M', DATEDIFF(DAY, CAST('20230725' AS Date), '20240421'), NULL, NULL, 604),
(88, 'Bella', 'K1L2M3N', 'David López', CAST('20231120' AS Date), 'Mollendo - Peru', 'H', DATEDIFF(DAY, CAST('20231120' AS Date), '20240421'), NULL, NULL, 605),
(89, 'Thor', 'O4P5Q6R', 'Laura Ramírez', CAST('20230210' AS Date), 'Puerto Supe - Peru', 'M', DATEDIFF(DAY, CAST('20230210' AS Date), '20240421'), NULL, NULL, 605),
(90, 'Lola', 'S7T8U9V', 'Gabriel Martínez', CAST('20230531' AS Date), 'Zarumilla - Peru', 'H', DATEDIFF(DAY, CAST('20230531' AS Date), '20240421'), NULL, NULL, 605),
(91, 'Maxi', 'W1X2Y3Z', 'Patricia Pérez', CAST('20230925' AS Date), 'Tingo María - Peru', 'M', DATEDIFF(DAY, CAST('20230925' AS Date), '20240421'), NULL, NULL, 701),
(92, 'Luna', 'A4B5C6D', 'Daniel García', CAST('20230315' AS Date), 'Chancay - Peru', 'H', DATEDIFF(DAY, CAST('20230315' AS Date), '20240421'), NULL, NULL, 701),
(93, 'Rocky', 'E7F8G9H', 'Ana Rodríguez', CAST('20230705' AS Date), 'Tarma - Peru', 'M', DATEDIFF(DAY, CAST('20230705' AS Date), '20240421'), NULL, NULL, 701),
(94, 'Bella', 'I1J2K3L', 'Diego López', CAST('20231030' AS Date), 'Mollendo - Peru', 'H', DATEDIFF(DAY, CAST('20231030' AS Date), '20240421'), NULL, NULL, 702),
(95, 'Thor', 'M4N5O6P', 'Valentina Ramírez', CAST('20230420' AS Date), 'Puerto Supe - Peru', 'M', DATEDIFF(DAY, CAST('20230420' AS Date), '20240421'), NULL, NULL, 702),
(96, 'Lola', 'Q7R8S9T', 'Jorge Martínez', CAST('20230810' AS Date), 'Zarumilla - Peru', 'H', DATEDIFF(DAY, CAST('20230810' AS Date), '20240421'), NULL, NULL, 702),
(97, 'Maxi', 'U7V8W9X', 'Mariana Pérez', CAST('20230205' AS Date), 'Tingo María - Peru', 'M', DATEDIFF(DAY, CAST('20230205' AS Date), '20240421'), NULL, NULL, 703),
(98, 'Luna', 'Y1Z2A3B', 'Carlos García', CAST('20230525' AS Date), 'Chancay - Peru', 'H', DATEDIFF(DAY, CAST('20230525' AS Date), '20240421'), NULL, NULL, 703),
(99, 'Rocky', 'C4D5E6F', 'Jessica Rodríguez', CAST('20230915' AS Date), 'Tarma - Peru', 'M', DATEDIFF(DAY, CAST('20230915' AS Date), '20240421'), NULL, NULL, 703),
(100, 'Bella', 'G7H8I9J', 'David López', CAST('20230210' AS Date), 'Mollendo - Peru', 'H', DATEDIFF(DAY, CAST('20230210' AS Date), '20240421'), NULL, NULL, 704),
(101, 'Thor', 'K1L2M3N', 'Laura Ramírez', CAST('20230530' AS Date), 'Puerto Supe - Peru', 'M', DATEDIFF(DAY, CAST('20230530' AS Date), '20240421'), NULL, NULL, 704),
(102, 'Lola', 'O4P5Q6R', 'Gabriel Martínez', CAST('20230920' AS Date), 'Zarumilla - Peru', 'H', DATEDIFF(DAY, CAST('20230920' AS Date), '20240421'), NULL, NULL, 704),
(103, 'Maxi', 'S7T8U9V', 'Patricia Pérez', CAST('20230310' AS Date), 'Tingo María - Peru', 'M', DATEDIFF(DAY, CAST('20230310' AS Date), '20240421'), NULL, NULL, 705),
(104, 'Luna', 'W1X2Y3Z', 'Daniel García', CAST('20230630' AS Date), 'Chancay - Peru', 'H', DATEDIFF(DAY, CAST('20230630' AS Date), '20240421'), NULL, NULL, 705),
(105, 'Rocky', 'A4B5C6D', 'Ana Rodríguez', CAST('20231025' AS Date), 'Tarma - Peru', 'M', DATEDIFF(DAY, CAST('20231025' AS Date), '20240421'), NULL, NULL, 705),
(106, 'Bella', 'E7F8G9H', 'Diego López', CAST('20230320' AS Date), 'Mollendo - Peru', 'H', DATEDIFF(DAY, CAST('20230320' AS Date), '20240421'), NULL, NULL, 801),
(107, 'Thor', 'I1J2K3L', 'Valentina Ramírez', CAST('20230710' AS Date), 'Puerto Supe - Peru', 'M', DATEDIFF(DAY, CAST('20230710' AS Date), '20240421'), NULL, NULL, 801),
(108, 'Lola', 'M4N5O6P', 'Jorge Martínez', CAST('20230105' AS Date), 'Zarumilla - Peru', 'H', DATEDIFF(DAY, CAST('20230105' AS Date), '20240421'), NULL, NULL, 801),
(109, 'Maxi', 'Q7R8S9T', 'Mariana Pérez', CAST('20230430' AS Date), 'Tingo María - Peru', 'M', DATEDIFF(DAY, CAST('20230430' AS Date), '20240421'), NULL, NULL, 802),
(110, 'Luna', 'U1V2W3X', 'Carlos García', CAST('20230820' AS Date), 'Chancay - Peru', 'H', DATEDIFF(DAY, CAST('20230820' AS Date), '20240421'), NULL, NULL, 802),
(111, 'Rocky', 'Y4Z5A6B', 'Jessica Rodríguez', CAST('20230215' AS Date), 'Tarma - Peru', 'M', DATEDIFF(DAY, CAST('20230215' AS Date), '20240421'), NULL, NULL, 802),
(112, 'Bella', 'C7D8E9F', 'Diego López', CAST('20230610' AS Date), 'Mollendo - Peru', 'H', DATEDIFF(DAY, CAST('20230610' AS Date), '20240421'), NULL, NULL, 803),
(113, 'Thor', 'G1H2I3J', 'Valentina Ramírez', CAST('20231005' AS Date), 'Puerto Supe - Peru', 'M', DATEDIFF(DAY, CAST('20231005' AS Date), '20240421'), NULL, NULL, 803),
(114, 'Lola', 'K4L5M6N', 'Jorge Martínez', CAST('20230325' AS Date), 'Zarumilla - Peru', 'H', DATEDIFF(DAY, CAST('20230325' AS Date), '20240421'), NULL, NULL, 803),
(115, 'Maxi', 'O7P8Q9R', 'Mariana Pérez', CAST('20230720' AS Date), 'Tingo María - Peru', 'M', DATEDIFF(DAY, CAST('20230720' AS Date), '20240421'), NULL, NULL, 804),
(116, 'Luna', 'S1T2U3V', 'Carlos García', CAST('20231115' AS Date), 'Chancay - Peru', 'H', DATEDIFF(DAY, CAST('20231115' AS Date), '20240421'), NULL, NULL, 804),
(117, 'Rocky', 'W4X5Y6Z', 'Jessica Rodríguez', CAST('20230510' AS Date), 'Tarma - Peru', 'M', DATEDIFF(DAY, CAST('20230510' AS Date), '20240421'), NULL, NULL, 804),
(118, 'Bella', 'A1B2C3D', 'Diego López', CAST('20230805' AS Date), 'Mollendo - Peru', 'H', DATEDIFF(DAY, CAST('20230805' AS Date), '20240421'), NULL, NULL, 805),
(119, 'Thor', 'E4F5G6H', 'Valentina Ramírez', CAST('20230130' AS Date), 'Puerto Supe - Peru', 'M', DATEDIFF(DAY, CAST('20230130' AS Date), '20240421'), NULL, NULL, 805),
(120, 'Lola', 'I7J8K9L', 'Jorge Martínez', CAST('20230525' AS Date), 'Zarumilla - Peru', 'H', DATEDIFF(DAY, CAST('20230525' AS Date), '20240421'), NULL, NULL, 805),
(121, 'Maxi', 'M1N2O3P', 'Mariana Pérez', CAST('20230920' AS Date), 'Tingo María - Peru', 'M', DATEDIFF(DAY, CAST('20230920' AS Date), '20240421'), NULL, NULL, 901),
(122, 'Luna', 'Q4R5S6T', 'Carlos García', CAST('20230315' AS Date), 'Chancay - Peru', 'H', DATEDIFF(DAY, CAST('20230315' AS Date), '20240421'), NULL, NULL, 901),
(123, 'Rocky', 'U7V8W9X', 'Jessica Rodríguez', CAST('20230705' AS Date), 'Tarma - Peru', 'M', DATEDIFF(DAY, CAST('20230705' AS Date), '20240421'), NULL, NULL, 901),
(124, 'Bella', 'Y1Z2A3B', 'Diego López', CAST('20231030' AS Date), 'Mollendo - Peru', 'H', DATEDIFF(DAY, CAST('20231030' AS Date), '20240421'), NULL, NULL, 902),
(125, 'Thor', 'C4D5E6F', 'Valentina Ramírez', CAST('20230425' AS Date), 'Puerto Supe - Peru', 'M', DATEDIFF(DAY, CAST('20230425' AS Date), '20240421'), NULL, NULL, 902),
(126, 'Lola', 'G7H8I9J', 'Jorge Martínez', CAST('20230815' AS Date), 'Zarumilla - Peru', 'H', DATEDIFF(DAY, CAST('20230815' AS Date), '20240421'), NULL, NULL, 902),
(127, 'Maxi', 'K1L2M3N', 'Mariana Pérez', CAST('20230210' AS Date), 'Tingo María - Peru', 'M', DATEDIFF(DAY, CAST('20230210' AS Date), '20240421'), NULL, NULL, 903),
(128, 'Luna', 'O4P5Q6R', 'Carlos García', CAST('20230531' AS Date), 'Chancay - Peru', 'H', DATEDIFF(DAY, CAST('20230531' AS Date), '20240421'), NULL, NULL, 903),
(129, 'Rocky', 'S7T8U9V', 'Jessica Rodríguez', CAST('20230920' AS Date), 'Tarma - Peru', 'M', DATEDIFF(DAY, CAST('20230920' AS Date), '20240421'), NULL, NULL, 903),
(130, 'Bella', 'W1X2Y3Z', 'Diego López', CAST('20230310' AS Date), 'Mollendo - Peru', 'H', DATEDIFF(DAY, CAST('20230310' AS Date), '20240421'), NULL, NULL, 904),
(131, 'Thor', 'A4B5C6D', 'Valentina Ramírez', CAST('20230605' AS Date), 'Puerto Supe - Peru', 'M', DATEDIFF(DAY, CAST('20230605' AS Date), '20240421'), NULL, NULL, 904),
(132, 'Lola', 'E7F8G9H', 'Jorge Martínez', CAST('20230930' AS Date), 'Zarumilla - Peru', 'H', DATEDIFF(DAY, CAST('20230930' AS Date), '20240421'), NULL, NULL, 904),
(133, 'Maxi', 'I1J2K3L', 'Mariana Pérez', CAST('20230125' AS Date), 'Tingo María - Peru', 'M', DATEDIFF(DAY, CAST('20230125' AS Date), '20240421'), NULL, NULL, 905),
(134, 'Luna', 'M4N5O6P', 'Carlos García', CAST('20230520' AS Date), 'Chancay - Peru', 'H', DATEDIFF(DAY, CAST('20230520' AS Date), '20240421'), NULL, NULL, 905),
(135, 'Rocky', 'Q7R8S9T', 'Jessica Rodríguez', CAST('20230910' AS Date), 'Tarma - Peru', 'M', DATEDIFF(DAY, CAST('20230910' AS Date), '20240421'), NULL, NULL, 905),
(136, 'Bella', 'U7V8W9X', 'Diego López', CAST('20230305' AS Date), 'Mollendo - Peru', 'H', DATEDIFF(DAY, CAST('20230305' AS Date), '20240421'), NULL, NULL, 1001),
(137, 'Thor', 'Y1Z2A3B', 'Valentina Ramírez', CAST('20230630' AS Date), 'Puerto Supe - Peru', 'M', DATEDIFF(DAY, CAST('20230630' AS Date), '20240421'), NULL, NULL, 1001),
(138, 'Lola', 'C4D5E6F', 'Jorge Martínez', CAST('20231025' AS Date), 'Zarumilla - Peru', 'H', DATEDIFF(DAY, CAST('20231025' AS Date), '20240421'), NULL, NULL, 1001),
(139, 'Maxi', 'G7H8I9J', 'Mariana Pérez', CAST('20230420' AS Date), 'Tingo María - Peru', 'M', DATEDIFF(DAY, CAST('20230420' AS Date), '20240421'), NULL, NULL, 1002),
(140, 'Luna', 'K1L2M3N', 'Carlos García', CAST('20230815' AS Date), 'Chancay - Peru', 'H', DATEDIFF(DAY, CAST('20230815' AS Date), '20240421'), NULL, NULL, 1002),
(141, 'Rocky', 'O4P5Q6R', 'Jessica Rodríguez', CAST('20230210' AS Date), 'Tarma - Peru', 'M', DATEDIFF(DAY, CAST('20230210' AS Date), '20240421'), NULL, NULL, 1002),
(142, 'Bella', 'S7T8U9V', 'Diego López', CAST('20230505' AS Date), 'Mollendo - Peru', 'H', DATEDIFF(DAY, CAST('20230505' AS Date), '20240421'), NULL, NULL, 1003),
(143, 'Thor', 'W1X2Y3Z', 'Valentina Ramírez', CAST('20230825' AS Date), 'Puerto Supe - Peru', 'M', DATEDIFF(DAY, CAST('20230825' AS Date), '20240421'), NULL, NULL, 1003),
(144, 'Lola', 'A4B5C6D', 'Jorge Martínez', CAST('20231220' AS Date), 'Zarumilla - Peru', 'H', DATEDIFF(DAY, CAST('20231220' AS Date), '20240421'), NULL, NULL, 1003),
(145, 'Maxi', 'E7F8G9H', 'Mariana Pérez', CAST('20230615' AS Date), 'Tingo María - Peru', 'M', DATEDIFF(DAY, CAST('20230615' AS Date), '20240421'), NULL, NULL, 1004),
(146, 'Luna', 'I1J2K3L', 'Carlos García', CAST('20231010' AS Date), 'Chancay - Peru', 'H', DATEDIFF(DAY, CAST('20231010' AS Date), '20240421'), NULL, NULL, 1004),
(147, 'Rocky', 'M4N5O6P', 'Jessica Rodríguez', CAST('20230405' AS Date), 'Tarma - Peru', 'M', DATEDIFF(DAY, CAST('20230405' AS Date), '20240421'), NULL, NULL, 1004),
(148, 'Bella', 'Q7R8S9T', 'Diego López', CAST('20230730' AS Date), 'Mollendo - Peru', 'H', DATEDIFF(DAY, CAST('20230730' AS Date), '20240421'), NULL, NULL, 1005),
(149, 'Thor', 'U1V2W3X', 'Valentina Ramírez', CAST('20231125' AS Date), 'Puerto Supe - Peru', 'M', DATEDIFF(DAY, CAST('20231125' AS Date), '20240421'), NULL, NULL, 1005),
(150, 'Lola', 'Y4Z5A6B', 'Jorge Martínez', CAST('20230520' AS Date), 'Zarumilla - Peru', 'H', DATEDIFF(DAY, CAST('20230520' AS Date), '20240421'), NULL, NULL, 1005);

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
('Cabeza', 101, 1),
('Craneo', 101, 2),
('Orejas', 101, 3),
('Cola', 101, 4),
('Mandíbula', 101, 5),
('Color', 101, 6),
('Extremidades', 101, 7),
('Cabeza', 201, 1),
('Craneo', 201, 2),
('Orejas', 201, 3),
('Cola', 201, 4),
('Mandíbula', 201, 5),
('Color', 201, 6),
('Extremidades', 201, 7),
('Cabeza', 303, 1),
('Craneo', 303, 2),
('Orejas', 303, 3),
('Cola', 303, 4),
('Mnadíbula', 303, 5),
('Color', 303, 6),
('Extremidades', 303, 7)
GO
INSERT Ejemplar_Certificado (CoCertificado, CoEjemplar, NuParticipacionConcurso, CoCategoria, CoConcurso) VALUES 
('COLACB', 1, 1, 2, 1),
('CACIB', 4, 4, 2, 2)
GO
