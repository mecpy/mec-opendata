function contenido_diccionario(url_anho_cod_geo) {
    var diccionario = [
        {
            nombre: 'AÑO',
            descripcion: 'Se refiere al año de captura de los datos',
            tipo: 'xsd:gYear',
            restricciones: '',
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
            nombre: 'CODIGO_REGION_ADMINISTRATIVA',
            descripcion: 'Corresponde a la región administrativa al cual pertenece los establecimientos escolares. El código de local está compuesto por tres grupos de números. 1) el primer par de dígitos corresponde al código de departamento (del 00 que corresponde a Asunción al 17 que corresponde a Alto Paraguay), 2) el segundo par de dígitos corresponde al código de la coordinación al cual pertenecen y 3) los tres últimos dígitos son los códigos de la region',
            tipo: 'xsd:string',
            restricciones: 'No más de 10 caracteres',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: '00C1R4'
        }, {
            nombre: 'NOMBRE_REGION_ADMINISTRATIVA',
            descripcion: 'Corresponde a la descripción del nombre de la región administrativa correspondiente al código',
            tipo: 'xsd:string',
            restricciones: 'No más de 40 caracteres',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: 'CAPITAL COORDINACION REGION 4'
        }, {
            nombre: 'NOMBRE_SUPERVISOR',
            descripcion: 'Persona encargada en el departamento de las gestiones tanto administrativas como pedagógicas de las isntituciones escolares',
            tipo: 'xsd:string',
            restricciones: 'No más de 60 caracteres',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: 'LORENZA VALLEJOS QUIÑONEZ'
        }, {
            nombre: 'NIVELES_MODALIDADES',
            descripcion: 'Cada institución educativa ofrece algún nivel o modalidad, el código de nivel se relaciona con la oferta educativa y permite identificar en forma única los niveles/modalidades que funcionan en una institución, siempre debe estar vinculada a un código de institución educativa y establecimiento escolar',
            tipo: 'xsd:string',
            restricciones: 'Valores en el rango: EEB - Educación Escolar Básica<br>EI - Educación Media<br>FED - Formación Docente<br>ETS - Educación Superior<br>EJA - Educación de Jovenes y Adultos<br>ET - Educación Técnica<br>EE - Educación Especial<br>EMDJA - Educación Media a Distancia de Jovenes y Adultos<br>EMAPJA - Educación Media Alternativa para Jovenes y Adultos<br>EMA - Educación Media Abierta',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: 'EI,EEB,EM'
        }, {
            nombre: 'CODIGO_TIPO_ORGANIZACION',
            descripcion: 'Corresponde al tipo de organización de cada institucion pueden ser escuelas centros ,escuelas asociadas o escuelas independientes',
            tipo: 'xsd:positiveInteger',
            restricciones: '',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: '2'
        }, {
            nombre: 'NOMBRE_TIPO_ORGANIZACION',
            descripcion: 'Corresponde a la descripción del tipo de organización de la institución correspondiente al código',
            tipo: 'xsd:string',
            restricciones: 'No más de 20 caracteres',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: 'ESCUELA ASOCIADA'
        }, {
            nombre: 'PARTICIPACION_COMUNITARIA',
            descripcion: 'Especifica si la institución cuenta con comisión de padres',
            tipo: 'xsd:string',
            restricciones: 'Valores en el rango: SI, NO',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: 'SI'
        }, {
            nombre: 'DIRECCION',
            descripcion: 'Corresponde al nombre de la calle, avenida, carretera, etc., del establecimiento escolar',
            tipo: 'xsd:string',
            restricciones: 'No más de 50 caracteres',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: 'MELO DE PORTUGAL E/ MAYOR MARTINEZ Y CPTAN. ARANDA'
        }, {
            nombre: 'NRO_TELEFONO',
            descripcion: 'Número de teléfono de la institución',
            tipo: 'xsd:string',
            restricciones: 'No más de 15 caracteres',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: '425-429'
        }, {
            nombre: 'TIENE_INTERNET',
            descripcion: 'Especifica si la institución cuenta con internet',
            tipo: 'xsd:string',
            restricciones: 'Valores en el rango: 1 - SI / 6 - NO',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: 'SI'
        }, {
            nombre: 'PAGINAWEB',
            descripcion: 'Especifica la página web de la institución',
            tipo: 'xsd:string',
            restricciones: '',
            referencia: {
                texto: 'RFC 3986',
                enlace: 'http://www.ietf.org/rfc/rfc3986.txt'
            },
            ejemplo: 'www.cas.edu.py'
        }, {
            nombre: 'CORREO_ELECTRONICO',
            descripcion: 'Especifica el correo electrónico de la institución',
            tipo: 'xsd:string',
            restricciones: '',
            referencia: {
                texto: 'RFC 3696',
                enlace: 'http://tools.ietf.org/html/rfc3696'
            },
            ejemplo: 'cas@click.com.py'
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