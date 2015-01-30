function contenido_diccionario(url_anho_cod_geo) {
    var diccionario = [
        {
            nombre: 'PERIODO',
            descripcion: 'Indica el año al cual corresponde el requerimiento. Los requerimientos de las instituciones educativas se recepcionan de forma anual. Todos los requerimientos para un año específico se reciben durante el año anterior',
            tipo: 'xsd:gYear',
            restricciones: '',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: '2015'
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
            nombre: 'NUMERO_PRIORIDAD',
            descripcion: 'Indica el número de prioridad del requerimiento. Los requerimientos se priorizan por cada distrito de cada departamento para el período correspondiente. El número de prioridad de un requerimiento indica su orden de importancia en relación con los demás requerimientos del mismo tipo. Los requerimientos priorizados se ejecutan desde el requerimiento con número de prioridad 1 hasta el requerimiento con el mayor número de prioridad posible en base al presupuesto disponible destinado',
            tipo: 'xsd:positiveInteger',
            restricciones: '',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: '1'
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
            nombre: 'NIVEL_EDUCATIVO_BENEFICIADO',
            descripcion: 'Indica el nivel educativo que resultaría beneficiado en caso de atenderse (satisfacerse) la necesidad de la institución educativa indicada por el requerimiento',
            tipo: 'xsd:string',
            restricciones: '',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: 'EDUCACIÓN ESCOLAR BASICA'
        }, {
            nombre: 'ABASTECIMIENTO_AGUA',
            descripcion: 'Indica el nombre del servicio de abstecimiento de agua potable que utiliza el establecimiento escolar',
            tipo: 'xsd:string',
            restricciones: '',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: 'ESSAP'
        }, {
            nombre: 'SERVICIO_SANITARIO_ACTUAL',
            descripcion: 'Indica el nombre del servicio sanitario que utiliza el establecimiento escolar',
            tipo: 'xsd:string',
            restricciones: '',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: 'WC conectado a red publica'
        }, {
            nombre: 'CUENTA_ESPACIO_PARA_CONSTRUCCION',
            descripcion: 'Especifica si el local escolar donde está situada la institución educativa cuenta o no con espacio disponible para construcción',
            tipo: 'xsd:string',
            restricciones: '',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: 'SI'
        }, {
            nombre: 'TIPO_REQUERIMIENTO_INFRAESTRUCTURA',
            descripcion: 'Especifica el tipo del requerimiento. Los requerimientos pueden ser de tres tipos: Construcción Nueva, Reparación, y Adecuación',
            tipo: 'xsd:string',
            restricciones: 'Valores en el rango: NUEVO, REPARACION, ADECUACION',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: 'NUEVO'
        }, {
            nombre: 'CANTIDAD_REQUERIDA',
            descripcion: 'Corresponde a la cantidad de sanitarios a construir, a reparar, o a adecuar (dependiendo del tipo de requerimiento) requeridas por la institución educativa',
            tipo: 'xsd:positiveInteger',
            restricciones: '',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: '10'
        }, {
            nombre: 'NUMERO_BENEFICIADOS',
            descripcion: 'Indica la cantidad de personas que resultarían beneficiadas en caso de atenderse (satisfacerse) la necesidad de la institución educativa indicada por el requerimiento',
            tipo: 'xsd:positiveInteger',
            restricciones: '',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: '100'
        }, {
            nombre: 'JUSTIFICACION',
            descripcion: 'Corresponde a la descripción de la justificación del requerimiento especificada por la institución educativa',
            tipo: 'xsd:string',
            restricciones: '',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: ''
        }
    ];
    return diccionario;
}