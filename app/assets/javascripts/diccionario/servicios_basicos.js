function contenido_diccionario(url_anho_cod_geo) {
    var diccionario = [
        {
            nombre: 'PERIODO',
            descripcion: 'Indica el año al cual corresponde el estado o situación actual en que se encuentra el establecimiento. Los establecimientos pueden contar con modificaciones en su estructura en forma anual',
            tipo: 'xsd:gYear',
            restricciones: '',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: '2014'
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
            nombre: 'CODIGO_BARRIO_LOCALIDAD',
            descripcion: 'Corresponde al código asignado a la localidad o barrio del distrito donde esta localizado el establecimiento escolar',
            tipo: 'xsd:positiveInteger',
            restricciones: 'No más de 5 caracteres',
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
            nombre: 'NOMBRE_ASENTAMIENTO_COLONIA',
            descripcion: 'Corresponde a la descripción del nombre del asentamiento o colonia donde está ubicado el establecimiento escolar',
            tipo: 'xsd:string',
            restricciones: '',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: ''
        }, {
            nombre: 'SUMINISTRO_ENERGIA_ELECTRICA',
            descripcion: 'Indica el nombre del servicio de suministro de energía eléctrica que utiliza el establecimiento escolar',
            tipo: 'xsd:string',
            restricciones: 'No más de 40 caracteres',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: 'ANDE'
        }, {
            nombre: 'ABASTECIMIENTO_AGUA',
            descripcion: 'Indica el nombre del servicio de abstecimiento de agua potable que utiliza el establecimiento escolar',
            tipo: 'xsd:string',
            restricciones: 'No más de 40 caracteres',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: 'ESSAP'
        }, {
            nombre: 'SERVICIO_SANITARIO_ACTUAL',
            descripcion: 'Indica el nombre del servicio sanitario que utiliza el establecimiento escolar',
            tipo: 'xsd:string',
            restricciones: 'No más de 60 caracteres',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: 'WC CONECTADO A RED PÚBLICA'
        }, {
            nombre: 'TITULO_DE_PROPIEDAD',
            descripcion: 'Indica el establecimiento escolar cuenta o no con título de propiedad',
            tipo: 'xsd:string',
            restricciones: '',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: 'MEC'
        }, {
            nombre: 'CUENTA_PLANO',
            descripcion: 'Indica si el establecimiento escolar cuenta o no con el plano de su edificación',
            tipo: 'xsd:string',
            restricciones: '',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: 'SI'
        }, {
            nombre: 'PREVENCION_INCENDIO',
            descripcion: 'Indica si el establecimiento escolar cuenta o no con un mecanismo de segurirdad de prevención contra incendios para casos de emergencias',
            tipo: 'xsd:string',
            restricciones: '',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: 'SI'
        }
    ];
    return diccionario;
}