class ServiceActualizacionesController < ApplicationController

  skip_before_filter :verify_authenticity_token, :only => [:actualizacion_geometrias, :generar_csv_json]
  before_filter :authenticate, :only => [:actualizacion_geometrias, :generar_csv_json]


  def authenticate
    if APP_CONFIG[:perform_authentication]
      authenticate_or_request_with_http_basic do |username, password|
        username == APP_CONFIG[:username] && password == APP_CONFIG[:password]
      end
    end
  end


  ##############################################
  ###ACTUALIZACION DE LAS GEOMETRIAS DEL MAPA###
  ##############################################
  def actualizacion_geometrias

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
                  FROM establecimientos As es WHERE es.anio=#{p} AND (NOT es.longitud='') AND (NOT es.latitud='') 
                  ORDER BY es.nombre_departamento ASC, es.nombre_distrito ASC, es.nombre_barrio_localidad ASC ) 
                  As f) As egeojson"
      nombre_archivo = "topojson_establecimientos_#{p}.json"
      estado << consulta(query, 1,  nombre_archivo)
    end

    #Instituciones
    periodos = [2014, 2012]
    for p in periodos
      query = "SELECT vdi.nombre_departamento, vdi.nombre_distrito, vdi.nombre_barrio_localidad,
              vdi.codigo_institucion, vdi.nombre_institucion, vdi.codigo_establecimiento
              FROM v_directorios_instituciones vdi JOIN establecimientos es 
              ON(vdi.periodo=es.anio AND vdi.codigo_establecimiento=es.codigo_establecimiento)
              WHERE vdi.periodo=2014 AND (NOT es.longitud='') AND (NOT es.latitud='') 
              ORDER BY vdi.nombre_departamento ASC, vdi.nombre_distrito ASC, vdi.nombre_barrio_localidad ASC"
      nombre_archivo = "instituciones_#{p}.json"
      estado << consulta(query, 2, nombre_archivo)
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
    estado << consulta(query, 1, nombre_archivo)

    #Distritos
    condicion = "(COALESCE(nombre_barrio_localidad, '') = '') AND (NOT (COALESCE(nombre_distrito, '') = '')) AND (NOT (COALESCE(nombre_departamento, '') = ''))"
    query = "SELECT row_to_json(egeojson) As e_geojson
            FROM ( SELECT 'FeatureCollection' As type, array_to_json(array_agg(f)) As features
            FROM (SELECT 'Feature' As type
            , ST_AsGeoJSON(vmc.geom)::json As geometry
            , row_to_json((SELECT l FROM (SELECT vmc.nombre_departamento As nombre_departamento, vmc.nombre_distrito As nombre_distrito) As l)) As properties
            FROM v_mapa_centroide As vmc WHERE " + condicion + ") As f) As egeojson"
    nombre_archivo = "topojson_distritos.json"
    estado << consulta(query, 1, nombre_archivo)

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
    estado << consulta(query, 1, nombre_archivo)

    log = Time.now
    log = log.inspect
    if estado.include?(false)
      respuesta = "[ #{log.inspect} ] Error!!! Ha ocurrido un imprevisto en la actualización de las geometrías. Por favor, realice manualmente el proceso."
    else
      respuesta = "[ #{log.inspect} ] Success!! Actualización correcta de las geometrías."
    end

    render :json => respuesta

  end


  def consulta(query, tipo_query, nombre_archivo)
    
    estado = false

    begin
      results = ActiveRecord::Base.connection.execute(query)
      if tipo_query == 1
        results = results.values.to_json.gsub!('\\', '')[3..-4]
        estado = convert_to_topojson(results, nombre_archivo)
      elsif tipo_query == 2
        file = File.open("#{Rails.root}/app/assets/javascripts/geometrias/#{nombre_archivo}", "w")
        file.write(results.to_json)
        file.close unless file == nil
        estado = true
      end
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
      cmd = "topojson -o #{ruta_destino} #{file.path} -p -q 1e5"
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


  ########################################################
  ###ACTUALIZACION DE LOS CSV Y JSON PARA LAS DESCARGAS###
  ########################################################
  def generar_csv_json
    
    begin
      crear_archivo_csv_json()
      respuesta = generar_log("Success!! Actualización correcta de los archivos para descargas.")
    rescue Exception => e
      puts e.message  
      puts e.backtrace.inspect
      respuesta = generar_log("Error!!! Ha ocurrido un imprevisto en la actualización de los archivos para descargas. Por favor, intentenlo más tarde o contacte con el administrador.")
    end

    render :json => respuesta

  end

  def crear_archivo_csv_json()

    #CSV
    nombre_archivo = 'matricula_inicial.csv'
    query = 
    "
    COPY 
    (
      SELECT *
      FROM matriculaciones_inicial
    )
    TO '/tmp/#{nombre_archivo}'
    WITH CSV HEADER FORCE QUOTE *;
    "
    #ejecutar_query(query)
    #copiar_archivo_a_rails(nombre_archivo)

    #JSON
    nombre_archivo = 'matricula_inicial.json'
    query = 
    "
    COPY 
    (SELECT array_to_json(array_agg(t)) 
    FROM (select * from matriculaciones_inicial) t)
    TO '/tmp/#{nombre_archivo}';
    "
    ejecutar_query(query)
    zip_archivo(nombre_archivo)
    #copiar_archivo_a_rails(nombre_archivo+'.zip')

  end

  private
  def generar_log(mensaje)
    log = Time.now
    log = log.inspect
    return "[ #{log.inspect} ] " + mensaje
  end


  private
  def ejecutar_query(query)
    ActiveRecord::Base.connection.execute(query)
  end


  private
  def copiar_archivo_a_rails(nombre_archivo)

    require 'open3'

    begin
      cmd = "cp /tmp/#{nombre_archivo} #{Rails.root}/public/data"
      Open3.popen3(cmd) do |stdin, stdout, stderr|
        stdin.close
        stdout.close
        stderr.close
      end
    rescue Exception => e
      puts e.message  
      puts e.backtrace.inspect
    end
  end

  private
  def zip_archivo(nombre_archivo)

    require 'open3'

    begin
      cmd = "zip -j #{Rails.root}/public/data/#{nombre_archivo}.zip /tmp/#{nombre_archivo}"
      Open3.popen3(cmd) do |stdin, stdout, stderr|
        stdin.close
        stdout.close
        stderr.close
      end
    rescue Exception => e
      puts e.message  
      puts e.backtrace.inspect
    end
  end


end

#Crear la carpeta geometrias en mec-opendata/app/assets/javascripts
#curl -X POST http://localhost:3000/app/service_actualizaciones_actualizacion_geometrias
#curl -X POST http://localhost:3000/app/service_actualizaciones_actualizacion_geometrias -u "mecpy:mecpy2015" > /tmp/crontab.log

#curl -X POST http://localhost:3000/app/service_actualizaciones_generar_csv_json -u "mecpy:mecpy2015" > /tmp/crontab.log


#INSTALACION DE NODE.JS EN CENTOS
#https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-a-centos-7-server
#npm install -g topojson

#INSTALACION DE ZIP
#sudo apt-get install zip
#yum install zip