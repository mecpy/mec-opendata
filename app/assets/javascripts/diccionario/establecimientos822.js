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
            ejemplo: '2014'
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
            nombre: 'COORDENADAS_Y',
            descripcion: 'Corresponde a las coordenadas planas (en metros). Las coordenadas "Y", cuyo valor es mayor a 7.000.000 m, salvo al sur en el límite con la República Argentina donde podrían aparecer valores cercanos a 6.950.000 m',
            tipo: 'xsd:positiveInteger',
            restricciones: 'No más de 7 digitos',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: '7202502'
        }, {
            nombre: 'COORDENADAS_X',
            descripcion: 'Corresponde a las coordenadas planas ( en metros). Valores de las coordenadas "X", cuyo valor será siempre menor a 1.000.000 m',
            tipo: 'xsd:positiveInteger',
            restricciones: 'No más de 6 digitos',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: '433358'
        }, {
            nombre: 'LATITUD',
            descripcion: 'Corresponde a los valores de coordenadas geográficas, es decir la Latitud , las cuales se expresan en Grados (Gra), minutos (min) y segundos (seg)',
            tipo: 'xsd:positiveInteger',
            restricciones: '',
            referencia: {
                texto: 'Referencia de Google Maps',
                enlace: 'https://support.google.com/maps/answer/18539?hl=es'
            },
            ejemplo: "25° 17' 32.903\" S"
        }, {
            nombre: 'LONGITUD',
            descripcion: 'Corresponde a los valores de coordenadas geográficas, es decir la Longitud , las cuales se expresan en Grados (Gra), minutos (min) y segundos (seg)',
            tipo: 'xsd:positiveInteger',
            restricciones: '',
            referencia: {
                texto: 'Referencia de Google Maps',
                enlace: 'https://support.google.com/maps/answer/18539?hl=es'
            },
            ejemplo: "57° 39' 43.122\" W"
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