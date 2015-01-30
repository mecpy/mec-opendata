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
            nombre: 'CANTIDAD_MATRICULADOS',
            descripcion: 'Representa la cantidad total de matriculados en los departamentos por distrito',
            tipo: 'xsd:positiveInteger',
            restricciones: '',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: '93354'
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