class MatriculacionesEducacionEscolarBasicaController < ApplicationController

  def index

    @matriculaciones_educacion_escolar_basica = MatriculacionEducacionEscolarBasica.ordenado_institucion.paginate :per_page => 15, :page => params[:page]

    respond_to do |f|

      f.html {render :layout => 'application'}

    end
  end

  def diccionario

    require 'json'
    file = File.read("#{Rails.root}/app/assets/javascripts/diccionario/matriculaciones_educacion_escolar_basica.json")
    diccionario = JSON.parse(file)
    @diccionario_matriculaciones_educacion_escolar_basica = clean_json(diccionario)

    if params[:format] == 'json'
      
      generate_json_table_schema(@diccionario_matriculaciones_educacion_escolar_basica)

    elsif params[:format] == 'pdf'
      
      send_data(generate_pdf(@diccionario_matriculaciones_educacion_escolar_basica, params[:nombre]), :filename => "diccionario_matriculaciones_educacion_escolar_basica.pdf", :type => "application/pdf")

    end
    
  end

  def lista

    cond = []
    args = []
    estados = []

    if params[:form_buscar_matriculaciones_educacion_escolar_basica] && params[:form_buscar_matriculaciones_educacion_escolar_basica][:anio].present?

      cond << "anio = ?"
      args << params[:form_buscar_matriculaciones_educacion_escolar_basica][:anio]

    end

    if params[:form_buscar_matriculaciones_educacion_escolar_basica_codigo_establecimiento].present?

      cond << "codigo_establecimiento ilike ?"
      args << "%#{params[:form_buscar_matriculaciones_educacion_escolar_basica_codigo_establecimiento]}%"

    end

    if params[:form_buscar_matriculaciones_educacion_escolar_basica_nombre_departamento].present?

      cond << "nombre_departamento ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_matriculaciones_educacion_escolar_basica_nombre_departamento])}%"

    end

    if params[:form_buscar_matriculaciones_educacion_escolar_basica_nombre_distrito].present?

      cond << "nombre_distrito ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_matriculaciones_educacion_escolar_basica_nombre_distrito])}%"

    end
    
    if params[:form_buscar_matriculaciones_educacion_escolar_basica][:nombre_zona].present?

      cond << "nombre_zona = ?"
      args << "#{params[:form_buscar_matriculaciones_educacion_escolar_basica][:nombre_zona]}"

    end

    if params[:form_buscar_matriculaciones_educacion_escolar_basica_nombre_barrio_localidad].present?

      cond << "nombre_barrio_localidad ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_matriculaciones_educacion_escolar_basica_nombre_barrio_localidad])}%"

    end

    if params[:form_buscar_matriculaciones_educacion_escolar_basica_codigo_institucion].present?

      cond << "codigo_institucion = ?"
      args << params[:form_buscar_matriculaciones_educacion_escolar_basica_codigo_institucion]

    end

    if params[:form_buscar_matriculaciones_educacion_escolar_basica_nombre_institucion].present?

      cond << "nombre_institucion ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_matriculaciones_educacion_escolar_basica_nombre_institucion])}%"

    end

    if params[:form_buscar_matriculaciones_educacion_escolar_basica_sector_o_tipo_gestion].present?

      cond << "sector_o_tipo_gestion ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_matriculaciones_educacion_escolar_basica_sector_o_tipo_gestion])}%"

    end
    
    if params[:form_buscar_matriculaciones_educacion_escolar_basica_primer_grado].present?

      cond << "primer_grado #{params[:form_buscar_matriculaciones_educacion_escolar_basica_primer_grado_operador]} ?"
      args << params[:form_buscar_matriculaciones_educacion_escolar_basica_primer_grado]

    end
    
    if params[:form_buscar_matriculaciones_educacion_escolar_basica_segundo_grado].present?

      cond << "segundo_grado #{params[:form_buscar_matriculaciones_educacion_escolar_basica_segundo_grado_operador]} ?"
      args << params[:form_buscar_matriculaciones_educacion_escolar_basica_segundo_grado]
    end

    if params[:form_buscar_matriculaciones_educacion_escolar_basica_tercer_grado].present?

      cond << "tercer_grado #{params[:form_buscar_matriculaciones_educacion_escolar_basica_tercer_grado_operador]} ?"
      args << params[:form_buscar_matriculaciones_educacion_escolar_basica_tercer_grado]

    end
   
    if params[:form_buscar_matriculaciones_educacion_escolar_basica_cuarto_grado].present?

      cond << "cuarto_grado #{params[:form_buscar_matriculaciones_educacion_escolar_basica_cuarto_grado_operador]} ?"
      args << params[:form_buscar_matriculaciones_educacion_escolar_basica_cuarto_grado]

    end
   
    if params[:form_buscar_matriculaciones_educacion_escolar_basica_quinto_grado].present?

      cond << "quinto_grado #{params[:form_buscar_matriculaciones_educacion_escolar_basica_quinto_grado_operador]} ?"
      args << params[:form_buscar_matriculaciones_educacion_escolar_basica_quinto_grado]

    end
  
    if params[:form_buscar_matriculaciones_educacion_escolar_basica_sexto_grado].present?

      cond << "sexto_grado #{params[:form_buscar_matriculaciones_educacion_escolar_basica_sexto_grado_operador]} ?"
      args << params[:form_buscar_matriculaciones_educacion_escolar_basica_sexto_grado]

    end
 
    if params[:form_buscar_matriculaciones_educacion_escolar_basica_septimo_grado].present?

      cond << "septimo_grado #{params[:form_buscar_matriculaciones_educacion_escolar_basica_septimo_grado_operador]} ?"
      args << params[:form_buscar_matriculaciones_educacion_escolar_basica_septimo_grado]
    end

    if params[:form_buscar_matriculaciones_educacion_escolar_basica_octavo_grado].present?

      cond << "octavo_grado #{params[:form_buscar_matriculaciones_educacion_escolar_basica_octavo_grado_operador]} ?"
      args << params[:form_buscar_matriculaciones_educacion_escolar_basica_octavo_grado]
    end


    if params[:form_buscar_matriculaciones_educacion_escolar_basica_noveno_grado].present?

      cond << "noveno_grado #{params[:form_buscar_matriculaciones_educacion_escolar_basica_noveno_grado_operador]} ?"
      args << params[:form_buscar_matriculaciones_educacion_escolar_basica_noveno_grado]

    end

    if params[:form_buscar_matriculaciones_educacion_escolar_basica_total_matriculados].present?

      cond << "total_matriculados #{params[:form_buscar_matriculaciones_educacion_escolar_basica_total_matriculados_operador]} ?"
      args << params[:form_buscar_matriculaciones_educacion_escolar_basica_total_matriculados]

    end

    cond = cond.join(" and ").lines.to_a + args if cond.size > 0
    
    if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
      @matriculaciones_educacion_escolar_basica = MatriculacionEducacionEscolarBasica.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond).paginate(page: params[:page], per_page: 15)
    else
      @matriculaciones_educacion_escolar_basica = MatriculacionEducacionEscolarBasica.ordenado_institucion.where(cond).paginate(page: params[:page], per_page: 15)
    end

    @total_registros = MatriculacionEducacionEscolarBasica.count 

    if params[:format] == 'csv'

      require 'csv'
      
      if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
        matriculaciones_educacion_escolar_basica = MatriculacionEducacionEscolarBasica.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond)
      else
        matriculaciones_educacion_escolar_basica = MatriculacionEducacionEscolarBasica.ordenado_institucion.where(cond)
      end

      csv = CSV.generate do |csv|
        csv << ["anio", "codigo_establecimiento", "codigo_departamento", "nombre_departamento",
            "codigo_distrito", "nombre_distrito", "codigo_zona", "nombre_zona", "codigo_barrio_localidad", "nombre_barrio_localidad",
            "codigo_institucion", "nombre_institucion", "sector_o_tipo_gestion", "anho_cod_geo",
            "primer_grado_varon", "primer_grado_mujer", "segundo_grado_varon", "segundo_grado_mujer", "tercer_grado_varon", "tercer_grado_mujer",
            "cuarto_grado_varon", "cuarto_grado_mujer", "quinto_grado_varon", "quinto_grado_mujer", "sexto_grado_varon", "sexto_grado_mujer",
            "septimo_grado_varon", "septimo_grado_mujer", "octavo_grado_varon", "octavo_grado_mujer","noveno_grado_varon", "noveno_grado_mujer",
            "total_matriculados_varon", "total_matriculados_mujer"]
 
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
    
      send_data(csv, :type => 'text/csv', :filename => "matriculaciones_educacion_escolar_basica_#{Time.now.strftime('%Y%m%d')}.csv")

    elsif params[:format] == 'xlsx'
      
      if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
        matriculaciones_educacion_escolar_basica = MatriculacionEducacionEscolarBasica.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond)
      else
        matriculaciones_educacion_escolar_basica = MatriculacionEducacionEscolarBasica.ordenado_institucion.where(cond)
      end

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
      
      p.use_shared_strings = true
      
      send_data p.to_stream.read, filename: "matriculaciones_educacion_escolar_basica_#{Time.now.strftime('%d%m%Y__%H%M')}.xlsx", :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet", disposition: 'attachment'
      
    elsif params[:format] == 'pdf'

      report = ThinReports::Report.new layout: File.join(Rails.root, 'app', 'reports', 'matriculaciones_educacion_escolar_basica.tlf')
      
      if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
        matriculaciones_educacion_escolar_basica = MatriculacionEducacionEscolarBasica.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond)
      else
        matriculaciones_educacion_escolar_basica = MatriculacionEducacionEscolarBasica.ordenado_institucion.where(cond)
      end
    
      report.start_new_page do |page|
      
        page.item(:fecha_hora).value("Fecha y Hora: #{Time.now.strftime('%d/%m/%Y - %H:%M')}")
    
      end

      matriculaciones_educacion_escolar_basica.each do |meeb|
      
        report.list(:matriculaciones_educacion_escolar_basica).add_row do |row|

          row.values  anio: meeb.anio,
            codigo_establecimiento: meeb.codigo_establecimiento,
            codigo_departamento: meeb.codigo_departamento.to_s,        
            nombre_departamento: meeb.nombre_departamento.to_s,       
            codigo_distrito: meeb.codigo_distrito.to_s,       
            nombre_distrito: meeb.nombre_distrito.to_s,       
            codigo_zona: meeb.codigo_zona.to_s,       
            nombre_zona: meeb.nombre_zona.to_s,       
            codigo_barrio_localidad: meeb.codigo_barrio_localidad.to_s,       
            nombre_barrio_localidad: meeb.nombre_barrio_localidad.to_s,
            sector_o_tipo_gestion: meeb.sector_o_tipo_gestion.to_s,
            primer_grado: meeb.primer_grado.to_s,
            segundo_grado: meeb.segundo_grado.to_s,
            tercer_grado: meeb.tercer_grado.to_s,
            cuarto_grado: meeb.cuarto_grado.to_s,
            quinto_grado: meeb.quinto_grado.to_s,
            sexto_grado: meeb.sexto_grado.to_s,
            septimo_grado: meeb.septimo_grado.to_s,
            octavo_grado: meeb.octavo_grado.to_s,
            noveno_grado: meeb.noveno_grado.to_s,
            total_matriculados: meeb.total_matriculados.to_s

        end

      end

      send_data report.generate, filename: "matriculaciones_educacion_escolar_basica_#{Time.now.strftime('%d%m%Y__%H%M')}.pdf", 
        type: 'application/pdf', 
        disposition: 'attachment'

    elsif params[:format] == 'md5_csv'
      
      filename = "matriculaciones_educacion_escolar_basica_" + params[:form_buscar_matriculaciones_educacion_escolar_basica][:anio]
      path_file = "#{Rails.root}/public/data/" + filename + ".csv"
      send_data(generate_md5(path_file), :filename => filename+".md5", :type => "application/txt")

    else
      
      if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
        @matriculaciones_educacion_escolar_basica_todos = MatriculacionEducacionEscolarBasica.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond)
      else
        @matriculaciones_educacion_escolar_basica_todos = MatriculacionEducacionEscolarBasica.ordenado_institucion.where(cond)
      end
      
      respond_to do |f|

        f.js
        f.json {render :json => @matriculaciones_educacion_escolar_basica_todos }

      end 

    end
  end
end


