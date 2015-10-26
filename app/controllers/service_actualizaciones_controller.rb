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

    #descargas_matriculas();
    #descargas_contrataciones();
    #descargas_registros_titulos();
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
      Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
        zipfile.add(filename, folder + filename)
      end
      FileUtils.rm (folder + filename)
    end

  end

  def descargas_matriculas

    anios = [2013, 2012]
    for year in anios

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
            "maternal_varon", "maternal_mujer", "prejardin_varon", "prejardin_mujer", "jardin_varon", "jardin_mujer",
            "preescolar_varon", "preescolar_mujer", "total_matriculados_varon", "total_matriculados_mujer",
            "inicial_noformal_varon", "inicial_noformal_mujer"]

          # data rows
          matriculaciones_inicial.each do |m|
            csv << [m.anio, m.codigo_establecimiento, m.codigo_departamento, m.nombre_departamento,
              m.codigo_distrito, m.nombre_distrito, m.codigo_zona, m.nombre_zona, m.codigo_barrio_localidad, m.nombre_barrio_localidad,
              m.codigo_institucion, m.nombre_institucion, m.sector_o_tipo_gestion, m.anho_cod_geo,
              m.maternal_varon, m.maternal_mujer, m.prejardin_varon, m.prejardin_mujer, m.jardin_varon, m.jardin_mujer,
              m.preescolar_varon, m.preescolar_mujer, m.total_matriculados_varon, m.total_matriculados_mujer,
              m.inicial_noformal_varon, m.inicial_noformal_mujer]
          end      
        end

        #DESCARGA XLS
        p = Axlsx::Package.new      
        p.workbook.add_worksheet(:name => "Matriculaciones EI") do |sheet|          
          sheet.add_row [:anio, :codigo_establecimiento, :codigo_departamento, :nombre_departamento,
            :codigo_distrito, :nombre_distrito, :codigo_zona, :nombre_zona, :codigo_barrio_localidad, :nombre_barrio_localidad,
            :codigo_institucion, :nombre_institucion, :sector_o_tipo_gestion, :anho_cod_geo,
            :maternal_varon, :maternal_mujer, :prejardin_varon, :prejardin_mujer, :jardin_varon, :jardin_mujer,
            :preescolar_varon, :preescolar_mujer, :total_matriculados_varon, :total_matriculados_mujer,
            :inicial_noformal_varon, :inicial_noformal_mujer]
            
          matriculaciones_inicial.each do |m|              
            sheet.add_row [m.anio, m.codigo_establecimiento, m.codigo_departamento, m.nombre_departamento,
              m.codigo_distrito, m.nombre_distrito, m.codigo_zona, m.nombre_zona, m.codigo_barrio_localidad, m.nombre_barrio_localidad,
              m.codigo_institucion, m.nombre_institucion, m.sector_o_tipo_gestion, m.anho_cod_geo,
              m.maternal_varon, m.maternal_mujer, m.prejardin_varon, m.prejardin_mujer, m.jardin_varon, m.jardin_mujer,
              m.preescolar_varon, m.preescolar_mujer, m.total_matriculados_varon, m.total_matriculados_mujer,
              m.inicial_noformal_varon, m.inicial_noformal_mujer]            
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
            "primer_grado_varon", "primer_grado_mujer", "segundo_grado_varon", "segundo_grado_mujer", "tercer_grado_varon", "tercer_grado_mujer",
            "cuarto_grado_varon", "cuarto_grado_mujer", "quinto_grado_varon", "quinto_grado_mujer", "sexto_grado_varon", "sexto_grado_mujer",
            "septimo_grado_varon", "septimo_grado_mujer", "octavo_grado_varon", "octavo_grado_mujer","noveno_grado_varon", "noveno_grado_mujer",
            "total_matriculados_varon", "total_matriculados_mujer"]

          # data rows
          matriculaciones_educacion_escolar_basica.each do |m|
            csv << [m.anio, m.codigo_establecimiento, m.codigo_departamento, m.nombre_departamento,
              m.codigo_distrito, m.nombre_distrito, m.codigo_zona, m.nombre_zona, m.codigo_barrio_localidad, m.nombre_barrio_localidad,
              m.codigo_institucion, m.nombre_institucion, m.sector_o_tipo_gestion, m.anho_cod_geo,
              m.primer_grado_varon, m.primer_grado_mujer, m.segundo_grado_varon, m.segundo_grado_mujer, m.tercer_grado_varon, m.tercer_grado_mujer,
              m.cuarto_grado_varon, m.cuarto_grado_mujer, m.quinto_grado_varon, m.quinto_grado_mujer, m.sexto_grado_varon, m.sexto_grado_mujer,
              m.septimo_grado_varon, m.septimo_grado_mujer, m.octavo_grado_varon, m.octavo_grado_mujer, m.noveno_grado_varon, m.noveno_grado_mujer,
              m.total_matriculados_varon, m.total_matriculados_mujer ]
          end      
        end

        #DESCARGA XLS
        p = Axlsx::Package.new
        p.workbook.add_worksheet(:name => "Matriculaciones EEB") do |sheet|         
          sheet.add_row [:anio, :codigo_establecimiento, :codigo_departamento, :nombre_departamento,
            :codigo_distrito, :nombre_distrito, :codigo_zona, :nombre_zona, :codigo_barrio_localidad, :nombre_barrio_localidad,
            :codigo_institucion, :nombre_institucion, :sector_o_tipo_gestion, :anho_cod_geo,
            :primer_grado_varon, :primer_grado_mujer, :segundo_grado_varon, :segundo_grado_mujer, :tercer_grado_varon, :tercer_grado_mujer,
            :cuarto_grado_varon, :cuarto_grado_mujer, :quinto_grado_varon, :quinto_grado_mujer, :sexto_grado_varon, :sexto_grado_mujer,
            :septimo_grado_varon, :septimo_grado_mujer, :octavo_grado_varon, :octavo_grado_mujer, :noveno_grado_varon, :noveno_grado_mujer,
            :total_matriculados_varon, :total_matriculados_mujer] 
            
          matriculaciones_educacion_escolar_basica.each do |m|             
            sheet.add_row [m.anio, m.codigo_establecimiento, m.codigo_departamento, m.nombre_departamento,
              m.codigo_distrito, m.nombre_distrito, m.codigo_zona, m.nombre_zona, m.codigo_barrio_localidad, m.nombre_barrio_localidad,
              m.codigo_institucion, m.nombre_institucion, m.sector_o_tipo_gestion, m.anho_cod_geo,
              m.primer_grado_varon, m.primer_grado_mujer, m.segundo_grado_varon, m.segundo_grado_mujer, m.tercer_grado_varon, m.tercer_grado_mujer,
              m.cuarto_grado_varon, m.cuarto_grado_mujer, m.quinto_grado_varon, m.quinto_grado_mujer, m.sexto_grado_varon, m.sexto_grado_mujer,
              m.septimo_grado_varon, m.septimo_grado_mujer, m.octavo_grado_varon, m.octavo_grado_mujer, m.noveno_grado_varon, m.noveno_grado_mujer,
              m.total_matriculados_varon, m.total_matriculados_mujer ]          
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
            "matricula_cientifico_varon", "matricula_cientifico_mujer", "matricula_tecnico_varon", "matricula_tecnico_mujer",
            "matricula_media_abierta_varon", "matricula_media_abierta_mujer", "matricula_formacion_profesional_media_varon", "matricula_formacion_profesional_media_mujer"]

          # data rows
          matriculaciones_educacion_media.each do |m|
            csv << [m.anio, m.codigo_establecimiento, m.codigo_departamento, m.nombre_departamento,
              m.codigo_distrito, m.nombre_distrito, m.codigo_zona, m.nombre_zona, m.codigo_barrio_localidad, m.nombre_barrio_localidad,
              m.codigo_institucion, m.nombre_institucion, m.sector_o_tipo_gestion, m.anho_cod_geo,
              m.matricula_cientifico_varon, m.matricula_cientifico_mujer, m.matricula_tecnico_varon, m.matricula_tecnico_mujer,
              m.matricula_media_abierta_varon, m.matricula_media_abierta_mujer, m.matricula_formacion_profesional_media_varon, m.matricula_formacion_profesional_media_mujer]
          end      
        end

        #DESCARGA XLS
        p = Axlsx::Package.new    
        p.workbook.add_worksheet(:name => "Matriculaciones EEM") do |sheet|        
          sheet.add_row [:anio, :codigo_establecimiento, :codigo_departamento, :nombre_departamento,
            :codigo_distrito, :nombre_distrito, :codigo_zona, :nombre_zona, :codigo_barrio_localidad, :nombre_barrio_localidad,
            :codigo_institucion, :nombre_institucion, :sector_o_tipo_gestion, :anho_cod_geo,
            :matricula_cientifico_varon, :matricula_cientifico_mujer, :matricula_tecnico_varon, :matricula_tecnico_mujer,
            :matricula_media_abierta_varon, :matricula_media_abierta_mujer, :matricula_formacion_profesional_media_varon, :matricula_formacion_profesional_media_mujer] 
            
          matriculaciones_educacion_media.each do |m|              
            sheet.add_row [m.anio, m.codigo_establecimiento, m.codigo_departamento, m.nombre_departamento,
              m.codigo_distrito, m.nombre_distrito, m.codigo_zona, m.nombre_zona, m.codigo_barrio_localidad, m.nombre_barrio_localidad,
              m.codigo_institucion, m.nombre_institucion, m.sector_o_tipo_gestion, m.anho_cod_geo,
              m.matricula_cientifico_varon, m.matricula_cientifico_mujer, m.matricula_tecnico_varon, m.matricula_tecnico_mujer,
              m.matricula_media_abierta_varon, m.matricula_media_abierta_mujer, m.matricula_formacion_profesional_media_varon, m.matricula_formacion_profesional_media_mujer]      
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
            "matricula_inicial_especial_varon", "matricula_inicial_especial_mujer", "matricula_primer_y_segundo_ciclo_especial_varon", "matricula_primer_y_segundo_ciclo_especial_mujer",
            "matricula_tercer_ciclo_especial_varon", "matricula_tercer_ciclo_especial_mujer", "matricula_programas_especiales_varon", "matricula_programas_especiales_mujer"]

          # data rows
          matriculaciones_educacion_inclusiva.each do |m|
            csv << [m.anio, m.codigo_establecimiento, m.codigo_departamento, m.nombre_departamento,
              m.codigo_distrito, m.nombre_distrito, m.codigo_zona, m.nombre_zona, m.codigo_barrio_localidad, m.nombre_barrio_localidad,
              m.codigo_institucion, m.nombre_institucion, m.sector_o_tipo_gestion, m.anho_cod_geo,
              m.matricula_inicial_especial_varon, m.matricula_inicial_especial_mujer, m.matricula_primer_y_segundo_ciclo_especial_varon, m.matricula_primer_y_segundo_ciclo_especial_mujer,
              m.matricula_tercer_ciclo_especial_varon, m.matricula_tercer_ciclo_especial_mujer, m.matricula_programas_especiales_varon, m.matricula_programas_especiales_mujer]
          end      
        end

        #DESCARGA XLS
        p = Axlsx::Package.new      
        p.workbook.add_worksheet(:name => "Matriculaciones EI") do |sheet|          
          sheet.add_row [:anio, :codigo_establecimiento, :codigo_departamento, :nombre_departamento,
            :codigo_distrito, :nombre_distrito, :codigo_zona, :nombre_zona, :codigo_barrio_localidad, :nombre_barrio_localidad,
            :codigo_institucion, :nombre_institucion, :sector_o_tipo_gestion, :anho_cod_geo,
            :matricula_inicial_especial_varon, :matricula_inicial_especial_mujer, :matricula_primer_y_segundo_ciclo_especial_varon, :matricula_primer_y_segundo_ciclo_especial_mujer,
            :matricula_tercer_ciclo_especial_varon, :matricula_tercer_ciclo_especial_mujer, :matricula_programas_especiales_varon, :matricula_programas_especiales_mujer] 
            
          matriculaciones_educacion_inclusiva.each do |m|             
            sheet.add_row [m.anio, m.codigo_establecimiento, m.codigo_departamento, m.nombre_departamento,
              m.codigo_distrito, m.nombre_distrito, m.codigo_zona, m.nombre_zona, m.codigo_barrio_localidad, m.nombre_barrio_localidad,
              m.codigo_institucion, m.nombre_institucion, m.sector_o_tipo_gestion, m.anho_cod_geo,
              m.matricula_inicial_especial_varon, m.matricula_inicial_especial_mujer, m.matricula_primer_y_segundo_ciclo_especial_varon, m.matricula_primer_y_segundo_ciclo_especial_mujer,
              m.matricula_tercer_ciclo_especial_varon, m.matricula_tercer_ciclo_especial_mujer, m.matricula_programas_especiales_varon, m.matricula_programas_especiales_mujer]           
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
            "matricula_ebbja_varon", "matricula_ebbja_mujer", "matricula_fpi_varon", "matricula_fpi_mujer",
            "matricula_emapja_varon", "matricula_emapja_mujer", "matricula_emdja_varon", "matricula_emdja_mujer",
            "matricula_fp_varon", "matricula_fp_mujer"]

          # data rows
          matriculaciones_educacion_permanente.each do |m|
            csv << [m.anio, m.codigo_establecimiento, m.codigo_departamento, m.nombre_departamento,
              m.codigo_distrito, m.nombre_distrito, m.codigo_zona, m.nombre_zona, m.codigo_barrio_localidad, m.nombre_barrio_localidad,
              m.codigo_institucion, m.nombre_institucion, m.sector_o_tipo_gestion, m.anho_cod_geo,
              m.matricula_ebbja_varon, m.matricula_ebbja_mujer, m.matricula_fpi_varon, m.matricula_fpi_mujer,
              m.matricula_emapja_varon, m.matricula_emapja_mujer, m.matricula_emdja_varon, m.matricula_emdja_mujer,
              m.matricula_fp_varon, m.matricula_fp_mujer]
          end      
        end

        #DESCARGA XLS
        p = Axlsx::Package.new     
        p.workbook.add_worksheet(:name => "Matriculaciones EP") do |sheet|       
          sheet.add_row [:anio, :codigo_establecimiento, :codigo_departamento, :nombre_departamento,
            :codigo_distrito, :nombre_distrito, :codigo_zona, :nombre_zona, :codigo_barrio_localidad, :nombre_barrio_localidad,
            :codigo_institucion, :nombre_institucion, :sector_o_tipo_gestion, :anho_cod_geo,
            :matricula_ebbja_varon, :matricula_ebbja_mujer, :matricula_fpi_varon, :matricula_fpi_mujer,
            :matricula_emapja_varon, :matricula_emapja_mujer, :matricula_emdja_varon, :matricula_emdja_mujer,
            :matricula_fp_varon, :matricula_fp_mujer]
            
          matriculaciones_educacion_permanente.each do |m|          
            sheet.add_row [m.anio, m.codigo_establecimiento, m.codigo_departamento, m.nombre_departamento,
              m.codigo_distrito, m.nombre_distrito, m.codigo_zona, m.nombre_zona, m.codigo_barrio_localidad, m.nombre_barrio_localidad,
              m.codigo_institucion, m.nombre_institucion, m.sector_o_tipo_gestion, m.anho_cod_geo,
              m.matricula_ebbja_varon, m.matricula_ebbja_mujer, m.matricula_fpi_varon, m.matricula_fpi_mujer,
              m.matricula_emapja_varon, m.matricula_emapja_mujer, m.matricula_emdja_varon, m.matricula_emdja_mujer,
              m.matricula_fp_varon, m.matricula_fp_mujer]            
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
            "matricula_ets_varon", "matricula_ets_mujer", "matricula_fed_varon", "matricula_fed_mujer",
            "matricula_fdes_varon", "matricula_fdes_mujer", "matricula_pd_varon", "matricula_pd_mujer"]

          # data rows
          matriculaciones_educacion_superior.each do |m|
            csv << [m.anio, m.codigo_establecimiento, m.codigo_departamento, m.nombre_departamento,
              m.codigo_distrito, m.nombre_distrito, m.codigo_zona, m.nombre_zona, m.codigo_barrio_localidad, m.nombre_barrio_localidad,
              m.codigo_institucion, m.nombre_institucion, m.sector_o_tipo_gestion, m.anho_cod_geo,
              m.matricula_ets_varon, m.matricula_ets_mujer, m.matricula_fed_varon, m.matricula_fed_mujer,
              m.matricula_fdes_varon, m.matricula_fdes_mujer, m.matricula_pd_varon, m.matricula_pd_mujer]
          end      
        end

        #DESCARGA XLS
        p = Axlsx::Package.new     
        p.workbook.add_worksheet(:name => "Matriculaciones ES") do |sheet|         
          sheet.add_row [:anio, :codigo_establecimiento, :codigo_departamento, :nombre_departamento,
            :codigo_distrito, :nombre_distrito, :codigo_zona, :nombre_zona, :codigo_barrio_localidad, :nombre_barrio_localidad,
            :codigo_institucion, :nombre_institucion, :sector_o_tipo_gestion, :anho_cod_geo,
            :matricula_ets_varon, :matricula_ets_mujer, :matricula_fed_varon, :matricula_fed_mujer,
            :matricula_fdes_varon, :matricula_fdes_mujer, :matricula_pd_varon, :matricula_pd_mujer]
            
          matriculaciones_educacion_superior.each do |m|             
            sheet.add_row [m.anio, m.codigo_establecimiento, m.codigo_departamento, m.nombre_departamento,
              m.codigo_distrito, m.nombre_distrito, m.codigo_zona, m.nombre_zona, m.codigo_barrio_localidad, m.nombre_barrio_localidad,
              m.codigo_institucion, m.nombre_institucion, m.sector_o_tipo_gestion, m.anho_cod_geo,
              m.matricula_ets_varon, m.matricula_ets_mujer, m.matricula_fed_varon, m.matricula_fed_mujer,
              m.matricula_fdes_varon, m.matricula_fdes_mujer, m.matricula_pd_varon, m.matricula_pd_mujer]           
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
            "cantidad_matriculados_varon", "cantidad_matriculados_mujer"]

          # data rows
          matriculaciones_departamentos_distritos.each do |m|
            csv << [m.anio, m.codigo_departamento, m.nombre_departamento,
              m.codigo_distrito, m.nombre_distrito, m.codigo_zona, m.nombre_zona,
              m.sector_o_tipo_gestion, m.anho_cod_geo,
              m.cantidad_matriculados_varon, m.cantidad_matriculados_mujer]
          end      
         end

        #DESCARGA XLS
        p = Axlsx::Package.new     
        p.workbook.add_worksheet(:name => "Matriculaciones EDD") do |sheet|          
          sheet.add_row [:anio, :codigo_departamento, :nombre_departamento,
            :codigo_distrito, :nombre_distrito, :codigo_zona, :nombre_zona,
            :sector_o_tipo_gestion, :anho_cod_geo,
            :cantidad_matriculados_varon, :cantidad_matriculados_mujer]
            
          matriculaciones_departamentos_distritos.each do |m|              
            sheet.add_row [m.anio, m.codigo_departamento, m.nombre_departamento,
              m.codigo_distrito, m.nombre_distrito, m.codigo_zona, m.nombre_zona,
              m.sector_o_tipo_gestion, m.anho_cod_geo,
              m.cantidad_matriculados_varon, m.cantidad_matriculados_mujer]
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
      
    anios = [2013, 2012]
    for year in anios

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
            "maternal_varon", "maternal_mujer", "prejardin_varon", "prejardin_mujer", "jardin_varon", "jardin_mujer",
            "preescolar_varon", "preescolar_mujer", "total_matriculados_varon", "total_matriculados_mujer",
            "inicial_noformal_varon", "inicial_noformal_mujer"]

          # data rows
          matriculaciones_inicial.each do |m|
            csv << [m.anio, m.codigo_establecimiento, m.codigo_departamento, m.nombre_departamento,
              m.codigo_distrito, m.nombre_distrito, m.codigo_zona, m.nombre_zona, m.codigo_barrio_localidad, m.nombre_barrio_localidad,
              m.codigo_institucion, m.nombre_institucion, m.sector_o_tipo_gestion, m.anho_cod_geo,
              m.maternal_varon, m.maternal_mujer, m.prejardin_varon, m.prejardin_mujer, m.jardin_varon, m.jardin_mujer,
              m.preescolar_varon, m.preescolar_mujer, m.total_matriculados_varon, m.total_matriculados_mujer,
              m.inicial_noformal_varon, m.inicial_noformal_mujer]
          end      
        end

        #DESCARGA XLS
        p = Axlsx::Package.new      
        p.workbook.add_worksheet(:name => "Matriculaciones EI") do |sheet|          
          sheet.add_row [:anio, :codigo_establecimiento, :codigo_departamento, :nombre_departamento,
            :codigo_distrito, :nombre_distrito, :codigo_zona, :nombre_zona, :codigo_barrio_localidad, :nombre_barrio_localidad,
            :codigo_institucion, :nombre_institucion, :sector_o_tipo_gestion, :anho_cod_geo,
            :maternal_varon, :maternal_mujer, :prejardin_varon, :prejardin_mujer, :jardin_varon, :jardin_mujer,
            :preescolar_varon, :preescolar_mujer, :total_matriculados_varon, :total_matriculados_mujer,
            :inicial_noformal_varon, :inicial_noformal_mujer]
            
          matriculaciones_inicial.each do |m|              
            sheet.add_row [m.anio, m.codigo_establecimiento, m.codigo_departamento, m.nombre_departamento,
              m.codigo_distrito, m.nombre_distrito, m.codigo_zona, m.nombre_zona, m.codigo_barrio_localidad, m.nombre_barrio_localidad,
              m.codigo_institucion, m.nombre_institucion, m.sector_o_tipo_gestion, m.anho_cod_geo,
              m.maternal_varon, m.maternal_mujer, m.prejardin_varon, m.prejardin_mujer, m.jardin_varon, m.jardin_mujer,
              m.preescolar_varon, m.preescolar_mujer, m.total_matriculados_varon, m.total_matriculados_mujer,
              m.inicial_noformal_varon, m.inicial_noformal_mujer]            
          end
        end

        p.serialize("#{Rails.root}/public/data/#{nombre_archivo}.xlsx")

        #DESCARGA JSON
        File.open("#{Rails.root}/public/data/#{nombre_archivo}.json","w") do |f|
          f.write(matriculaciones_inicial.to_json)
        end

        #DESCARGA ZIP
        #zip_archivo(nombre_archivo, ['xlsx', 'csv', 'json'])

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