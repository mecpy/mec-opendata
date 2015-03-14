var SMV = SMV || {};

SMV.ATTR_TO_LABEL = {
    Proyecto: 'Proyecto',
    Localidad: 'Localidad',
    Distrito: 'Distrito',
    Departamento: 'Departamento',
    Empresa: 'Empresa Constructora',
    'Cantidad de Viviendas': 'Cantidad de Viviendas',
    Programa: 'Programa',
    'Licitación Nº': 'Licitación Nº',
    'Contrato N°': 'Contrato N°',
    'Estado de Obra': 'Estado de Obra',
    'Fecha de inicio de obra': 'Fecha de inicio de obra',
    'Fecha de entrega de obra': 'Fecha de entrega de obra',
    'Dato de contacto - Empresa': 'Dato de contacto - Empresa',
    'SAT - Servicio de Asistencia Técnica': 'SAT - Servicio de Asistencia Técnica',
    'Dato de contacto - SAT': 'Dato de contacto - SAT',
    'EAT - Equipo de Asistencia Técnica': 'EAT - Equipo de Asistencia Técnica',
    'Dato de contacto - EAT': 'Dato de contacto - EAT',
    'Origen del terreno': 'Origen del terrenos',
    'Porcentaje de avance': 'Porcentaje de avance',
    'Calificación provisional': 'Calificación provisional',
    'Observaciones': 'Observaciones'
};


SMV.ESTADO_TO_ICON = {
    'Paralizado': 'static/img/paralizado.png',
    'En ejecución': 'static/img/ejecucion.png',
    'Culminada': 'static/img/culminado.png',
    'En licitación': 'static/img/details.png'
};

SMV.ESTADO_TO_ICON_CSS = {
    'Paralizado': 'icon-paralizado',
    'En ejecución': 'icon-ejecucion',
    'Culminada': 'icon-culminado',
    'En licitación': 'icon-licitacion'
};

SMV.POPUP_ROWS = {
    "General": ["Departamento", "Distrito", "Proyecto", "Programa", "Estado de Obra", "Cantidad de Viviendas"],
    "Detalles": ["Localidad", "Licitación Nº",
        "Contrato N°", "Empresa", "Dato de contacto - Empresa", "SAT - Servicio de Asistencia Técnica", "Dato de contacto - SAT",
        "EAT - Equipo de Asistencia Técnica", "Dato de contacto - EAT", "Porcentaje de avance", "Origen del terreno",
        "Fecha de inicio de obra", "Fecha de entrega de obra", "Calificación provisional", "Observaciones"]
};

SMV.DATA_COLUMNS = 5;

SMV.BUTTON_COLUMNS = 2;

SMV.LAYERS = function () {
    var mapbox = L.tileLayer(
            'http://api.tiles.mapbox.com/v4/rparra.jmk7g7ep/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoicnBhcnJhIiwiYSI6IkEzVklSMm8ifQ.a9trB68u6h4kWVDDfVsJSg');
    var osm = L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {minZoom: 3});
    var gglHybrid = new L.Google("HYBRID");
    var gglRoadmap = new L.Google("ROADMAP");
    return {
        MAPBOX: mapbox,
        OPEN_STREET_MAPS: osm,
        GOOGLE_HYBRID: gglHybrid,
        GOOGLE_ROADMAP: gglRoadmap
    }
}