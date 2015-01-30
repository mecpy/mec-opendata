function contenido_diccionario(url_anho_cod_geo) {
    var diccionario = [
        {
            nombre: 'EJERCICIO_FISCAL',
            descripcion: 'Se refiere al año del Llamado a Licitaci&oacute;n',
            tipo: 'xsd:gYear',
            restricciones: '',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: '2014'
        }, {
            nombre: 'NOMBRE',
            descripcion: '',
            tipo: 'xsd:string',
            restricciones: 'No m&aacute;s de 100 caracteres',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: ''
        }, {
            nombre: 'DESCRIPCION',
            descripcion: '',
            tipo: 'xsd:string',
            restricciones: 'No m&aacute;s de 100 caracteres',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: ''
        }, {
            nombre: 'FECHA_CONTRATO',
            descripcion: '',
            tipo: 'xsd:date',
            restricciones: '',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: '20/02/2014'
        }, {
            nombre: 'FECHA_VIGENCIA_CONTRATO',
            descripcion: '',
            tipo: 'xsd:date',
            restricciones: '',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: '20/03/2014'
        }, {
            nombre: 'ESTADO_LLAMADO',
            descripcion: '',
            tipo: 'xsd:string',
            restricciones: 'No m&aacute;s de 40 caracteres',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: 'EJECUTADO'
        }, {
            nombre: 'MODALIDAD',
            descripcion: '',
            tipo: 'xsd:string',
            restricciones: 'No m&aacute;s de 200 caracteres',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: 'Licitaci&oacute;n por Concurso de Ofertas'
        }, {
            nombre: 'CATEGORIA',
            descripcion: '',
            tipo: 'xsd:string',
            restricciones: 'No m&aacute;s de 100 caracteres',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: 'Muebles y Enseres'
        }, {
            nombre: 'LLAMADO_PUBLICO',
            descripcion: '',
            tipo: 'xsd:positiveInteger',
            restricciones: '',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: '271667'
        }
    ];
    return diccionario;
}