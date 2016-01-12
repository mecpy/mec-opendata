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

  def crear_archivo_csv_json

    descargas_establecimientos();
    descargas_directorios_instituciones();
    descargas_matriculas();
    descargas_contrataciones();
    descargas_registros_titulos();
    descargas_nominas();

  end

  private
  def generar_log(mensaje)
    log = Time.now
    log = log.inspect
    return "[ #{log.inspect} ] " + mensaje
  end

  private
  def zip_archivo(nombre_archivo, extensions)

    folder = "#{Rails.root}/public/data/"
    for e in extensions
      filename = nombre_archivo + "." + e
      zipfile_name = "#{Rails.root}/public/data/" + filename + ".zip"
      if File.exist?(zipfile_name)
        FileUtils.rm (zipfile_name)
      end
      Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
        zipfile.add(filename, folder + filename)
      end
      FileUtils.rm (folder + filename)
    end

  end

  def descargas_establecimientos

    anios = Establecimiento.select(:anio).distinct
    for year in anios
        
        year=year.anio
        ###
        ###ESTABLECIMIENTOS###
        ###
        nombre_archivo = "establecimientos_#{year}"
        cond = "anio = #{year}"
        establecimientos = Establecimiento.orden_dep_dis.where(cond)

        #DESCARGA CSV
        CSV.open("#{Rails.root}/public/data/#{nombre_archivo}.csv", "wb", {:force_quotes => true}) do |csv|
          # header row
          csv << ["anio", "codigo_establecimiento", "codigo_departamento", "nombre_departamento", "codigo_distrito", "nombre_distrito", "codigo_zona", "nombre_zona", "codigo_barrio_localidad",
            "nombre_barrio_localidad", "direccion", "coordenadas_y", "coordenadas_x", "latitud", "longitud", "anho_cod_geo", "uri"]
   
          # data rows
          establecimientos.each do |e|
            csv << [e.anio, e.codigo_establecimiento, e.codigo_departamento, e.nombre_departamento, e.codigo_distrito, e.nombre_distrito, e.codigo_zona, e.nombre_zona, e.codigo_barrio_localidad,
              e.nombre_barrio_localidad, e.direccion, e.coordenadas_y, e.coordenadas_x, e.latitud, e.longitud, e.anho_cod_geo, e.uri ]
          end
        end

        #DESCARGA XLS
        p = Axlsx::Package.new      
        p.workbook.add_worksheet(:name => "Establecimientos") do |sheet|          
          sheet.add_row [:anio, :codigo_establecimiento, :codigo_departamento, :nombre_departamento, :codigo_distrito, :nombre_distrito, :codigo_zona, :nombre_zona, :codigo_barrio_localidad, :nombre_barrio_localidad, :direccion, :coordenadas_y, :coordenadas_x, :latitud, :longitud, :anho_cod_geo, :uri] 
            
          establecimientos.each do |e|              
            sheet.add_row [e.anio, e.codigo_establecimiento, e.codigo_departamento, e.nombre_departamento, e.codigo_distrito, e.nombre_distrito, e.codigo_zona, e.nombre_zona, e.codigo_barrio_localidad, e.nombre_barrio_localidad, e.direccion, e.coordenadas_y, e.coordenadas_x, e.latitud, e.longitud, e.anho_cod_geo, e.uri]
          end
        end

        p.serialize("#{Rails.root}/public/data/#{nombre_archivo}.xlsx")

        #DESCARGA JSON
        File.open("#{Rails.root}/public/data/#{nombre_archivo}.json","w") do |f|
          f.write(establecimientos.to_json)
        end

        #DESCARGA ZIP
        #zip_archivo(nombre_archivo, ['xlsx', 'csv', 'json'])
    
    end #end for

  end #end function "descargas_establecimientos"


  def descargas_directorios_instituciones

    anios = VDirectorioInstitucion.select(:periodo).distinct
    for year in anios
        
        year=year.periodo

        ###
        ###DIRECTORIOS DE INSTITUCIONES###
        ###
        nombre_archivo = "directorios_instituciones_#{year}"
        cond = "periodo = #{year}"
        directorios_instituciones = VDirectorioInstitucion.orden_dep_dis.where(cond)

        #DESCARGA CSV
        CSV.open("#{Rails.root}/public/data/#{nombre_archivo}.csv", "wb", {:force_quotes => true}) do |csv|
          # header row
          csv << ["periodo", "codigo_departamento", "nombre_departamento", "codigo_distrito", "nombre_distrito", 
            "codigo_barrio_localidad","nombre_barrio_localidad", "codigo_zona", "nombre_zona",
            "codigo_establecimiento", "codigo_institucion", "nombre_institucion", "anho_cod_geo", 
            "uri_establecimiento", "uri_institucion"]
   
          # data rows
          directorios_instituciones.each do |i|
            csv << [i.periodo, i.codigo_departamento, i.nombre_departamento, i.codigo_distrito, i.nombre_distrito,
              i.codigo_barrio_localidad, i.nombre_barrio_localidad, i.codigo_zona, i.nombre_zona,
              i.codigo_establecimiento, i.codigo_institucion, i.nombre_institucion, i.anho_cod_geo, 
              i.uri_establecimiento,i.uri_institucion]
          end
        end

        #DESCARGA XLS
        p = Axlsx::Package.new      
        p.workbook.add_worksheet(:name => "Directorio de Instituciones") do |sheet|          
          sheet.add_row [:periodo, :codigo_departamento, :nombre_departamento, :codigo_distrito, :nombre_distrito,
          :codigo_barrio_localidad, :nombre_barrio_localidad, :codigo_zona, :nombre_zona,
          :codigo_establecimiento, :codigo_institucion, :nombre_institucion, :anho_cod_geo,
          :uri_establecimiento,:uri_institucion]
            
          directorios_instituciones.each do |i|              
            sheet.add_row [i.periodo, i.codigo_departamento, i.nombre_departamento, i.codigo_distrito, i.nombre_distrito,
            i.codigo_barrio_localidad, i.nombre_barrio_localidad, i.codigo_zona, i.nombre_zona,
            i.codigo_establecimiento, i.codigo_institucion, i.nombre_institucion, i.anho_cod_geo, 
            i.uri_establecimiento,i.uri_institucion]
          end
        end

        p.serialize("#{Rails.root}/public/data/#{nombre_archivo}.xlsx")

        #DESCARGA JSON
        File.open("#{Rails.root}/public/data/#{nombre_archivo}.json","w") do |f|
          f.write(directorios_instituciones.to_json)
        end

        #DESCARGA ZIP
        #zip_archivo(nombre_archivo, ['xlsx', 'csv', 'json'])
    
    end #end for

  end #end function "descargas_directorios_instituciones"


  def descargas_matriculas

    anios = MatriculacionInicial.select(:anio).distinct
    for year in anios
        
        year=year.anio

        ###
        ###MATRICULAS EDUCACION INICIAL###
        ###
        nombre_archivo = "matriculaciones_inicial_#{year}"
        cond = "anio = #{year}"
        matriculaciones_inicial = MatriculacionInicial.ordenado_institucion.where(cond)

        #DESCARGA CSV
        CSV.open("#{Rails.root}/public/data/#{nombre_archivo}.csv", "wb", {:force_quotes => true}) do |csv|
          # header row
          csv << ["anio", "codigo_establecimiento", "codigo_departamento", "nombre_departamento",
            "codigo_distrito", "nombre_distrito", "codigo_zona", "nombre_zona", "codigo_barrio_localidad", "nombre_barrio_localidad",
            "codigo_institucion", "nombre_institucion", "sector_o_tipo_gestion", "anho_cod_geo",
            "maternal_hombre", "maternal_mujer", "prejardin_hombre", "prejardin_mujer", "jardin_hombre", "jardin_mujer",
            "preescolar_hombre", "preescolar_mujer", "total_matriculados_hombre", "total_matriculados_mujer",
            "inicial_noformal_hombre", "inicial_noformal_mujer"]

          # data rows
          matriculaciones_inicial.each do |m|
            csv << [m.anio, m.codigo_establecimiento, m.codigo_departamento, m.nombre_departamento,
              m.codigo_distrito, m.nombre_distrito, m.codigo_zona, m.nombre_zona, m.codigo_barrio_localidad, m.nombre_barrio_localidad,
              m.codigo_institucion, m.nombre_institucion, m.sector_o_tipo_gestion, m.anho_cod_geo,
              m.maternal_hombre, m.maternal_mujer, m.prejardin_hombre, m.prejardin_mujer, m.jardin_hombre, m.jardin_mujer,
              m.preescolar_hombre, m.preescolar_mujer, m.total_matriculados_hombre, m.total_matriculados_mujer,
              m.inicial_noformal_hombre, m.inicial_noformal_mujer]
          end      
        end

        #DESCARGA XLS
        p = Axlsx::Package.new      
        p.workbook.add_worksheet(:name => "Matriculaciones EI") do |sheet|          
          sheet.add_row [:anio, :codigo_establecimiento, :codigo_departamento, :nombre_departamento,
            :codigo_distrito, :nombre_distrito, :codigo_zona, :nombre_zona, :codigo_barrio_localidad, :nombre_barrio_localidad,
            :codigo_institucion, :nombre_institucion, :sector_o_tipo_gestion, :anho_cod_geo,
            :maternal_hombre, :maternal_mujer, :prejardin_hombre, :prejardin_mujer, :jardin_hombre, :jardin_mujer,
            :preescolar_hombre, :preescolar_mujer, :total_matriculados_hombre, :total_matriculados_mujer,
            :inicial_noformal_hombre, :inicial_noformal_mujer]
            
          matriculaciones_inicial.each do |m|              
            sheet.add_row [m.anio, m.codigo_establecimiento, m.codigo_departamento, m.nombre_departamento,
              m.codigo_distrito, m.nombre_distrito, m.codigo_zona, m.nombre_zona, m.codigo_barrio_localidad, m.nombre_barrio_localidad,
              m.codigo_institucion, m.nombre_institucion, m.sector_o_tipo_gestion, m.anho_cod_geo,
              m.maternal_hombre, m.maternal_mujer, m.prejardin_hombre, m.prejardin_mujer, m.jardin_hombre, m.jardin_mujer,
              m.preescolar_hombre, m.preescolar_mujer, m.total_matriculados_hombre, m.total_matriculados_mujer,
              m.inicial_noformal_hombre, m.inicial_noformal_mujer]            
          end
        end

        p.serialize("#{Rails.root}/public/data/#{nombre_archivo}.xlsx")

        #DESCARGA JSON
        File.open("#{Rails.root}/public/data/#{nombre_archivo}.json","w") do |f|
          f.write(matriculaciones_inicial.to_json)
        end

        #DESCARGA ZIP
        #zip_archivo(nombre_archivo, ['xlsx', 'csv', 'json'])


        ###
        ###MATRICULAS EDUCACION ESCOLAR BASICA###
        ###
        nombre_archivo = "matriculaciones_educacion_escolar_basica_#{year}"
        cond = "anio = #{year}"
        matriculaciones_educacion_escolar_basica = MatriculacionEducacionEscolarBasica.ordenado_institucion.where(cond)

        #DESCARGA CSV
        CSV.open("#{Rails.root}/public/data/#{nombre_archivo}.csv", "wb", {:force_quotes => true}) do |csv|
          # header row
          csv << ["anio", "codigo_establecimiento", "codigo_departamento", "nombre_departamento",
            "codigo_distrito", "nombre_distrito", "codigo_zona", "nombre_zona", "codigo_barrio_localidad", "nombre_barrio_localidad",
            "codigo_institucion", "nombre_institucion", "sector_o_tipo_gestion", "anho_cod_geo",
            "primer_grado_hombre", "primer_grado_mujer", "segundo_grado_hombre", "segundo_grado_mujer", "tercer_grado_hombre", "tercer_grado_mujer",
            "cuarto_grado_hombre", "cuarto_grado_mujer", "quinto_grado_hombre", "quinto_grado_mujer", "sexto_grado_hombre", "sexto_grado_mujer",
            "septimo_grado_hombre", "septimo_grado_mujer", "octavo_grado_hombre", "octavo_grado_mujer","noveno_grado_hombre", "noveno_grado_mujer",
            "total_matriculados_hombre", "total_matriculados_mujer"]

          # data rows
          matriculaciones_educacion_escolar_basica.each do |m|
            csv << [m.anio, m.codigo_establecimiento, m.codigo_departamento, m.nombre_departamento,
              m.codigo_distrito, m.nombre_distrito, m.codigo_zona, m.nombre_zona, m.codigo_barrio_localidad, m.nombre_barrio_localidad,
              m.codigo_institucion, m.nombre_institucion, m.sector_o_tipo_gestion, m.anho_cod_geo,
              m.primer_grado_hombre, m.primer_grado_mujer, m.segundo_grado_hombre, m.segundo_grado_mujer, m.tercer_grado_hombre, m.tercer_grado_mujer,
              m.cuarto_grado_hombre, m.cuarto_grado_mujer, m.quinto_grado_hombre, m.quinto_grado_mujer, m.sexto_grado_hombre, m.sexto_grado_mujer,
              m.septimo_grado_hombre, m.septimo_grado_mujer, m.octavo_grado_hombre, m.octavo_grado_mujer, m.noveno_grado_hombre, m.noveno_grado_mujer,
              m.total_matriculados_hombre, m.total_matriculados_mujer ]
          end      
        end

        #DESCARGA XLS
        p = Axlsx::Package.new
        p.workbook.add_worksheet(:name => "Matriculaciones EEB") do |sheet|         
          sheet.add_row [:anio, :codigo_establecimiento, :codigo_departamento, :nombre_departamento,
            :codigo_distrito, :nombre_distrito, :codigo_zona, :nombre_zona, :codigo_barrio_localidad, :nombre_barrio_localidad,
            :codigo_institucion, :nombre_institucion, :sector_o_tipo_gestion, :anho_cod_geo,
            :primer_grado_hombre, :primer_grado_mujer, :segundo_grado_hombre, :segundo_grado_mujer, :tercer_grado_hombre, :tercer_grado_mujer,
            :cuarto_grado_hombre, :cuarto_grado_mujer, :quinto_grado_hombre, :quinto_grado_mujer, :sexto_grado_hombre, :sexto_grado_mujer,
            :septimo_grado_hombre, :septimo_grado_mujer, :octavo_grado_hombre, :octavo_grado_mujer, :noveno_grado_hombre, :noveno_grado_mujer,
            :total_matriculados_hombre, :total_matriculados_mujer] 
            
          matriculaciones_educacion_escolar_basica.each do |m|             
            sheet.add_row [m.anio, m.codigo_establecimiento, m.codigo_departamento, m.nombre_departamento,
              m.codigo_distrito, m.nombre_distrito, m.codigo_zona, m.nombre_zona, m.codigo_barrio_localidad, m.nombre_barrio_localidad,
              m.codigo_institucion, m.nombre_institucion, m.sector_o_tipo_gestion, m.anho_cod_geo,
              m.primer_grado_hombre, m.primer_grado_mujer, m.segundo_grado_hombre, m.segundo_grado_mujer, m.tercer_grado_hombre, m.tercer_grado_mujer,
              m.cuarto_grado_hombre, m.cuarto_grado_mujer, m.quinto_grado_hombre, m.quinto_grado_mujer, m.sexto_grado_hombre, m.sexto_grado_mujer,
              m.septimo_grado_hombre, m.septimo_grado_mujer, m.octavo_grado_hombre, m.octavo_grado_mujer, m.noveno_grado_hombre, m.noveno_grado_mujer,
              m.total_matriculados_hombre, m.total_matriculados_mujer ]          
          end
        end

        p.serialize("#{Rails.root}/public/data/#{nombre_archivo}.xlsx")

        #DESCARGA JSON
        File.open("#{Rails.root}/public/data/#{nombre_archivo}.json","w") do |f|
          f.write(matriculaciones_educacion_escolar_basica.to_json)
        end

        #DESCARGA ZIP
        #zip_archivo(nombre_archivo, ['xlsx', 'csv', 'json'])


        ###
        ###MATRICULAS EDUCACION MEDIA###
        ###
        nombre_archivo = "matriculaciones_educacion_media_#{year}"
        cond = "anio = #{year}"
        matriculaciones_educacion_media = MatriculacionEducacionMedia.ordenado_institucion.where(cond)

        #DESCARGA CSV
        CSV.open("#{Rails.root}/public/data/#{nombre_archivo}.csv", "wb", {:force_quotes => true}) do |csv|
          # header row
          csv << ["anio", "codigo_establecimiento", "codigo_departamento", "nombre_departamento",
            "codigo_distrito", "nombre_distrito", "codigo_zona", "nombre_zona", "codigo_barrio_localidad", "nombre_barrio_localidad",
            "codigo_institucion", "nombre_institucion", "sector_o_tipo_gestion", "anho_cod_geo",
            "matricula_cientifico_hombre", "matricula_cientifico_mujer", "matricula_tecnico_hombre", "matricula_tecnico_mujer",
            "matricula_media_abierta_hombre", "matricula_media_abierta_mujer", "matricula_formacion_profesional_media_hombre", "matricula_formacion_profesional_media_mujer"]

          # data rows
          matriculaciones_educacion_media.each do |m|
            csv << [m.anio, m.codigo_establecimiento, m.codigo_departamento, m.nombre_departamento,
              m.codigo_distrito, m.nombre_distrito, m.codigo_zona, m.nombre_zona, m.codigo_barrio_localidad, m.nombre_barrio_localidad,
              m.codigo_institucion, m.nombre_institucion, m.sector_o_tipo_gestion, m.anho_cod_geo,
              m.matricula_cientifico_hombre, m.matricula_cientifico_mujer, m.matricula_tecnico_hombre, m.matricula_tecnico_mujer,
              m.matricula_media_abierta_hombre, m.matricula_media_abierta_mujer, m.matricula_formacion_profesional_media_hombre, m.matricula_formacion_profesional_media_mujer]
          end      
        end

        #DESCARGA XLS
        p = Axlsx::Package.new    
        p.workbook.add_worksheet(:name => "Matriculaciones EEM") do |sheet|        
          sheet.add_row [:anio, :codigo_establecimiento, :codigo_departamento, :nombre_departamento,
            :codigo_distrito, :nombre_distrito, :codigo_zona, :nombre_zona, :codigo_barrio_localidad, :nombre_barrio_localidad,
            :codigo_institucion, :nombre_institucion, :sector_o_tipo_gestion, :anho_cod_geo,
            :matricula_cientifico_hombre, :matricula_cientifico_mujer, :matricula_tecnico_hombre, :matricula_tecnico_mujer,
            :matricula_media_abierta_hombre, :matricula_media_abierta_mujer, :matricula_formacion_profesional_media_hombre, :matricula_formacion_profesional_media_mujer] 
            
          matriculaciones_educacion_media.each do |m|              
            sheet.add_row [m.anio, m.codigo_establecimiento, m.codigo_departamento, m.nombre_departamento,
              m.codigo_distrito, m.nombre_distrito, m.codigo_zona, m.nombre_zona, m.codigo_barrio_localidad, m.nombre_barrio_localidad,
              m.codigo_institucion, m.nombre_institucion, m.sector_o_tipo_gestion, m.anho_cod_geo,
              m.matricula_cientifico_hombre, m.matricula_cientifico_mujer, m.matricula_tecnico_hombre, m.matricula_tecnico_mujer,
              m.matricula_media_abierta_hombre, m.matricula_media_abierta_mujer, m.matricula_formacion_profesional_media_hombre, m.matricula_formacion_profesional_media_mujer]      
          end
        end

        p.serialize("#{Rails.root}/public/data/#{nombre_archivo}.xlsx")

        #DESCARGA JSON
        File.open("#{Rails.root}/public/data/#{nombre_archivo}.json","w") do |f|
          f.write(matriculaciones_educacion_media.to_json)
        end

        #DESCARGA ZIP
        #zip_archivo(nombre_archivo, ['xlsx', 'csv', 'json'])


        ###
        ###MATRICULAS EDUCACION INCLUSIVA###
        ###
        nombre_archivo = "matriculaciones_educacion_inclusiva_#{year}"
        cond = "anio = #{year}"
        matriculaciones_educacion_inclusiva = MatriculacionEducacionInclusiva.ordenado_institucion.where(cond)

        #DESCARGA CSV
        CSV.open("#{Rails.root}/public/data/#{nombre_archivo}.csv", "wb", {:force_quotes => true}) do |csv|
          # header row
          csv << ["anio", "codigo_establecimiento", "codigo_departamento", "nombre_departamento",
            "codigo_distrito", "nombre_distrito", "codigo_zona", "nombre_zona", "codigo_barrio_localidad", "nombre_barrio_localidad",
            "codigo_institucion", "nombre_institucion", "sector_o_tipo_gestion", "anho_cod_geo",
            "matricula_inicial_especial_hombre", "matricula_inicial_especial_mujer", "matricula_primer_y_segundo_ciclo_especial_hombre", "matricula_primer_y_segundo_ciclo_especial_mujer",
            "matricula_tercer_ciclo_especial_hombre", "matricula_tercer_ciclo_especial_mujer", "matricula_programas_especiales_hombre", "matricula_programas_especiales_mujer"]

          # data rows
          matriculaciones_educacion_inclusiva.each do |m|
            csv << [m.anio, m.codigo_establecimiento, m.codigo_departamento, m.nombre_departamento,
              m.codigo_distrito, m.nombre_distrito, m.codigo_zona, m.nombre_zona, m.codigo_barrio_localidad, m.nombre_barrio_localidad,
              m.codigo_institucion, m.nombre_institucion, m.sector_o_tipo_gestion, m.anho_cod_geo,
              m.matricula_inicial_especial_hombre, m.matricula_inicial_especial_mujer, m.matricula_primer_y_segundo_ciclo_especial_hombre, m.matricula_primer_y_segundo_ciclo_especial_mujer,
              m.matricula_tercer_ciclo_especial_hombre, m.matricula_tercer_ciclo_especial_mujer, m.matricula_programas_especiales_hombre, m.matricula_programas_especiales_mujer]
          end      
        end

        #DESCARGA XLS
        p = Axlsx::Package.new      
        p.workbook.add_worksheet(:name => "Matriculaciones EI") do |sheet|          
          sheet.add_row [:anio, :codigo_establecimiento, :codigo_departamento, :nombre_departamento,
            :codigo_distrito, :nombre_distrito, :codigo_zona, :nombre_zona, :codigo_barrio_localidad, :nombre_barrio_localidad,
            :codigo_institucion, :nombre_institucion, :sector_o_tipo_gestion, :anho_cod_geo,
            :matricula_inicial_especial_hombre, :matricula_inicial_especial_mujer, :matricula_primer_y_segundo_ciclo_especial_hombre, :matricula_primer_y_segundo_ciclo_especial_mujer,
            :matricula_tercer_ciclo_especial_hombre, :matricula_tercer_ciclo_especial_mujer, :matricula_programas_especiales_hombre, :matricula_programas_especiales_mujer] 
            
          matriculaciones_educacion_inclusiva.each do |m|             
            sheet.add_row [m.anio, m.codigo_establecimiento, m.codigo_departamento, m.nombre_departamento,
              m.codigo_distrito, m.nombre_distrito, m.codigo_zona, m.nombre_zona, m.codigo_barrio_localidad, m.nombre_barrio_localidad,
              m.codigo_institucion, m.nombre_institucion, m.sector_o_tipo_gestion, m.anho_cod_geo,
              m.matricula_inicial_especial_hombre, m.matricula_inicial_especial_mujer, m.matricula_primer_y_segundo_ciclo_especial_hombre, m.matricula_primer_y_segundo_ciclo_especial_mujer,
              m.matricula_tercer_ciclo_especial_hombre, m.matricula_tercer_ciclo_especial_mujer, m.matricula_programas_especiales_hombre, m.matricula_programas_especiales_mujer]           
          end
        end

        p.serialize("#{Rails.root}/public/data/#{nombre_archivo}.xlsx")

        #DESCARGA JSON
        File.open("#{Rails.root}/public/data/#{nombre_archivo}.json","w") do |f|
          f.write(matriculaciones_educacion_inclusiva.to_json)
        end

        #DESCARGA ZIP
        #zip_archivo(nombre_archivo, ['xlsx', 'csv', 'json'])


        ###
        ###MATRICULAS EDUCACION PERMANENTE###
        ###
        nombre_archivo = "matriculaciones_educacion_permanente_#{year}"
        cond = "anio = #{year}"
        matriculaciones_educacion_permanente = MatriculacionEducacionPermanente.ordenado_institucion.where(cond)

        #DESCARGA CSV
        CSV.open("#{Rails.root}/public/data/#{nombre_archivo}.csv", "wb", {:force_quotes => true}) do |csv|
          # header row
          csv << ["anio", "codigo_establecimiento", "codigo_departamento", "nombre_departamento",
            "codigo_distrito", "nombre_distrito", "codigo_zona", "nombre_zona", "codigo_barrio_localidad", "nombre_barrio_localidad",
            "codigo_institucion", "nombre_institucion", "sector_o_tipo_gestion", "anho_cod_geo",
            "matricula_ebbja_hombre", "matricula_ebbja_mujer", "matricula_fpi_hombre", "matricula_fpi_mujer",
            "matricula_emapja_hombre", "matricula_emapja_mujer", "matricula_emdja_hombre", "matricula_emdja_mujer",
            "matricula_fp_hombre", "matricula_fp_mujer"]

          # data rows
          matriculaciones_educacion_permanente.each do |m|
            csv << [m.anio, m.codigo_establecimiento, m.codigo_departamento, m.nombre_departamento,
              m.codigo_distrito, m.nombre_distrito, m.codigo_zona, m.nombre_zona, m.codigo_barrio_localidad, m.nombre_barrio_localidad,
              m.codigo_institucion, m.nombre_institucion, m.sector_o_tipo_gestion, m.anho_cod_geo,
              m.matricula_ebbja_hombre, m.matricula_ebbja_mujer, m.matricula_fpi_hombre, m.matricula_fpi_mujer,
              m.matricula_emapja_hombre, m.matricula_emapja_mujer, m.matricula_emdja_hombre, m.matricula_emdja_mujer,
              m.matricula_fp_hombre, m.matricula_fp_mujer]
          end      
        end

        #DESCARGA XLS
        p = Axlsx::Package.new     
        p.workbook.add_worksheet(:name => "Matriculaciones EP") do |sheet|       
          sheet.add_row [:anio, :codigo_establecimiento, :codigo_departamento, :nombre_departamento,
            :codigo_distrito, :nombre_distrito, :codigo_zona, :nombre_zona, :codigo_barrio_localidad, :nombre_barrio_localidad,
            :codigo_institucion, :nombre_institucion, :sector_o_tipo_gestion, :anho_cod_geo,
            :matricula_ebbja_hombre, :matricula_ebbja_mujer, :matricula_fpi_hombre, :matricula_fpi_mujer,
            :matricula_emapja_hombre, :matricula_emapja_mujer, :matricula_emdja_hombre, :matricula_emdja_mujer,
            :matricula_fp_hombre, :matricula_fp_mujer]
            
          matriculaciones_educacion_permanente.each do |m|          
            sheet.add_row [m.anio, m.codigo_establecimiento, m.codigo_departamento, m.nombre_departamento,
              m.codigo_distrito, m.nombre_distrito, m.codigo_zona, m.nombre_zona, m.codigo_barrio_localidad, m.nombre_barrio_localidad,
              m.codigo_institucion, m.nombre_institucion, m.sector_o_tipo_gestion, m.anho_cod_geo,
              m.matricula_ebbja_hombre, m.matricula_ebbja_mujer, m.matricula_fpi_hombre, m.matricula_fpi_mujer,
              m.matricula_emapja_hombre, m.matricula_emapja_mujer, m.matricula_emdja_hombre, m.matricula_emdja_mujer,
              m.matricula_fp_hombre, m.matricula_fp_mujer]            
          end
        end

        p.serialize("#{Rails.root}/public/data/#{nombre_archivo}.xlsx")

        #DESCARGA JSON
        File.open("#{Rails.root}/public/data/#{nombre_archivo}.json","w") do |f|
          f.write(matriculaciones_educacion_permanente.to_json)
        end

        #DESCARGA ZIP
        #zip_archivo(nombre_archivo, ['xlsx', 'csv', 'json'])


        ###
        ###MATRICULAS EDUCACION SUPERIOR###
        ###
        nombre_archivo = "matriculaciones_educacion_superior_#{year}"
        cond = "anio = #{year}"
        matriculaciones_educacion_superior = MatriculacionEducacionSuperior.ordenado_institucion.where(cond)

        #DESCARGA CSV
        CSV.open("#{Rails.root}/public/data/#{nombre_archivo}.csv", "wb", {:force_quotes => true}) do |csv|
          # header row
          csv << ["anio", "codigo_establecimiento", "codigo_departamento", "nombre_departamento",
            "codigo_distrito", "nombre_distrito", "codigo_zona", "nombre_zona", "codigo_barrio_localidad", "nombre_barrio_localidad",
            "codigo_institucion", "nombre_institucion", "sector_o_tipo_gestion", "anho_cod_geo",
            "matricula_ets_hombre", "matricula_ets_mujer", "matricula_fed_hombre", "matricula_fed_mujer",
            "matricula_fdes_hombre", "matricula_fdes_mujer", "matricula_pd_hombre", "matricula_pd_mujer"]

          # data rows
          matriculaciones_educacion_superior.each do |m|
            csv << [m.anio, m.codigo_establecimiento, m.codigo_departamento, m.nombre_departamento,
              m.codigo_distrito, m.nombre_distrito, m.codigo_zona, m.nombre_zona, m.codigo_barrio_localidad, m.nombre_barrio_localidad,
              m.codigo_institucion, m.nombre_institucion, m.sector_o_tipo_gestion, m.anho_cod_geo,
              m.matricula_ets_hombre, m.matricula_ets_mujer, m.matricula_fed_hombre, m.matricula_fed_mujer,
              m.matricula_fdes_hombre, m.matricula_fdes_mujer, m.matricula_pd_hombre, m.matricula_pd_mujer]
          end      
        end

        #DESCARGA XLS
        p = Axlsx::Package.new     
        p.workbook.add_worksheet(:name => "Matriculaciones ES") do |sheet|         
          sheet.add_row [:anio, :codigo_establecimiento, :codigo_departamento, :nombre_departamento,
            :codigo_distrito, :nombre_distrito, :codigo_zona, :nombre_zona, :codigo_barrio_localidad, :nombre_barrio_localidad,
            :codigo_institucion, :nombre_institucion, :sector_o_tipo_gestion, :anho_cod_geo,
            :matricula_ets_hombre, :matricula_ets_mujer, :matricula_fed_hombre, :matricula_fed_mujer,
            :matricula_fdes_hombre, :matricula_fdes_mujer, :matricula_pd_hombre, :matricula_pd_mujer]
            
          matriculaciones_educacion_superior.each do |m|             
            sheet.add_row [m.anio, m.codigo_establecimiento, m.codigo_departamento, m.nombre_departamento,
              m.codigo_distrito, m.nombre_distrito, m.codigo_zona, m.nombre_zona, m.codigo_barrio_localidad, m.nombre_barrio_localidad,
              m.codigo_institucion, m.nombre_institucion, m.sector_o_tipo_gestion, m.anho_cod_geo,
              m.matricula_ets_hombre, m.matricula_ets_mujer, m.matricula_fed_hombre, m.matricula_fed_mujer,
              m.matricula_fdes_hombre, m.matricula_fdes_mujer, m.matricula_pd_hombre, m.matricula_pd_mujer]           
          end
        end

        p.serialize("#{Rails.root}/public/data/#{nombre_archivo}.xlsx")

        #DESCARGA JSON
        File.open("#{Rails.root}/public/data/#{nombre_archivo}.json","w") do |f|
          f.write(matriculaciones_educacion_superior.to_json)
        end

        #DESCARGA ZIP
        #zip_archivo(nombre_archivo, ['xlsx', 'csv', 'json'])


        ###
        ###MATRICULAS DEPARTAMENTOS Y DISTRITOS###
        ###
        nombre_archivo = "matriculaciones_departamentos_distritos_#{year}"
        cond = "anio = #{year}"
        matriculaciones_departamentos_distritos = MatriculacionDepartamentoDistrito.orden_dep_dis.where(cond)

        #DESCARGA CSV
        CSV.open("#{Rails.root}/public/data/#{nombre_archivo}.csv", "wb", {:force_quotes => true}) do |csv|
          # header row
          csv << ["anio", "codigo_departamento", "nombre_departamento",
            "codigo_distrito", "nombre_distrito", "codigo_zona", "nombre_zona",
            "sector_o_tipo_gestion", "anho_cod_geo",
            "cantidad_matriculados_hombre", "cantidad_matriculados_mujer"]

          # data rows
          matriculaciones_departamentos_distritos.each do |m|
            csv << [m.anio, m.codigo_departamento, m.nombre_departamento,
              m.codigo_distrito, m.nombre_distrito, m.codigo_zona, m.nombre_zona,
              m.sector_o_tipo_gestion, m.anho_cod_geo,
              m.cantidad_matriculados_hombre, m.cantidad_matriculados_mujer]
          end      
         end

        #DESCARGA XLS
        p = Axlsx::Package.new     
        p.workbook.add_worksheet(:name => "Matriculaciones EDD") do |sheet|          
          sheet.add_row [:anio, :codigo_departamento, :nombre_departamento,
            :codigo_distrito, :nombre_distrito, :codigo_zona, :nombre_zona,
            :sector_o_tipo_gestion, :anho_cod_geo,
            :cantidad_matriculados_hombre, :cantidad_matriculados_mujer]
            
          matriculaciones_departamentos_distritos.each do |m|              
            sheet.add_row [m.anio, m.codigo_departamento, m.nombre_departamento,
              m.codigo_distrito, m.nombre_distrito, m.codigo_zona, m.nombre_zona,
              m.sector_o_tipo_gestion, m.anho_cod_geo,
              m.cantidad_matriculados_hombre, m.cantidad_matriculados_mujer]
          end
        end

        p.serialize("#{Rails.root}/public/data/#{nombre_archivo}.xlsx")

        #DESCARGA JSON
        File.open("#{Rails.root}/public/data/#{nombre_archivo}.json","w") do |f|
          f.write(matriculaciones_departamentos_distritos.to_json)
        end

        #DESCARGA ZIP
        #zip_archivo(nombre_archivo, ['xlsx', 'csv', 'json'])

    end #end for

  end #end function "descargas_matriculas"


  def descargas_contrataciones

    ###
    ###CONTRATACIONES###
    ###
    nombre_archivo = "contrataciones"
    cond = ""
    contrataciones = Contratacion.ordenado.where(cond)

    #DESCARGA CSV
    CSV.open("#{Rails.root}/public/data/#{nombre_archivo}.csv", "wb", {:force_quotes => true}) do |csv|
      # header row
      csv << ["llamado_publico", "estado_llamado_id", "estado_llamado", "ejercicio_fiscal", "categoria_id", "categoria", "nombre", "descripcion", "fecha_apertura_oferta", "fecha_contrato", "fecha_vigencia_contrato", "proveedor_id", "proveedor_ruc", "proveedor", "modalidad_id", "modalidad", "monto_adjudicado"]

      # data rows
      contrataciones.each do |c|
        csv << [ c.llamado_publico, c.estado_llamado_id, c.estado_llamado, c.ejercicio_fiscal, c.categoria_id, c.categoria, c.nombre, c.descripcion, c.fecha_apertura_oferta, c.fecha_contrato,c.fecha_vigencia_contrato, c.proveedor_id, c.proveedor_ruc, c.proveedor, c.modalidad_id, c.modalidad, c.monto_adjudicado ]
      end      
     end

    #DESCARGA XLS
    p = Axlsx::Package.new     
    p.workbook.add_worksheet(:name => "Matriculaciones EDD") do |sheet|          
      sheet.add_row ["llamado_publico", "estado_llamado_id", "estado_llamado", "ejercicio_fiscal", "categoria_id", "categoria", "nombre", "descripcion", "fecha_apertura_oferta", "fecha_contrato", "fecha_vigencia_contrato", "proveedor_id", "proveedor_ruc", "proveedor", "modalidad_id", "modalidad", "monto_adjudicado"]
        
      contrataciones.each do |c|              
        sheet.add_row [ c.llamado_publico, c.estado_llamado_id, c.estado_llamado, c.ejercicio_fiscal, c.categoria_id, c.categoria, c.nombre, c.descripcion, c.fecha_apertura_oferta, c.fecha_contrato,c.fecha_vigencia_contrato, c.proveedor_id, c.proveedor_ruc, c.proveedor, c.modalidad_id, c.modalidad, c.monto_adjudicado ]
      end
    end

    p.serialize("#{Rails.root}/public/data/#{nombre_archivo}.xlsx")

    #DESCARGA JSON
    File.open("#{Rails.root}/public/data/#{nombre_archivo}.json","w") do |f|
      f.write(contrataciones.to_json)
    end

    #DESCARGA ZIP
    #zip_archivo(nombre_archivo, ['xlsx', 'csv', 'json'])

  end #end function "descargas_contrataciones"


  def descargas_registros_titulos

    ###
    ###REGISTROS TITULOS###
    ###
    nombre_archivo = "registros_titulos"
    cond = ""
    registros_titulos = RegistroTitulo.orden_anio_mes.where(cond)

    #DESCARGA CSV
    CSV.open("#{Rails.root}/public/data/#{nombre_archivo}.csv", "wb", {:force_quotes => true}) do |csv|
      # header row
      csv << ["anio", "mes", "documento", "nombre_completo", "carrera_id", "carrera", "titulo_id", "titulo", "numero_resolucion", "fecha_resolucion", "tipo_institucion_id", "tipo_institucion", "institucion_id","institucion", "gobierno_actual", "sexo" ]

      # data rows
      registros_titulos.each do |rt|
        csv << [rt.anio, rt.mes, rt.documento, rt.nombre_completo, rt.carrera_id, rt.carrera, rt.titulo_id, rt.titulo, rt.numero_resolucion, rt.fecha_resolucion, rt.tipo_institucion_id, rt.tipo_institucion, rt.institucion_id, rt.institucion, rt.gobierno_actual, rt.sexo ]
      end      
     end

    #DESCARGA XLS
    p = Axlsx::Package.new     
    p.workbook.add_worksheet(:name => "Matriculaciones EDD") do |sheet|          
      sheet.add_row ["anio", "mes", "documento", "nombre_completo", "carrera_id", "carrera", "titulo_id", "titulo", "numero_resolucion", "fecha_resolucion", "tipo_institucion_id", "tipo_institucion", "institucion_id","institucion", "gobierno_actual", "sexo" ]
        
      registros_titulos.each do |rt|              
        sheet.add_row [rt.anio, rt.mes, rt.documento, rt.nombre_completo, rt.carrera_id, rt.carrera, rt.titulo_id, rt.titulo, rt.numero_resolucion, rt.fecha_resolucion, rt.tipo_institucion_id, rt.tipo_institucion, rt.institucion_id, rt.institucion, rt.gobierno_actual, rt.sexo ]
      end
    end

    p.serialize("#{Rails.root}/public/data/#{nombre_archivo}.xlsx")

    #DESCARGA JSON
    File.open("#{Rails.root}/public/data/#{nombre_archivo}.json","w") do |f|
      f.write(registros_titulos.to_json)
    end

    #DESCARGA ZIP
    zip_archivo(nombre_archivo, ['xlsx', 'csv', 'json'])

  end #end function "descargas_registros_titulos"


  def descargas_nominas
     
    anios = Nomina.select(:ano_periodo_pago).distinct.order(ano_periodo_pago: :desc).limit(2)
    meses = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
    
    for year in anios

        year=year.ano_periodo_pago
        for month in meses

          ###
          ###NOMINA ADMINISTRATIVOS###
          ###
          nombre_archivo = "funcionarios_administrativos_#{year}_#{month}"
          cond = "n.ano_periodo_pago = #{year} and n.mes_periodo_pago = #{month} and n.es_categoria_administrativa = 1"
          query = 
          "
          SELECT
            n.ano_periodo_pago as anio,
            n.mes_periodo_pago as mes,
            n.codigo_trabajador as documento,
            n.nombre_trabajador as funcionario,
                CASE
                    WHEN n.numero_tipo_presupuesto_puesto = 1 THEN 'Permanente'::text
                    WHEN n.numero_tipo_presupuesto_puesto = 2 THEN 'Contratado'::text
                    WHEN n.numero_tipo_presupuesto_puesto = 5 THEN 'Comisionado'::text
                    WHEN n.numero_tipo_presupuesto_puesto = 3 THEN 'Ad-Honorem'::text
                    ELSE NULL::text
                END AS estado,
                ((n.anhos_antiguedad_administrativo || ' año/s y '::text) || n.meses_antiguedad_administrativo) || ' mes/es'::text AS antiguedad_administrativo,
                n.numero_matriculacion, 
                n.codigo_objeto_gasto,
                n.nombre_objeto_gasto as objeto_gasto,
                n.codigo_concepto_nomina as codigo_concepto,
                n.nombre_concepto_nomina as concepto,
                n.codigo_dependencia_efectiva as codigo_dependencia,
                n.nombre_dependencia_efectiva as dependencia,
                n.codigo_cargo_efectivo codigo_cargo,
                n.nombre_cargo_efectivo cargo,
                n.codigo_categoria_rubro,
                n.monto_categoria_rubro::int,
                n.cantidad::int,
                n.asignacion::int
          FROM
              nomina n
          where
              " + cond + "
          order by
              n.nombre_trabajador
          "
          nominas_administrativos = ActiveRecord::Base.connection.exec_query(query)

          #DESCARGA CSV
          CSV.open("#{Rails.root}/public/data/#{nombre_archivo}.csv", "wb", {:force_quotes => true}) do |csv|
            # header row
            csv << ["anio", "mes", "documento", "funcionario", "estado", "antiguedad_administrativo", "numero_matriculacion", "codigo_objeto_gasto", "objeto_gasto", "codigo_concepto", "concepto", "codigo_dependencia", "dependencia", "codigo_cargo", "cargo", "codigo_categoria_rubro", "monto_categoria_rubro", "cantidad", "asignacion", "sexo"]
     
            # data rows
            nominas_administrativos.each do |n|
              csv << [ n['anio'], n['mes'], n['documento'], n['funcionario'], n['estado'], n['antiguedad_administrativo'], n['numero_matriculacion'], n['codigo_objeto_gasto'], n['objeto_gasto'], n['codigo_concepto'], n['concepto'], n['codigo_dependencia'], n['dependencia'], n['codigo_cargo'], n['cargo'], n['codigo_categoria_rubro'], n['monto_categoria_rubro'], n['cantidad'], n['asignacion'], n['sexo'] ]
            end
          end

          #DESCARGA ZIP
          zip_archivo(nombre_archivo, ['csv'])


          ###
          ###NOMINA DOCENTES###
          ###
          nombre_archivo = "funcionarios_docentes_#{year}_#{month}"
          cond = "n.ano_periodo_pago = #{year} and n.mes_periodo_pago = #{month} and n.es_categoria_administrativa = 0"
          query = 
          "
          SELECT
            n.ano_periodo_pago as anio,
            n.mes_periodo_pago as mes,
            n.codigo_trabajador as documento,
            n.nombre_trabajador as funcionario,
                CASE
                    WHEN n.numero_tipo_presupuesto_puesto = 1 THEN 'Permanente'::text
                    WHEN n.numero_tipo_presupuesto_puesto = 2 THEN 'Contratado'::text
                    WHEN n.numero_tipo_presupuesto_puesto = 5 THEN 'Comisionado'::text
                    WHEN n.numero_tipo_presupuesto_puesto = 3 THEN 'Ad-Honorem'::text
                    ELSE NULL::text
                END AS estado,
                ((n.anhos_antiguedad_docente || ' año/s y '::text) || n.meses_antiguedad_docente) || ' mes/es'::text AS antiguedad_docente,
                n.numero_matriculacion, 
                n.codigo_objeto_gasto,
                n.nombre_objeto_gasto as objeto_gasto,
                n.codigo_concepto_nomina as codigo_concepto,
                n.nombre_concepto_nomina as concepto,
                n.codigo_dependencia_efectiva as codigo_institucion,
                n.nombre_dependencia_efectiva as institucion,
                n.codigo_cargo_efectivo codigo_cargo,
                n.nombre_cargo_efectivo cargo,
                n.codigo_categoria_rubro,
                n.monto_categoria_rubro::int,
                n.cantidad::int,
                n.asignacion::int
          FROM
              nomina n
          where
              " + cond + "
          order by
              n.nombre_trabajador
          "
          nominas_docentes = ActiveRecord::Base.connection.execute(query)

          #DESCARGA CSV
          CSV.open("#{Rails.root}/public/data/#{nombre_archivo}.csv", "wb", {:force_quotes => true}) do |csv|
            # header row
            csv << ["anio", "mes", "documento", "funcionario", "estado", "antiguedad_administrativo", "numero_matriculacion", "codigo_objeto_gasto", "objeto_gasto", "codigo_concepto", "concepto", "codigo_dependencia", "dependencia", "codigo_cargo", "cargo", "codigo_categoria_rubro", "monto_categoria_rubro", "cantidad", "asignacion", "sexo"]
     
            # data rows
            nominas_docentes.each do |n|
              csv << [ n['anio'], n['mes'], n['documento'], n['funcionario'], n['estado'], n['antiguedad_administrativo'], n['numero_matriculacion'], n['codigo_objeto_gasto'], n['objeto_gasto'], n['codigo_concepto'], n['concepto'], n['codigo_dependencia'], n['dependencia'], n['codigo_cargo'], n['cargo'], n['codigo_categoria_rubro'], n['monto_categoria_rubro'], n['cantidad'], n['asignacion'], n['sexo'] ]
            end
          end

          #DESCARGA ZIP
          zip_archivo(nombre_archivo, ['csv'])

        end

    end

  end #end function "descargas_nominas"

end #end class service

#Crear la carpeta geometrias en mec-opendata/app/assets/javascripts
#curl -X POST http://localhost:3000/app/service_actualizaciones_actualizacion_geometrias
#curl -X POST http://localhost:3000/app/service_actualizaciones_actualizacion_geometrias -u "mecpy:mecpy2015" > /tmp/crontab.log

#curl -X POST http://localhost:3000/app/service_actualizaciones_generar_csv_json -u "mecpy:mecpy2015" > /tmp/crontab.log


#INSTALACION DE NODE.JS EN CENTOS
#https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-a-centos-7-server
#npm install -g topojson