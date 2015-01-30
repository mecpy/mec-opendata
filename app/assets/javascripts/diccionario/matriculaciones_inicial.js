function contenido_diccionario(url_anho_cod_geo) {
    var diccionario = [
        {
            nombre: 'AÑO',
            descripcion: 'Se refiere al año de captura de los datos',
            tipo: 'xsd:gYear',
            restricciones: 'Sólo permite la carga de datos del año de su captura',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: '2012'
        }, {
            nombre: 'CODIGO_DEPARTAMENTO',
            descripcion: 'Corresponde al código asignado según la cartografía nacional al departamento geográfico donde esta localizado el establecimiento escolar',
            tipo: 'xsd:string',
            restricciones: 'No más de 2 caracteres',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: '00'
        }, {
            nombre: 'NOMBRE_DEPARTAMENTO',
            descripcion: 'Corresponde a la descripción del nombre del departamento geográfico correspondiente al código',
            tipo: 'xsd:string',
            restricciones: 'No más de 40 caracteres',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: 'ASUNCION'
        }, {
            nombre: 'CODIGO_DISTRITO',
            descripcion: 'Corresponde al código asignado al distrito del departamento geográfico donde esta localizado el establecimiento escolar',
            tipo: 'xsd:string',
            restricciones: 'No más de 2 caracteres',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: '00'
        }, {
            nombre: 'NOMBRE_DISTRITO',
            descripcion: 'Corresponde a la descripción del nombre del distrito correspondiente al código',
            tipo: 'xsd:string',
            restricciones: 'No más de 40 caracteres',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: 'ASUNCION'
        }, {
            nombre: 'CODIGO_BARRIO_LOCALIDAD',
            descripcion: 'Corresponde al código asignado a la localidad o barrio del distrito donde esta localizado el establecimiento escolar',
            tipo: 'xsd:positiveInteger',
            restricciones: '',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: '033'
        }, {
            nombre: 'NOMBRE_BARRIO_LOCALIDAD',
            descripcion: 'Corresponde a la descripción del nombre del barrio o localidad correspondiente al código',
            tipo: 'xsd:string',
            restricciones: 'No más de 40 caracteres',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: 'PRESIDENTE CARLOS ANTONIO LOPEZ'
        }, {
            nombre: 'CODIGO_ZONA',
            descripcion: 'Corresponde a la ubicación del establecimiento escolar, sea en la zona urbana o rural. Paraguay utiliza criterios político-administrativos para definir el área urbana y rural.</br>Se considera: Código 1 .Zona Urbana: Área geográfica que abarca todas las cabeceras distritales de la República y sus viviendas generalmente estan organizadas en manzanas.</br>Código 2. Zona Rural: Área geográfica que se encuentran fuera de las cabeceras distritales y las viviendas se localizan en forma dispersa pudiendo existir zonas amanzanadas pero que no tienen la categoría de Cabeceras Distritales por la cual se consideraran como rurales',
            tipo: 'xsd:string',
            restricciones: 'Valores que pueden ser: Código 1: cuando el código de localidad es menor 100. Código 6: cuando el código de localidad es mayor o igual a 100',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: '1'
        }, {
            nombre: 'NOMBRE_ZONA',
            descripcion: 'Corresponde a la descripción del nombre de la zona correspondiente al código',
            tipo: 'xsd:string',
            restricciones: 'No más de 7 caracteres',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: 'URBANA'
        }, {
            nombre: 'CODIGO_ESTABLECIMIENTO',
            descripcion: 'Código de establecimiento permite identificar en forma única los diferentes establecimientos educativos que se encuentran en el país.\nEl Sistema de informacion de Estadística Continua (SIEC) considera “Establecimiento Escolar” a la construcción que existe dentro de un predio (terreno) que se emplea para la enseñanza, donde puede funcionar una o más instituciones educativas con sus respectivos niveles/modalidades de educación.',
            tipo: 'xsd:string',
            restricciones: 'No más de 7 caracteres',
            referencia: {
                texto: 'Reglamento del Sistema de Información de Estadística Continua (SIEC)',
                enlace: 'http://www.mec.gov.py/planificacion_educativa/Revistas/Reglamento_SIEC.pdf'
            },
            ejemplo: '0406005'
        }, {
            nombre: 'CODIGO_INSTITUCION',
            descripcion: 'Identifica a la institución como una entidad y organización independiente que funciona dentro de un establecimiento escolar. Una institución educativa puede poseer diferentes locales escolares ubicados en un mismo o en diferentes departamentos geográficos. El código está compuesto por un número secuencial. El SIEC considera una misma institución cuando varios niveles o modalidades tienen una organización, gestión y administración única. Por ejemplo: Centro Regional de Educación Gral. Patricio Escobar de Encarnación, Colegio Santa Clara de Asunción',
            tipo: 'xsd:string',
            restricciones: 'No más de 5 caracteres',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: '2875'
        }, {
            nombre: 'NOMBRE_INSTITUCION',
            descripcion: 'Corresponde a la descripción del nombre de la institución correspondiente al código',
            tipo: 'xsd:string',
            restricciones: 'No más de 40 caracteres',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: '1183 ALBERTO SCHWEITZER'
        }, {
            nombre: 'SECTOR_O_TIPO_DE_GESTION',
            descripcion: 'Sector al que pertenece una institución educativa.<br>Se considera :<br>OFICIAL: Sector o tipo de gestión al que pertenece una institución educativa cuya organización y administración está a cargo del Estado paraguayo (Ministerio de Educación y Cultura, gobernaciones, municipios, binacionales). PRIVADA: Sector o tipo de gestión al que pertenece una institución educativa cuya organización y administración está a cargo de un organismo no estatal.<br>PRIVADA SUBVENCIONADA: Sector o tipo de gestión al que pertenece una institución de gestión privada que recibe algún aporte del Estado, como ser rubros para docentes, monto en guaraníes, etc',
            tipo: 'xsd:string',
            restricciones: 'Valores en el rango: OFICIAL, PRIVADA ,PRIVADA SUBVENCIONADA',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: 'PRIVADA'
        }, {
            nombre: 'MATERNAL',
            descripcion: 'Representa la cantidad de alumnos matriculados en maternal de la etapa incial del Sistema Educativo Nacional correspondiente al nivel Educación Inicial Formal, la modalidad atiende a niños de 0 a 2 años, a quienes se brinda atención y estimulación integral durante el día, en media jornada o en jornada completa',
            tipo: 'xsd:positiveInteger',
            restricciones: '',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: '79'
        }, {
            nombre: 'PREJARDIN',
            descripcion: 'Representa la cantidad de estudiantes inscriptos en prejardin de la etapa incial del nivel Educación Inicial Formal, la modalidad atiende a niños de 3 años, a quienes se brinda atención y estimulación integral durante el día, en media jornada o en jornada completa',
            tipo: 'xsd:positiveInteger',
            restricciones: '',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: '106'
        }, {
            nombre: 'JARDIN',
            descripcion: 'Representa la cantidad de estudiantes inscriptos en jardin de la etapa incial del nivel Educación Escolar Básica, la modalidad atiende a niños de 4 años, que contempla actividades educativas tendientes a desarrollar todas las dimensiones de la personalidad de los infantes',
            tipo: 'xsd:positiveInteger',
            restricciones: '',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: '54'
        }, {
            nombre: 'PREESCOLAR',
            descripcion: 'Representa la cantidad de estudiantes inscriptos en preescolar de la etapa incial del nivel Educación Inicial Formal, la modalidad atiende a niños de 5 años, busca estimular el desarrollo integral de todos los aspectos de su personalidad',
            tipo: 'xsd:positiveInteger',
            restricciones: '',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: '16'
        }, {
            nombre: 'TOTAL_MATRICULADOS',
            descripcion: 'Representa la cantidad total de estudiantes inscriptos en la institución de los grados del nivel Inicial de la Educación Inicial Formal',
            tipo: 'xsd:positiveInteger',
            restricciones: '',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: '255'
        }, {
            nombre: 'ANHO_COD_GEO',
            descripcion: 'Se refiere al año de captura de los datos georreferenciados censales, teniendo en cuenta que por cada año censal pueden diferir los codigos de distritos o codigos de localidades, como a si también las descripciones. La cartografía nacional fue proveída por al Dirección General de Estadística, Encuestas y Censos (DGEEC - http://www.dgeec.gov.py/)',
            tipo: 'xsd:gYear',
            restricciones: 'Sólo permite datos del año de su captura censal',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: url_anho_cod_geo
        }, {
            nombre: 'NOFORMAL',
            descripcion: 'Representa la cantidad de estudiantes inscriptos en la modalidad que atiende a niños/as menores de 6  años que no tienen acceso a la Educación Inicial Formal e implementada en Mitã Róga y otras organizaciones educativas que funcionan en casas de familias, escuelas, iglesias, municipalidades, etc., atendidos por voluntarios/as, como padres de familias, estudiantes, maestros/as o enfermeros/as',
            tipo: 'xsd:gYear',
            restricciones: '',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: '36'
        }
    ];
    return diccionario;
}