class MapaEstablecimientosActualizacionesController < ApplicationController

  skip_before_filter :verify_authenticity_token, :only => [:actualizacion]
  before_filter :authenticate, :only => [:actualizacion]

  def authenticate
    if APP_CONFIG[:perform_authentication]
      authenticate_or_request_with_http_basic do |username, password|
        username == APP_CONFIG[:username] && password == APP_CONFIG[:password]
      end
    end
  end

  def actualizacion

    estado = []

    #Establecimientos
    periodos = [2014, 2012]
    for p in periodos
      query = "SELECT row_to_json(egeojson) As e_geojson
                  FROM ( SELECT 'FeatureCollection' As type, array_to_json(array_agg(f)) As features
                  FROM (SELECT 'Feature' As type
                  , ST_AsGeoJSON(es.geom)::json As geometry
                  , row_to_json((SELECT l FROM (SELECT es.anio::text As periodo, es.codigo_establecimiento As codigo_establecimiento, 
                    es.nombre_departamento As nombre_departamento, es.nombre_distrito As nombre_distrito, es.nombre_barrio_localidad As nombre_barrio_localidad,
                    es.nombre_zona As nombre_zona, es.proyecto_111 As proyecto111, es.proyecto_822 As proyecto822) As l)) As properties
                  FROM establecimientos As es WHERE es.anio=#{p} AND (NOT es.longitud='') AND (NOT es.latitud='') ) 
                  As f) As egeojson"
      nombre_archivo = "topojson_establecimientos_#{p}.json"
      estado << consulta(query, nombre_archivo)
    end

    #Departamentos
    condicion = "(COALESCE(nombre_barrio_localidad, '') = '') AND (COALESCE(nombre_distrito, '') = '') AND (NOT (COALESCE(nombre_departamento, '') = ''))"
    query = "SELECT row_to_json(egeojson) As e_geojson
            FROM ( SELECT 'FeatureCollection' As type, array_to_json(array_agg(f)) As features
            FROM (SELECT 'Feature' As type
            , ST_AsGeoJSON(vmc.geom)::json As geometry
            , row_to_json((SELECT l FROM (SELECT vmc.nombre_departamento As nombre_departamento) As l)) As properties
            FROM v_mapa_centroide As vmc WHERE " + condicion + ") As f) As egeojson"
    nombre_archivo = "topojson_departamentos.json"
    estado << consulta(query, nombre_archivo)

    #Distritos
    condicion = "(COALESCE(nombre_barrio_localidad, '') = '') AND (NOT (COALESCE(nombre_distrito, '') = '')) AND (NOT (COALESCE(nombre_departamento, '') = ''))"
    query = "SELECT row_to_json(egeojson) As e_geojson
            FROM ( SELECT 'FeatureCollection' As type, array_to_json(array_agg(f)) As features
            FROM (SELECT 'Feature' As type
            , ST_AsGeoJSON(vmc.geom)::json As geometry
            , row_to_json((SELECT l FROM (SELECT vmc.nombre_departamento As nombre_departamento, vmc.nombre_distrito As nombre_distrito) As l)) As properties
            FROM v_mapa_centroide As vmc WHERE " + condicion + ") As f) As egeojson"
    nombre_archivo = "topojson_distritos.json"
    estado << consulta(query, nombre_archivo)

    #Barrio/Localidades
    condicion = "((NOT COALESCE(nombre_barrio_localidad, '') = '')) AND (NOT (COALESCE(nombre_distrito, '') = '')) AND (NOT (COALESCE(nombre_departamento, '') = ''))"
    query = "SELECT row_to_json(egeojson) As e_geojson
            FROM ( SELECT 'FeatureCollection' As type, array_to_json(array_agg(f)) As features
            FROM (SELECT 'Feature' As type
            , ST_AsGeoJSON(vmc.geom)::json As geometry
            , row_to_json((SELECT l FROM (SELECT vmc.nombre_departamento As nombre_departamento, vmc.nombre_distrito As nombre_distrito,
              vmc.nombre_barrio_localidad As nombre_barrio_localidad) As l)) As properties
            FROM v_mapa_centroide As vmc WHERE " + condicion + ") As f) As egeojson"
    nombre_archivo = "topojson_barrio_localidad.json"
    estado << consulta(query, nombre_archivo)

    if estado.include?(false)
      respuesta = "Error"
    else
      respuesta = "Actualizacion"
    end

    render :json => respuesta

  end

  def consulta(query, nombre_archivo)
    
    estado = false

    begin
      results = ActiveRecord::Base.connection.execute(query)
      results = results.values.to_json.gsub!('\\', '')[3..-4]
      estado = convert_to_topojson(results, nombre_archivo)
    rescue Exception => e
      estado = false
      puts e.message  
      puts e.backtrace.inspect
    ensure
      return estado
    end

  end


  def convert_to_topojson(geojson, nombre_archivo)

    require 'open3'
    estado = false
    
    begin
      file = Tempfile.new(['input', '.json'])
      ruta_destino = "#{Rails.root}/app/assets/javascripts/geometrias/#{nombre_archivo}"
      file.write(geojson)
      file.close
      cmd = "topojson -o #{ruta_destino} #{file.path} -p"
      Open3.popen3(cmd) do |stdin, stdout, stderr|
        estado = true
        stdin.close
        stdout.close
        stderr.close
      end
    rescue Exception => e
      estado = false
      puts e.message  
      puts e.backtrace.inspect
    ensure
      file.unlink
      return estado
    end

  end


end

#Crear la carpeta geometrias en mec-opendata/app/assets/javascripts
#curl -X POST http://localhost:3000/app/mapa_establecimientos_actualizaciones
#curl -X POST http://localhost:3000/app/mapa_establecimientos_actualizaciones -u "mecpy:mecpy2015"
