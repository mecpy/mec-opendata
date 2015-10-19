class RegistrosTitulosController < ApplicationController
  
  def index
    
    @registros_titulos = RegistroTitulo.orden_anio_mes.paginate :per_page => 15, :page => params[:page]
    
    respond_to do |f|

      f.html {render :layout => 'layouts/application'}
    
    end

  end
  
  def diccionario
    
    require 'json'
    file = File.read("#{Rails.root}/app/assets/javascripts/diccionario/registros_titulos.json")
    diccionario = JSON.parse(file)
    @diccionario_registros_titulos = clean_json(diccionario)

    if params[:format] == 'json'
      
      generate_json_table_schema(@diccionario_registros_titulos)

    elsif params[:format] == 'pdf'
      
      send_data(generate_pdf(@diccionario_registros_titulos, params[:nombre]), :filename => "diccionario_registros_titulos.pdf", :type => "application/pdf")

    end

  end

  def lista

    cond = []
    args = []
    estados = []

    if params[:form_buscar_registros_titulos] && params[:form_buscar_registros_titulos][:anio].present?

      cond << "anio = ?"
      args << params[:form_buscar_registros_titulos][:anio]

    end

    if params[:form_buscar_registros_titulos] && params[:form_buscar_registros_titulos][:mes].present?

      cond << "mes = ?"
      args << params[:form_buscar_registros_titulos][:mes]

    end

    if params[:form_buscar_registros_titulos_documento].present?

      cond << "documento = ?"
      args << params[:form_buscar_registros_titulos_documento]

    end

    if params[:form_buscar_registros_titulos_nombre_completo].present?

      cond << "nombre_completo ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_registros_titulos_nombre_completo])}%"

    end

    if params[:form_buscar_registros_titulos_carrera].present?

      cond << "carrera ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_registros_titulos_carrera])}%"

    end

    if params[:form_buscar_registros_titulos_titulo].present?

      cond << "titulo ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_registros_titulos_titulo])}%"

    end

    if params[:form_buscar_registros_titulos_numero_resolucion].present?

      cond << "numero_resolucion ilike ?"
      args << "%#{params[:form_buscar_registros_titulos_numero_resolucion]}%"

    end

    if params[:form_buscar_registros_titulos_fecha_resolucion].present?

      cond << "fecha_resolucion = ?"
      args << params[:form_buscar_registros_titulos_fecha_resolucion]

    end

    if params[:form_buscar_registros_titulos_institucion].present?

      cond << "institucion ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_registros_titulos_institucion])}%"

    end

    if params[:form_buscar_registros_titulos_tipo_institucion].present?

      cond << "tipo_institucion ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_registros_titulos_tipo_institucion])}%"

    end

    if params[:form_buscar_registros_titulos] && params[:form_buscar_registros_titulos][:gobierno_actual].present?

      if params[:form_buscar_registros_titulos][:gobierno_actual] == '2'

        cond << "((anio = 2013 and mes > 7) or (anio > 2013))"
      
      elsif params[:form_buscar_registros_titulos][:gobierno_actual] == '3'
 
        cond << "((anio = 2013 and mes < 8) or (anio < 2013))"

      end

    end

    if params[:form_buscar_registros_titulos][:sexo].present?

      cond << "sexo = ?"
      args << "#{params[:form_buscar_registros_titulos][:sexo]}"

    end

    cond = cond.join(" and ").lines.to_a + args if cond.size > 0
    
    if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
      @registros_titulos = RegistroTitulo.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond).paginate(page: params[:page], per_page: 15)
    else
      @registros_titulos = RegistroTitulo.orden_anio_mes.where(cond).paginate(page: params[:page], per_page: 15)
    end

    @registros_titulos_todos = RegistroTitulo.orden_anio_mes.where(cond)
    @total_registros = RegistroTitulo.count 

    if params[:format] == 'csv'

      require 'csv'
      
      if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
        registros_titulos_csv = RegistroTitulo.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond)
      else
        registros_titulos_csv = RegistroTitulo.orden_anio_mes.where(cond)
      end

      csv = CSV.generate do |csv|
        # header row
        csv << ["anio", "mes", "documento", "nombre_completo", "carrera_id", "carrera", "titulo_id", "titulo", "numero_resolucion", "fecha_resolucion", "tipo_institucion_id", "tipo_institucion", "institucion_id","institucion", "gobierno_actual", "sexo" ]
 
        # data rows
        registros_titulos_csv.each do |rt|
          csv << [rt.anio, rt.mes, rt.documento, rt.nombre_completo, rt.carrera_id, rt.carrera, rt.titulo_id, rt.titulo, rt.numero_resolucion, rt.fecha_resolucion, rt.tipo_institucion_id, rt.tipo_institucion, rt.institucion_id, rt.institucion, rt.gobierno_actual, rt.sexo ]
        end

      end
    
      send_data(csv, :type => 'text/csv', :filename => "registros_titulos_#{Time.now.strftime('%Y%m%d')}.csv")

    elsif params[:format] == 'xlsx'
      
      if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
        registros_titulos_xls = RegistroTitulo.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond)
      else
        registros_titulos_xls = RegistroTitulo.orden_anio_mes.where(cond)
      end
       
      p = Axlsx::Package.new
        
      p.workbook.add_worksheet(:name => "RegistroTitulo") do |sheet|
          
        sheet.add_row ["anio", "mes", "documento", "nombre_completo", "carrera_id", "carrera", "titulo_id", "titulo", "numero_resolucion", "fecha_resolucion", "tipo_institucion_id", "tipo_institucion", "institucion_id","institucion", "gobierno_actual", "sexo" ]

        registros_titulos_xls.each do |rt|
              
          sheet.add_row [rt.anio, rt.mes, rt.documento, rt.nombre_completo, rt.carrera_id, rt.carrera, rt.titulo_id, rt.titulo, rt.numero_resolucion, rt.fecha_resolucion, rt.tipo_institucion_id, rt.tipo_institucion, rt.institucion_id, rt.institucion, rt.gobierno_actual, rt.sexo ]
                
        end

      end
            
      p.use_shared_strings = true
      
      send_data p.to_stream.read, filename: "registros_titulos_#{Time.now.strftime('%d%m%Y__%H%M')}.xlsx", :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet", disposition: 'attachment'

    elsif params[:format] == 'pdf'

      report = ThinReports::Report.new layout: File.join(Rails.root, 'app', 'reports', 'registros_titulos.tlf')
      
      if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
        registros_titulos_pdf = RegistroTitulo.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond)
      else
        registros_titulos_pdf = RegistroTitulo.orden_anio_mes.where(cond)
      end
     
      report.start_new_page do |page|
      
        page.item(:fecha_hora).value("Fecha y Hora: #{Time.now.strftime('%d/%m/%Y - %H:%M')}")
    
      end

      registros_titulos_pdf.each do |rt|
      
        report.list(:registros_titulos).add_row do |row|

          row.values  anio: rt.anio,
            mes: rt.mes,        
            documento: rt.documento,       
            nombre_completo: rt.nombre_completo ,       
            carrera: rt.carrera,       
            titulo: rt.titulo,       
            institucion: rt.institucion

        end

      end


      send_data report.generate, filename: "registros_titulos_#{Time.now.strftime('%d%m%Y__%H%M')}.pdf", 
        type: 'application/pdf', 
        disposition: 'attachment'

    elsif params[:format] == 'md5_csv'
      
      filename = "registros_titulos"
      path_file = "#{Rails.root}/public/data/" + filename + ".csv.zip"
      send_data(generate_md5(path_file), :filename => filename+".md5", :type => "application/txt")

    else
      
      if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
        @registros_titulos_json = RegistroTitulo.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond)
      else
        @registros_titulos_json = RegistroTitulo.orden_anio_mes.where(cond)
      end

      respond_to do |f|

        f.js
        f.json {render :json => @registros_titulos_json , :methods => :gobierno_actual}

      end 

    end

  end

end
