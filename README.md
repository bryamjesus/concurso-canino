# CONCURSO CANINO

El Kennel Club del Perú (KCP) es una institución peruana afiliada a la Federación Cinológica Internacional (FCI), responsable en el Perú de llevar el registro oficial de los perros de raza. El KCP está encargado de realizar exposiciones, concursos y pruebas públicas y privadas que contribuyen a la cría, evaluación, adiestramiento y mejoramiento de los ejemplares caninos de raza existentes.

Para llevar un adecuado control de sus operaciones, se requiere diseñar una base de datos que le permita el registro de la información relativa a las razas de perros, su clasificación oficial de acuerdo con el FCI, de los concursos que organiza o autoriza, de los premios y certificaciones oficiales que se otorgan en ellos, etc.

## Ideas 
  ### Vista
    - Que me traiga ya los puestos y el texto calificación
  ### SP
    - que me de la lista de participantes y haya una columna que muestre cuantas veces a ganado
    - QUE ME PUEDA OBTENER LAS GANACIAS 
      - de un concurso solo
      - de un rango de fechas 
      - un store procedure que me saque el reporte de inscripciones a unos concursos, que puede de un concurso en especificio, de un rango de fechas o de todos los concursos

  ### Trigger
    - que valide que en el mismo concurso y categoria no haya uno con el mismo puesto
      - que no haya numero de puesto mas que concursantes
    -  solo hay dos comisarios por concurso