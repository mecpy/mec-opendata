class MatriculacionesEducacionSuperiorController < ApplicationController
  
  def index
    @matriculaciones_educacion_superior = MatriculacionEducacionSuperior.ordenado_institucion.paginate :per_page => 15, :page => params[:page]
    respond_to do |f|

      f.html {render :layout => 'application'}

    end
  end
  
  def diccionario
    
    require 'json'
    file = File.read("#{Rails.root}/app/assets/javascripts/diccionario/matriculaciones_educacion_superior.json")
    diccionario = JSON.parse(file)
    @diccionario_matriculaciones_educacion_superior = clean_json(diccionario)

    if params[:format] == 'json'
      
      generate_json_table_schema(@diccionario_matriculaciones_educacion_superior)

    elsif params[:format] == 'pdf'
      
      send_data(generate_pdf(@diccionario_matriculaciones_educacion_superior, params[:nombre]), :filename => "diccionario_matriculaciones_educacion_superior.pdf", :type => "application/pdf")

    end
    
  end

  def lista

    cond = []
    args = []
    estados = []

    if params[:form_buscar_matriculaciones_educacion_superior] &&
        params[:form_buscar_matriculaciones_educacion_superior][:anio].present?

      cond << "anio = ?"
      args << params[:form_buscar_matriculaciones_educacion_superior][:anio]

    end

    if params[:form_buscar_matriculaciones_educacion_superior_nombre_departamento].present?

      cond << "nombre_departamento ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_matriculaciones_educacion_superior_nombre_departamento])}%"

    end

    if params[:form_buscar_matriculaciones_educacion_superior_nombre_distrito].present?

      cond << "nombre_distrito ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_matriculaciones_educacion_superior_nombre_distrito])}%"

    end

    if params[:form_buscar_matriculaciones_educacion_superior_nombre_barrio_localidad].present?

      cond << "nombre_barrio_localidad ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_matriculaciones_educacion_superior_nombre_barrio_localidad])}%"

    end
    
    if params[:form_buscar_matriculaciones_educacion_superior][:nombre_zona].present?

      cond << "nombre_zona = ?"
      args << "#{params[:form_buscar_matriculaciones_educacion_superior][:nombre_zona]}"

    end

    if params[:form_buscar_matriculaciones_educacion_superior_codigo_establecimiento].present?

      cond << "codigo_establecimiento ilike ?"
      args << "%#{params[:form_buscar_matriculaciones_educacion_superior_codigo_establecimiento]}%"

    end

    if params[:form_buscar_matriculaciones_educacion_superior_codigo_institucion].present?

      cond << "codigo_institucion = ?"
      args << params[:form_buscar_matriculaciones_educacion_superior_codigo_institucion]

    end

    if params[:form_buscar_matriculaciones_educacion_superior_nombre_institucion].present?

      cond << "nombre_institucion ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_matriculaciones_educacion_superior_nombre_institucion])}%"

    end

    if params[:form_buscar_matriculaciones_educacion_superior_sector_o_tipo_gestion].present?

      cond << "sector_o_tipo_gestion ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_matriculaciones_educacion_superior_sector_o_tipo_gestion])}%"

    end


    if params[:form_buscar_matriculaciones_educacion_superior_matricula_ets].present?

      cond << "matricula_ets #{params[:form_buscar_matriculaciones_educacion_superior_matricula_ets_operador]} ?"
      args << params[:form_buscar_matriculaciones_educacion_superior_matricula_ets]

    end


    if params[:form_buscar_matriculaciones_educacion_superior_matricula_fed].present?

      cond << "matricula_fed #{params[:form_buscar_matriculaciones_educacion_superior_matricula_fed_operador]} ?"
      args << params[:form_buscar_matriculaciones_educacion_superior_matricula_fed]

    end


    if params[:form_buscar_matriculaciones_educacion_superior_matricula_fdes].present?

      cond << "matricula_fdes #{params[:form_buscar_matriculaciones_educacion_superior_matricula_fdes_operador]} ?"
      args << params[:form_buscar_matriculaciones_educacion_superior_matricula_fdes]

    end


    if params[:form_buscar_matriculaciones_educacion_superior_matricula_pd].present?

      cond << "matricula_pd #{params[:form_buscar_matriculaciones_educacion_superior_matricula_pd_operador]} ?"
      args << params[:form_buscar_matriculaciones_educacion_superior_matricula_pd]

    end

    cond = cond.join(" and ").lines.to_a + args if cond.size > 0
    
    if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
      @matriculaciones_educacion_superior = MatriculacionEducacionSuperior.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond).paginate(page: params[:page], per_page: 15)
    else
      @matriculaciones_educacion_superior = MatriculacionEducacionSuperior.ordenado_institucion.where(cond).paginate(page: params[:page], per_page: 15)
    end

    @total_registros = MatriculacionEducacionSuperior.count 

    if params[:format] == 'csv'

      require 'csv'
      
      if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
        matriculaciones_educacion_superior = MatriculacionEducacionSuperior.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond)
      else
        matriculaciones_educacion_superior = MatriculacionEducacionSuperior.ordenado_institucion.where(cond)
      end

      csv = CSV.generate do |csv|
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
    
      send_data(csv, :type => 'text/csv', :filename => "matriculaciones_educacion_superior_#{Time.now.strftime('%Y%m%d')}.csv")

    elsif params[:format] == 'xlsx'
      
      if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
        matriculaciones_educacion_superior = MatriculacionEducacionSuperior.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond)
      else
        matriculaciones_educacion_superior = MatriculacionEducacionSuperior.ordenado_institucion.where(cond)
      end

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
      
      p.use_shared_strings = true
      
      send_data p.to_stream.read, filename: "matriculaciones_educacion_superior_#{Time.now.strftime('%d%m%Y__%H%M')}.xlsx", :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet", disposition: 'attachment'

    elsif params[:format] == 'pdf'

      report = ThinReports::Report.new layout: File.join(Rails.root, 'app',
        'reports', 'matriculaciones_educacion_superior.tlf')
      
      if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
        matriculaciones_educacion_superior = MatriculacionEducacionSuperior.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond)
      else
        matriculaciones_educacion_superior = MatriculacionEducacionSuperior.ordenado_institucion.where(cond)
      end
    
      report.start_new_page do |page|
      
        page.item(:fecha_hora).value("Fecha y Hora: #{Time.now.strftime('%d/%m/%Y - %H:%M')}")
    
      end

      matriculaciones_educacion_superior.each do |e|
      
        report.list(:matriculaciones_educacion_superior).add_row do |row|

          row.values  anio: e.anio,
            codigo_departamento: e.codigo_departamento.to_s,        
            nombre_departamento: e.nombre_departamento.to_s,       
            codigo_distrito: e.codigo_distrito.to_s,       
            nombre_distrito: e.nombre_distrito.to_s,
            codigo_barrio_localidad: e.codigo_barrio_localidad,
            nombre_barrio_localidad: e.nombre_barrio_localidad,       
            codigo_zona: e.codigo_zona.to_s,       
            nombre_zona: e.nombre_zona.to_s,
            codigo_establecimiento: e.codigo_establecimiento.to_s,
            codigo_institucion: e.codigo_institucion.to_s,
            nombre_institucion: e.nombre_institucion.to_s,
            sector_o_tipo_gestion: e.sector_o_tipo_gestion.to_s,
            matricula_ets: e.matricula_ets.to_s,
            matricula_fed: e.matricula_fed.to_s,
            matricula_fdes: e.matricula_fdes.to_s,
            matricula_pd: e.matricula_pd.to_s      

        end

      end


      send_data report.generate, filename: "matriculaciones_educacion_superior_#{Time.now.strftime('%d%m%Y__%H%M')}.pdf", 
        type: 'application/pdf', 
        disposition: 'attachment'

    elsif params[:format] == 'md5_csv'
      
      filename = "matriculaciones_educacion_superior_" + params[:form_buscar_matriculaciones_educacion_superior][:anio]
      path_file = "#{Rails.root}/public/data/" + filename + ".csv"
      send_data(generate_md5(path_file), :filename => filename+".md5", :type => "application/txt")

    else
      
      if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
        @matriculaciones_educacion_superior_todos = MatriculacionEducacionSuperior.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond)
      else
        @matriculaciones_educacion_superior_todos = MatriculacionEducacionSuperior.ordenado_institucion.where(cond)
      end
      
      respond_to do |f|

        f.js
        f.json {render :json => @matriculaciones_educacion_superior_todos }

      end 

    end

  end
end
