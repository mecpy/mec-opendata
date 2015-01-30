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
            nombre: 'MATRICULA_ETS',
            descripcion: 'Representa la cantidad de estudiantes inscriptos en cursos a nivel terciario no universitario de Educación Superior, donde los son de dos y más años de duración, con estructura curricular modular elaborada a partir de las demandas y que tienen un fuerte acento en el sector terciario de producción (servicios) con predominio del sector privado',
            tipo: 'xsd:positiveInteger',
            restricciones: '',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: '0'
        }, {
            nombre: 'MATRICULA_FED',
            descripcion: 'Representa la cantidad de estudiantes inscriptos en cursos de Profesorado en Educación Inicial (3 años de duración), Profesorado en Educación Escolar Básica —1.° y 2.° ciclo— (3 años de duración), Profesorado para Educación Escolar Básica —3.er ciclo—, por áreas de especialidad (4 años de duración) y Profesorado para la Educación Media, por áreas de especialidad (3 años de duración) de Educación Superior, además se desarrollan cursos de especialización en Ciencias de la Educación, Orientación Educacional y Vocacional, Evaluación y Administración Escolar, entre otros, de 2 años de duración respectivamente. Otros tipos de cursos se refieren a la profesionalización de docentes, a fin de brindar título docente a los bachilleres en servicio y a profesionales universitarios que ejercen la docencia sin contar con formación pedagógica',
            tipo: 'xsd:positiveInteger',
            restricciones: '',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: '60'
        }, {
            nombre: 'MATRICULA_FDES',
            descripcion: 'Representa la cantidad de estudiantes inscriptos en cursos de formación docente en servicios de Educación Superior, que se refieren a la profesionalización de docentes, a fin de brindar título docente a los bachilleres en servicio',
            tipo: 'xsd:positiveInteger',
            restricciones: '',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: '0'
        }, {
            nombre: 'MATRICULA_PD',
            descripcion: 'Representa la cantidad de estudiantes inscriptos en cursos profesionalización docente de Educación Superior, dirigido a profesionales universitarios que ejercen la docencia sin contar con formación pedagógica',
            tipo: 'xsd:positiveInteger',
            restricciones: '',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: '265'
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
        }
    ];
    return diccionario;
}