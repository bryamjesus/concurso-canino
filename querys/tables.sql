CREATE TABLE
  Juez (
    CoJuez INT IDENTITY PRIMARY KEY,
    NoJuez Varchar(50) NOT NULL,
    TxDatosPersonalesJuez VARCHAR(200),
    FIAcreditacionJuez CHAR(1) CHECK (FIAcreditacionJuez IN ('N', 'I'))
  );

GO;

CREATE TABLE
  Director (
    CoDirector INT IDENTITY PRIMARY KEY,
    NoDirector VARCHAR(50),
    TxDatosPersonalesDirector VARCHAR(200)
  )