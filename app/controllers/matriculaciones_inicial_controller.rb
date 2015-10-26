class MatriculacionesInicialController < ApplicationController

  def index

    @matriculaciones_inicial = MatriculacionInicial.ordenado_institucion.paginate :per_page => 15, :page => params[:page]

    respond_to do |f|

      f.html {render :layout => 'application'}

    end
  end

  def diccionario
    
    require 'json'
    file = File.read("#{Rails.root}/app/assets/javascripts/diccionario/matriculaciones_inicial.json")
    diccionario = JSON.parse(file)
    @diccionario_matriculaciones_inicial = clean_json(diccionario)

    if params[:format] == 'json'
      
      generate_json_table_schema(@diccionario_matriculaciones_inicial)

    elsif params[:format] == 'pdf'
      
      send_data(generate_pdf(@diccionario_matriculaciones_inicial, params[:nombre]), :filename => "diccionario_matriculaciones_inicial.pdf", :type => "application/pdf")

    end

  end

  def lista

    cond = []
    args = []
    estados = []

    if params[:form_buscar_matriculaciones_inicial] && params[:form_buscar_matriculaciones_inicial][:anio].present?

      cond << "anio = ?"
      args << params[:form_buscar_matriculaciones_inicial][:anio]

    end

    if params[:form_buscar_matriculaciones_inicial_codigo_establecimiento].present?

      cond << "codigo_establecimiento ilike ?"
      args << "%#{params[:form_buscar_matriculaciones_inicial_codigo_establecimiento]}%"

    end

    if params[:form_buscar_matriculaciones_inicial_nombre_departamento].present?

      cond << "nombre_departamento ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_matriculaciones_inicial_nombre_departamento])}%"

    end

    if params[:form_buscar_matriculaciones_inicial_nombre_distrito].present?

      cond << "nombre_distrito ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_matriculaciones_inicial_nombre_distrito])}%"

    end
    
    if params[:form_buscar_matriculaciones_inicial][:nombre_zona].present?

      cond << "nombre_zona = ?"
      args << "#{params[:form_buscar_matriculaciones_inicial][:nombre_zona]}"

    end

    if params[:form_buscar_matriculaciones_inicial_nombre_barrio_localidad].present?

      cond << "nombre_barrio_localidad ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_matriculaciones_inicial_nombre_barrio_localidad])}%"

    end

    if params[:form_buscar_matriculaciones_inicial_codigo_institucion].present?

      cond << "codigo_institucion = ?"
      args << params[:form_buscar_matriculaciones_inicial_codigo_institucion]

    end

    if params[:form_buscar_matriculaciones_inicial_nombre_institucion].present?

      cond << "nombre_institucion ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_matriculaciones_inicial_nombre_institucion])}%"

    end

    if params[:form_buscar_matriculaciones_inicial_sector_o_tipo_gestion].present?

      cond << "sector_o_tipo_gestion ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_matriculaciones_inicial_sector_o_tipo_gestion])}%"

    end
    
    if params[:form_buscar_matriculaciones_inicial_maternal].present?

      cond << "maternal #{params[:form_buscar_matriculaciones_inicial_maternal_operador]} ?"
      args << params[:form_buscar_matriculaciones_inicial_maternal]

    end
    
    if params[:form_buscar_matriculaciones_inicial_prejardin].present?

      cond << "prejardin #{params[:form_buscar_matriculaciones_inicial_prejardin_operador]} ?"
      args << params[:form_buscar_matriculaciones_inicial_prejardin]
    end

    if params[:form_buscar_matriculaciones_inicial_jardin].present?

      cond << "jardin #{params[:form_buscar_matriculaciones_inicial_jardin_operador]} ?"
      args << params[:form_buscar_matriculaciones_inicial_jardin]

    end
   
    if params[:form_buscar_matriculaciones_inicial_preescolar].present?

      cond << "preescolar #{params[:form_buscar_matriculaciones_inicial_preescolar_operador]} ?"
      args << params[:form_buscar_matriculaciones_inicial_preescolar]

    end
   
    if params[:form_buscar_matriculaciones_inicial_total_matriculados].present?

      cond << "total_matriculados #{params[:form_buscar_matriculaciones_inicial_total_matriculados_operador]} ?"
      args << params[:form_buscar_matriculaciones_inicial_total_matriculados]

    end

    if params[:form_buscar_matriculaciones_inicial_total_matriculados_varon].present?

      cond << "total_matriculados_varon #{params[:form_buscar_matriculaciones_inicial_total_matriculados_varon_operador]} ?"
      args << params[:form_buscar_matriculaciones_inicial_total_matriculados_varon]

    end

    if params[:form_buscar_matriculaciones_inicial_total_matriculados_mujer].present?

      cond << "total_matriculados_mujer #{params[:form_buscar_matriculaciones_inicial_total_matriculados_mujer_operador]} ?"
      args << params[:form_buscar_matriculaciones_inicial_total_matriculados_mujer]

    end
  
    cond = cond.join(" and ").lines.to_a + args if cond.size > 0
    
    if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
      @matriculaciones_inicial = MatriculacionInicial.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond).paginate(page: params[:page], per_page: 15)
    else
      @matriculaciones_inicial = MatriculacionInicial.ordenado_institucion.where(cond).paginate(page: params[:page], per_page: 15)
    end

    @total_registros = MatriculacionInicial.count 

    if params[:format] == 'csv'

      require 'csv'
      
      if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
        matriculaciones_inicial = MatriculacionInicial.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond).paginate(page: params[:page], per_page: 15)
      else
        matriculaciones_inicial = MatriculacionInicial.ordenado_institucion.where(cond)
      end

      csv = CSV.generate do |csv|
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
    
      send_data(csv, :type => 'text/csv', :filename => "matriculaciones_inicial_#{Time.now.strftime('%Y%m%d')}.csv")

    elsif params[:format] == 'xlsx'
      
      if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
        matriculaciones_inicial = MatriculacionInicial.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond).paginate(page: params[:page], per_page: 15)
      else
        matriculaciones_inicial = MatriculacionInicial.ordenado_institucion.where(cond)
      end

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
      
      p.use_shared_strings = true
      
      send_data p.to_stream.read, filename: "matriculaciones_inicial_#{Time.now.strftime('%d%m%Y__%H%M')}.xlsx", :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet", disposition: 'attachment'

    elsif params[:format] == 'pdf'

      report = ThinReports::Report.new layout: File.join(Rails.root, 'app', 'reports', 'matriculaciones_inicial.tlf')
      
      if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
        matriculaciones_inicial = MatriculacionInicial.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond).paginate(page: params[:page], per_page: 15)
      else
        matriculaciones_inicial = MatriculacionInicial.ordenado_institucion.where(cond)
      end
    
      report.start_new_page do |page|
      
        page.item(:fecha_hora).value("Fecha y Hora: #{Time.now.strftime('%d/%m/%Y - %H:%M')}")
    
      end

      matriculaciones_inicial.each do |mi|
      
        report.list(:matriculaciones_inicial).add_row do |row|

          row.values  anio: mi.anio,
            codigo_establecimiento: mi.codigo_establecimiento,
            codigo_departamento: mi.codigo_departamento.to_s,        
            nombre_departamento: mi.nombre_departamento.to_s,       
            codigo_distrito: mi.codigo_distrito.to_s,       
            nombre_distrito: mi.nombre_distrito.to_s,       
            codigo_zona: mi.codigo_zona.to_s,       
            nombre_zona: mi.nombre_zona.to_s,       
            codigo_barrio_localidad: mi.codigo_barrio_localidad.to_s,       
            nombre_barrio_localidad: mi.nombre_barrio_localidad.to_s,
            sector_o_tipo_gestion: mi.sector_o_tipo_gestion.to_s,
            maternal: mi.maternal.to_s,
            prejardin: mi.prejardin.to_s,
            jardin: mi.jardin.to_s,
            preescolar: mi.preescolar.to_s,
            total_matriculados: mi.total_matriculados.to_s

        end

      end

      send_data report.generate, filename: "matriculaciones_inicial_#{Time.now.strftime('%d%m%Y__%H%M')}.pdf", 
        type: 'application/pdf', 
        disposition: 'attachment'

    elsif params[:format] == 'md5_csv'
      
      filename = "matriculaciones_inicial_" + params[:form_buscar_matriculaciones_inicial][:anio]
      path_file = "#{Rails.root}/public/data/" + filename + ".csv"
      send_data(generate_md5(path_file), :filename => filename+".md5", :type => "application/txt")

    else
      
      if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
        @matriculaciones_inicial_todos = MatriculacionInicial.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond).paginate(page: params[:page], per_page: 15)
      else
        @matriculaciones_inicial_todos = MatriculacionInicial.ordenado_institucion.where(cond)
      end
      
      respond_to do |f|

        f.js
        f.json {render :json => @matriculaciones_inicial_todos }

      end 

    end
  end
end


