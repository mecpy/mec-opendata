class MatriculacionesEducacionPermanenteController < ApplicationController

  def index
    @matriculaciones_educacion_permanente = MatriculacionEducacionPermanente.ordenado_institucion.paginate :per_page => 15, :page => params[:page]
    
    respond_to do |f|

      f.html {render :layout => 'application'}

    end
  end
  
  def diccionario
    
    require 'json'
    file = File.read("#{Rails.root}/app/assets/javascripts/diccionario/matriculaciones_educacion_permanente.json")
    diccionario = JSON.parse(file)
    @diccionario_matriculaciones_educacion_permanente = clean_json(diccionario)

    if params[:format] == 'json'
      
      generate_json_table_schema(@diccionario_matriculaciones_educacion_permanente)

    elsif params[:format] == 'pdf'
      
      send_data(generate_pdf(@diccionario_matriculaciones_educacion_permanente, params[:nombre]), :filename => "diccionario_matriculaciones_educacion_permanente.pdf", :type => "application/pdf")

    end
    
  end

  def lista

    cond = []
    args = []
    estados = []

    if params[:form_buscar_matriculaciones_educacion_permanente] &&
        params[:form_buscar_matriculaciones_educacion_permanente][:anio].present?

      cond << "anio = ?"
      args << params[:form_buscar_matriculaciones_educacion_permanente][:anio]

    end


    if params[:form_buscar_matriculaciones_educacion_permanente_codigo_establecimiento].present?

      cond << "codigo_establecimiento ilike ?"
      args << "%#{params[:form_buscar_matriculaciones_educacion_permanente_codigo_establecimiento]}%"

    end

    if params[:form_buscar_matriculaciones_educacion_permanente_nombre_departamento].present?

      cond << "nombre_departamento ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_matriculaciones_educacion_permanente_nombre_departamento])}%"

    end

    if params[:form_buscar_matriculaciones_educacion_permanente_nombre_distrito].present?

      cond << "nombre_distrito ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_matriculaciones_educacion_permanente_nombre_distrito])}%"

    end
    
    if params[:form_buscar_matriculaciones_educacion_permanente][:nombre_zona].present?

      cond << "nombre_zona = ?"
      args << "#{params[:form_buscar_matriculaciones_educacion_permanente][:nombre_zona]}"

    end

    if params[:form_buscar_matriculaciones_educacion_permanente_nombre_barrio_localidad].present?

      cond << "nombre_barrio_localidad ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_matriculaciones_educacion_permanente_nombre_barrio_localidad])}%"

    end

    if params[:form_buscar_matriculaciones_educacion_permanente_sector_o_tipo_gestion].present?

      cond << "sector_o_tipo_gestion ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_matriculaciones_educacion_permanente_sector_o_tipo_gestion])}%"

    end

    if params[:form_buscar_matriculaciones_educacion_permanente_codigo_institucion].present?

      cond << "codigo_institucion = ?"
      args << params[:form_buscar_matriculaciones_educacion_permanente_codigo_institucion]

    end

    if params[:form_buscar_matriculaciones_educacion_permanente_nombre_institucion].present?

      cond << "nombre_institucion ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_matriculaciones_educacion_permanente_nombre_institucion])}%"

    end

    if params[:form_buscar_matriculaciones_educacion_permanente_matricula_ebbja].present?

      cond << "matricula_ebbja #{params[:form_buscar_matriculaciones_educacion_permanente_matricula_ebbja_operador]} ?"
      args << params[:form_buscar_matriculaciones_educacion_permanente_matricula_ebbja]

    end

    if params[:form_buscar_matriculaciones_educacion_permanente_matricula_ebbja_hombre].present?

      cond << "matricula_ebbja_hombre #{params[:form_buscar_matriculaciones_educacion_permanente_matricula_ebbja_hombre_operador]} ?"
      args << params[:form_buscar_matriculaciones_educacion_permanente_matricula_ebbja_hombre]

    end

    if params[:form_buscar_matriculaciones_educacion_permanente_matricula_ebbja_mujer].present?

      cond << "matricula_ebbja_mujer #{params[:form_buscar_matriculaciones_educacion_permanente_matricula_ebbja_mujer_operador]} ?"
      args << params[:form_buscar_matriculaciones_educacion_permanente_matricula_ebbja_mujer]

    end

    if params[:form_buscar_matriculaciones_educacion_permanente_matricula_fpi].present?

      cond << "matricula_fpi #{params[:form_buscar_matriculaciones_educacion_permanente_matricula_fpi_operador]} ?"
      args << params[:form_buscar_matriculaciones_educacion_permanente_matricula_fpi]
      
    end

    if params[:form_buscar_matriculaciones_educacion_permanente_matricula_fpi_hombre].present?

      cond << "matricula_fpi_hombre #{params[:form_buscar_matriculaciones_educacion_permanente_matricula_fpi_hombre_operador]} ?"
      args << params[:form_buscar_matriculaciones_educacion_permanente_matricula_fpi_hombre]

    end

    if params[:form_buscar_matriculaciones_educacion_permanente_matricula_fpi_hombre].present?

      cond << "matricula_fpi_hombre #{params[:form_buscar_matriculaciones_educacion_permanente_matricula_fpi_hombre_operador]} ?"
      args << params[:form_buscar_matriculaciones_educacion_permanente_matricula_fpi_hombre]

    end

    if params[:form_buscar_matriculaciones_educacion_permanente_matricula_fpi_mujer].present?

      cond << "matricula_fpi_mujer #{params[:form_buscar_matriculaciones_educacion_permanente_matricula_fpi_mujer_operador]} ?"
      args << params[:form_buscar_matriculaciones_educacion_permanente_matricula_fpi_mujer]

    end

    if params[:form_buscar_matriculaciones_educacion_permanente_matricula_emapja].present?

      cond << "matricula_emapja #{params[:form_buscar_matriculaciones_educacion_permanente_matricula_emapja_operador]} ?"
      args << params[:form_buscar_matriculaciones_educacion_permanente_matricula_emapja]

    end

    if params[:form_buscar_matriculaciones_educacion_permanente_matricula_emapja_hombre].present?

      cond << "matricula_emapja_hombre #{params[:form_buscar_matriculaciones_educacion_permanente_matricula_emapja_hombre_operador]} ?"
      args << params[:form_buscar_matriculaciones_educacion_permanente_matricula_emapja_hombre]

    end

    if params[:form_buscar_matriculaciones_educacion_permanente_matricula_emapja_mujer].present?

      cond << "matricula_emapja_mujer #{params[:form_buscar_matriculaciones_educacion_permanente_matricula_emapja_mujer_operador]} ?"
      args << params[:form_buscar_matriculaciones_educacion_permanente_matricula_emapja_mujer]

    end
   
    if params[:form_buscar_matriculaciones_educacion_permanente_matricula_emdja].present?

      cond << "matricula_emdja #{params[:form_buscar_matriculaciones_educacion_permanente_matricula_emdja_operador]} ?"
      args << params[:form_buscar_matriculaciones_educacion_permanente_matricula_emdja]

    end

    if params[:form_buscar_matriculaciones_educacion_permanente_matricula_emdja_hombre].present?

      cond << "matricula_emdja_hombre #{params[:form_buscar_matriculaciones_educacion_permanente_matricula_emdja_hombre_operador]} ?"
      args << params[:form_buscar_matriculaciones_educacion_permanente_matricula_emdja_hombre]

    end

    if params[:form_buscar_matriculaciones_educacion_permanente_matricula_emdja_mujer].present?

      cond << "matricula_emdja_mujer #{params[:form_buscar_matriculaciones_educacion_permanente_matricula_emdja_mujer_operador]} ?"
      args << params[:form_buscar_matriculaciones_educacion_permanente_matricula_emdja_mujer]

    end

   
    if params[:form_buscar_matriculaciones_educacion_permanente_matricula_fp].present?

      cond << "matricula_fp #{params[:form_buscar_matriculaciones_educacion_permanente_matricula_fp_operador]} ?"
      args << params[:form_buscar_matriculaciones_educacion_permanente_matricula_fp]

    end

    if params[:form_buscar_matriculaciones_educacion_permanente_matricula_fp_hombre].present?

      cond << "matricula_fp_hombre #{params[:form_buscar_matriculaciones_educacion_permanente_matricula_fp_hombre_operador]} ?"
      args << params[:form_buscar_matriculaciones_educacion_permanente_matricula_fp_hombre]

    end

    if params[:form_buscar_matriculaciones_educacion_permanente_matricula_fp_mujer].present?

      cond << "matricula_fp_mujer #{params[:form_buscar_matriculaciones_educacion_permanente_matricula_fp_mujer_operador]} ?"
      args << params[:form_buscar_matriculaciones_educacion_permanente_matricula_fp_mujer]

    end

    cond = cond.join(" and ").lines.to_a + args if cond.size > 0
    
    if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
      @matriculaciones_educacion_permanente = MatriculacionEducacionPermanente.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond).paginate(page: params[:page], per_page: 15)
    else
      @matriculaciones_educacion_permanente = MatriculacionEducacionPermanente.ordenado_institucion.where(cond).paginate(page: params[:page], per_page: 15)
    end

    @total_registros = MatriculacionEducacionPermanente.count 

    if params[:format] == 'csv'

      require 'csv'
      
      if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
        matriculaciones_educacion_permanente = MatriculacionEducacionPermanente.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond)
      else
        matriculaciones_educacion_permanente = MatriculacionEducacionPermanente.ordenado_institucion.where(cond)
      end

      csv = CSV.generate do |csv|
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
      
      send_data(csv, :type => 'text/csv', :filename => "matriculaciones_educacion_permanente_#{Time.now.strftime('%Y%m%d')}.csv")

    elsif params[:format] == 'xlsx'
      
      if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
        matriculaciones_educacion_permanente = MatriculacionEducacionPermanente.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond)
      else
        matriculaciones_educacion_permanente = MatriculacionEducacionPermanente.ordenado_institucion.where(cond)
      end

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
      
      p.use_shared_strings = true
      
      send_data p.to_stream.read, filename: "matriculaciones_educacion_permanente_#{Time.now.strftime('%d%m%Y__%H%M')}.xlsx", :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet", disposition: 'attachment'

    elsif params[:format] == 'pdf'

      report = ThinReports::Report.new layout: File.join(Rails.root, 'app',
        'reports', 'matriculaciones_educacion_permanente.tlf')
      
      if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
        matriculaciones_educacion_permanente = MatriculacionEducacionPermanente.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond)
      else
        matriculaciones_educacion_permanente = MatriculacionEducacionPermanente.ordenado_institucion.where(cond)
      end
    
      report.start_new_page do |page|
      
        page.item(:fecha_hora).value("Fecha y Hora: #{Time.now.strftime('%d/%m/%Y - %H:%M')}")
    
      end

      matriculaciones_educacion_permanente.each do |p|
      
        report.list(:matriculaciones_educacion_permanente).add_row do |row|

          row.values  anio: p.anio,
            codigo_departamento: p.codigo_departamento.to_s,        
            nombre_departamento: p.nombre_departamento.to_s,       
            codigo_distrito: p.codigo_distrito.to_s,       
            nombre_distrito: p.nombre_distrito.to_s,       
            codigo_zona: p.codigo_zona.to_s,       
            nombre_zona: p.nombre_zona.to_s,
            sector_o_tipo_gestion: p.sector_o_tipo_gestion.to_s,
            codigo_institucion: p.codigo_institucion.to_s,
            nombre_institucion: p.nombre_institucion.to_s,
            matricula_ebbja: p.matricula_ebbja.to_s,
            matricula_fpi: p.matricula_fpi.to_s,
            matricula_emapja: p.matricula_emapja.to_s,
            matricula_emdja: p.matricula_emdja.to_s,
            matricula_fp: p.matricula_fp.to_s   

        end
 
                     
      end


      send_data report.generate, filename: "matriculaciones_educacion_permanente_#{Time.now.strftime('%d%m%Y__%H%M')}.pdf", 
        type: 'application/pdf', 
        disposition: 'attachment'

    elsif params[:format] == 'md5_csv'
      
      filename = "matriculaciones_educacion_permanente_" + params[:form_buscar_matriculaciones_educacion_permanente][:anio]
      path_file = "#{Rails.root}/public/data/" + filename + ".csv"
      send_data(generate_md5(path_file), :filename => filename+".md5", :type => "application/txt")

    else
      
      if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
        @matriculaciones_educacion_permanente_todos = MatriculacionEducacionPermanente.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond)
      else
        @matriculaciones_educacion_permanente_todos = MatriculacionEducacionPermanente.ordenado_institucion.where(cond)
      end
      
      respond_to do |f|

        f.js
        f.json {render :json => @matriculaciones_educacion_permanente_todos }

      end 

    end

  end
end
