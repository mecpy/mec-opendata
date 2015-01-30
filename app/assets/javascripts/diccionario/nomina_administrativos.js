function contenido_diccionario(url_anho_cod_geo) {
    var diccionario = [
        {
            nombre: 'AÑO',
            descripcion: 'Se refiere al año al cual corresponden los datos',
            tipo: 'xsd:gYear',
            restricciones: 'Sólo permite la carga de datos del año de su captura',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: '2014'
        }, {
            nombre: 'MES',
            descripcion: 'Se refiere al mes del año al cual corresponden los datos',
            tipo: 'xsd:string',
            restricciones: 'Sólo permite la carga de datos del mes de su captura',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: 'junio'
        }, {
            nombre: 'N&uacute;mero de documento',
            descripcion: 'Se refiere al número de documento de identidad Paraguaya',
            tipo: 'xsd:string',
            restricciones: 'No m&aacute;s de 10 caracteres',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: '123456'
        }, {
            nombre: 'Nombre completo',
            descripcion: 'Se refiere al o los nombres y al o los apellidos de la persona',
            tipo: 'xsd:string',
            restricciones: 'No más de 100 caracteres',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: 'Juan Pérez'
        }, {
            nombre: 'Objeto de gasto',
            descripcion: 'Se refiere al código del objeto del gasto del clasificador presupuestario',
            tipo: 'xsd:positiveInteger',
            restricciones: 'Mayor a cero',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: '111'
        }, {
            nombre: 'Nombre del objeto de gasto',
            descripcion: 'Se refiere al nombre objeto del gasto del clasificador presupuestario',
            tipo: 'xsd:string',
            restricciones: 'No m&aacute;s de 30 caracteres',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: 'Sueldos; Bonificaciones y gratificaciones'
        }, {
            nombre: 'Estado',
            descripcion: 'Corresponde a la situación laboral del personal en relación al MEC',
            tipo: 'xsd:string',
            restricciones: 'No m&aacute;s de 30 caracteres',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: 'Permanente'
        }, {
            nombre: 'Antigüedad',
            descripcion: 'Se refiere al tiempo durante el cual la persona ha trabajado en forma ininterrumpida dentro del MEC. Esta antigüedad se puede dividir en antigüedad administrativa y docente',
            tipo: 'xsd:string',
            restricciones: 'No m&aacute;s de 30 caracteres',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: '2 años 4 meses'
        }, {
            nombre: 'Concepto',
            descripcion: 'Se refiere al concepto por el cual se está asignando el objeto del gasto',
            tipo: 'xsd:string',
            restricciones: 'No más de 30 caracteres',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: 'Sueldos; Bonificación por antigüedad'
        }, {
            nombre: 'Dependencia',
            descripcion: 'Se refiere a la dependencia del MEC donde cumple funciones el personal. Una dependencia puede corresponder a la Administración Central, o instituciones educativas',
            tipo: 'xsd:string',
            restricciones: 'No más de 30 caracteres',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: 'Dirección General de Administración y Finanzas'
        }, {
            nombre: 'Cargo',
            descripcion: 'Se refiere a la función que desempeña el personal',
            tipo: 'xsd:string',
            restricciones: 'No más de 30 caracteres',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: 'Auxiliar de Servicios'
        }, {
            nombre: 'Rubro',
            descripcion: 'Se refiere a la categoría del rubro correspondiente al anexo del personal, por el cual se le paga al personal',
            tipo: 'xsd:string',
            restricciones: 'No más de 30 caracteres',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: 'GE1'
        }, {
            nombre: 'Monto Rubro',
            descripcion: 'Se refiere a la asignación de la categoría del rubro, en forma unitaria',
            tipo: 'xsd:positiveInteger',
            restricciones: 'Mayor a cero',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: '1.658.232'
        }, {
            nombre: 'Cantidad',
            descripcion: 'Se refiere a la cantidad de rubros asignados',
            tipo: 'xsd:positiveInteger',
            restricciones: 'Mayor a cero',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: '1'
        }, {
            nombre: 'Asignación',
            descripcion: 'Se refiere a la asignación total por objeto de gasto que percibe el personal. En caso de que el concepto tenga categoría de rubro, se multiplica el monto de la categoría por la cantidad',
            tipo: 'xsd:positiveInteger',
            restricciones: 'Mayor a cero',
            referencia: {
                texto: '',
                enlace: ''
            },
            ejemplo: '1.658.232'
        }
    ];
    return diccionario;
}