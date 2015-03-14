class MatriculacionesEducacionInclusivaController < ApplicationController
  def index
    @matriculaciones_educacion_inclusiva = MatriculacionEducacionInclusiva.orden_dep_dis.paginate :per_page => 15, :page => params[:page]
    respond_to do |f|

      f.html {render :layout => 'application'}

    end
  end
  
  def diccionario
    
    require 'json'
    file = File.read("#{Rails.root}/app/assets/javascripts/diccionario/matriculaciones_educacion_inclusiva.json")
    @diccionario_matriculaciones_educacion_inclusiva = JSON.parse(file)

  end
  
  def lista

    cond = []
    args = []
    estados = []

    if params[:form_buscar_matriculaciones_educacion_inclusiva] && params[:form_buscar_matriculaciones_educacion_inclusiva][:anio].present?

      cond << "anio = ?"
      args << params[:form_buscar_matriculaciones_educacion_inclusiva][:anio]

    end

    if params[:form_buscar_matriculaciones_educacion_inclusiva_codigo_establecimiento].present?

      cond << "codigo_establecimiento ilike ?"
      args << "%#{params[:form_buscar_matriculaciones_educacion_inclusiva_codigo_establecimiento]}%"

    end

    if params[:form_buscar_matriculaciones_educacion_inclusiva_nombre_departamento].present?

      cond << "nombre_departamento ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_matriculaciones_educacion_inclusiva_nombre_departamento])}%"

    end
    
    if params[:form_buscar_matriculaciones_educacion_inclusiva][:nombre_zona].present?

      cond << "nombre_zona = ?"
      args << "#{params[:form_buscar_matriculaciones_educacion_inclusiva][:nombre_zona]}"

    end

    if params[:form_buscar_matriculaciones_educacion_inclusiva_nombre_zona].present?

      cond << "nombre_zona ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_matriculaciones_educacion_inclusiva_nombre_zona])}%"

    end

    if params[:form_buscar_matriculaciones_educacion_inclusiva_nombre_barrio_localidad].present?

      cond << "nombre_barrio_localidad ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_matriculaciones_educacion_inclusiva_nombre_barrio_localidad])}%"

    end

    if params[:form_buscar_matriculaciones_educacion_inclusiva_codigo_institucion].present?

      cond << "codigo_institucion = ?"
      args << params[:form_buscar_matriculaciones_educacion_inclusiva_codigo_institucion]

    end
    if params[:form_buscar_matriculaciones_educacion_inclusiva_nombre_institucion].present?

      cond << "nombre_institucion ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_matriculaciones_educacion_inclusiva_nombre_institucion])}%"

    end
    
    if params[:form_buscar_matriculaciones_educacion_inclusiva_sector_o_tipo_gestion].present?

      cond << "sector_o_tipo_gestion ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_matriculaciones_educacion_inclusiva_sector_o_tipo_gestion])}%"

    end
    
    if params[:form_buscar_matriculaciones_educacion_inclusiva_matricula_inicial_especial].present?

      cond << "matricula_inicial_especial #{params[:form_buscar_matriculaciones_educacion_inclusiva_matricula_inicial_especial_operador]} ?"
      args << params[:form_buscar_matriculaciones_educacion_inclusiva_matricula_inicial_especial]

    end
    if params[:form_buscar_matriculaciones_educacion_inclusiva_matricula_primer_y_segundo_ciclo_especial].present?

      cond << "matricula_primer_y_segundo_ciclo_especial #{params[:form_buscar_matriculaciones_educacion_inclusiva_matricula_primer_y_segundo_ciclo_especial_operador]} ?"
      args << params[:form_buscar_matriculaciones_educacion_inclusiva_matricula_primer_y_segundo_ciclo_especial]

    end
    
    if params[:form_buscar_matriculaciones_educacion_inclusiva_matricula_tercer_ciclo_especial].present?

      cond << "matricula_tercer_ciclo_especial #{params[:form_buscar_matriculaciones_educacion_inclusiva_matricula_tercer_ciclo_especial_operador]} ?"
      args << params[:form_buscar_matriculaciones_educacion_inclusiva_matricula_tercer_ciclo_especial]

    end
    if params[:form_buscar_matriculaciones_educacion_inclusiva_matricula_programas_especiales].present?

      cond << "matricula_programas_especiales #{params[:form_buscar_matriculaciones_educacion_inclusiva_matricula_programas_especiales_operador]} ?"
      args << params[:form_buscar_matriculaciones_educacion_inclusiva_matricula_programas_especiales]

    end
    
    cond = cond.join(" and ").lines.to_a + args if cond.size > 0
    
    if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
      @matriculaciones_educacion_inclusiva = MatriculacionEducacionInclusiva.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond).paginate(page: params[:page], per_page: 15)
    else
      @matriculaciones_educacion_inclusiva = MatriculacionEducacionInclusiva.orden_dep_dis.where(cond).paginate(page: params[:page], per_page: 15)
    end

    @total_registros = MatriculacionEducacionInclusiva.count 

    if params[:format] == 'csv'

      require 'csv'
      
      if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
        matriculaciones_educacion_inclusiva_csv = MatriculacionEducacionInclusiva.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond)
      else
        matriculaciones_educacion_inclusiva_csv = MatriculacionEducacionInclusiva.orden_dep_dis.where(cond)
      end
    
      csv = CSV.generate do |csv|
        # header row
        csv << ["anio", "codigo_establecimiento", "codigo_departamento", "nombre_departamento", "codigo_distrito", "nombre_distrito", "codigo_zona", 
          "nombre_zona", "codigo_barrio_localidad","nombre_barrio_localidad", "codigo_institucion", "nombre_institucion", "sector_o_tipo_gestion", 
          "matricula_inicial_especial", "matricula_primer_y_segundo_ciclo_especial", "matricula_tercer_ciclo_especial", 
          "matricula_programas_especiales", "anho_cod_geo" ]
 
        # data rows
        matriculaciones_educacion_inclusiva_csv.each do |e|
          csv << [e.anio, e.codigo_establecimiento, e.codigo_departamento, e.nombre_departamento, e.codigo_distrito, e.nombre_distrito, e.codigo_zona, 
            e.nombre_zona, e.codigo_barrio_localidad,e.nombre_barrio_localidad, e.codigo_institucion, e.nombre_institucion, e.sector_o_tipo_gestion, 
            e.matricula_inicial_especial, e.matricula_primer_y_segundo_ciclo_especial, e.matricula_tercer_ciclo_especial, 
            e.matricula_programas_especiales, e.anho_cod_geo ]
       
        end

      end
    
      send_data(csv, :type => 'text/csv', :filename => "matriculaciones_educacion_inclusiva_#{Time.now.strftime('%Y%m%d')}.csv")

    elsif params[:format] == 'xlsx'
      
      if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
        @matriculaciones_educacion_inclusiva = MatriculacionEducacionInclusiva.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond)
      else
        @matriculaciones_educacion_inclusiva = MatriculacionEducacionInclusiva.orden_dep_dis.where(cond)
      end

      p = Axlsx::Package.new
      
      p.workbook.add_worksheet(:name => "Matriculaciones EI") do |sheet|
          
        sheet.add_row [:anio, :codigo_establecimiento, :codigo_departamento, :nombre_departamento, :codigo_distrito, :nombre_distrito, :codigo_zona, 
          :nombre_zona, :codigo_barrio_localidad,:nombre_barrio_localidad, :codigo_institucion, :nombre_institucion, :sector_o_tipo_gestion, 
          :matricula_inicial_especial, :matricula_primer_y_segundo_ciclo_especial, :matricula_tercer_ciclo_especial, 
          :matricula_programas_especiales, :anho_cod_geo]

        @matriculaciones_educacion_inclusiva.each do |m|
            
          sheet.add_row [m.anio, m.codigo_establecimiento, m.codigo_departamento, m.nombre_departamento, m.codigo_distrito, m.nombre_distrito, m.codigo_zona, 
            m.nombre_zona, m.codigo_barrio_localidad,m.nombre_barrio_localidad, m.codigo_institucion, m.nombre_institucion, m.sector_o_tipo_gestion, 
            m.matricula_inicial_especial, m.matricula_primer_y_segundo_ciclo_especial, m.matricula_tercer_ciclo_especial, 
            m.matricula_programas_especiales, m.anho_cod_geo]

        end

      end
      
      p.use_shared_strings = true
      
      send_data p.to_stream.read, filename: "matriculaciones_educacion_inclusiva_#{Time.now.strftime('%d%m%Y__%H%M')}.xlsx", :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet", disposition: 'attachment'

    elsif params[:format] == 'pdf'

      report = ThinReports::Report.new layout: File.join(Rails.root, 'app', 'reports', 'matriculaciones_educacion_inclusiva.tlf')
      
      if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
        matriculaciones_educacion_inclusiva = MatriculacionEducacionInclusiva.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond)
      else
        matriculaciones_educacion_inclusiva = MatriculacionEducacionInclusiva.orden_dep_dis.where(cond)
      end
      
      report.start_new_page do |page|
      
        page.item(:fecha_hora).value("Fecha y Hora: #{Time.now.strftime('%d/%m/%Y - %H:%M')}")
    
      end

      matriculaciones_educacion_inclusiva.each do |e|
      
        report.list(:matriculaciones_educacion_inclusiva).add_row do |row|

          row.values  anio: e.anio, 
            codigo_establecimiento: e.codigo_establecimiento.to_s, 
            codigo_departamento: e.codigo_departamento.to_s, 
            nombre_departamento: e.nombre_departamento.to_s, 
            codigo_distrito: e.codigo_distrito.to_s, 
            nombre_distrito: e.nombre_distrito, 
            codigo_zona: e.codigo_zona.to_s, 
            nombre_zona: e.nombre_zona.to_s, 
            codigo_barrio_localidad: e.codigo_barrio_localidad.to_s,
            nombre_barrio_localidad: e.nombre_barrio_localidad.to_s, 
            codigo_institucion: e.codigo_institucion.to_s, 
            nombre_institucion: e.nombre_institucion.to_s, 
            sector_o_tipo_gestion: e.sector_o_tipo_gestion.to_s, 
            matricula_inicial_especial: e.matricula_inicial_especial.to_s, 
            matricula_primer_y_segundo_ciclo_especial: e.matricula_primer_y_segundo_ciclo_especial.to_s, 
            matricula_tercer_ciclo_especial: e.matricula_tercer_ciclo_especial.to_s, 
            matricula_programas_especiales: e.matricula_programas_especiales.to_s
                        
        end

      end


      send_data report.generate, filename: "matriculaciones_educacion_inclusiva_#{Time.now.strftime('%d%m%Y__%H%M')}.pdf", 
        type: 'application/pdf', 
        disposition: 'attachment'

    else
      
      if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
        @matriculaciones_educacion_inclusiva_todos = MatriculacionEducacionInclusiva.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond)
      else
        @matriculaciones_educacion_inclusiva_todos = MatriculacionEducacionInclusiva.orden_dep_dis.where(cond)
      end
      
      respond_to do |f|
        f.js
        f.json {render :json => @matriculaciones_educacion_inclusiva_todos }
   
      end 

    end

  end

end
