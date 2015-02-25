class RequerimientosMobiliariosController < ApplicationController
  before_filter :redireccionar_uri

  def index

    @requerimientos_mobiliarios = VRequerimientoMobiliario.orden_dep_dis.paginate :per_page => 15, :page => params[:page]

    respond_to do |f|

      f.html {render :layout => 'application'}

    end

  end
  
  def diccionario
    
    require 'json'
    file = File.read("#{Rails.root}/app/assets/javascripts/diccionario/requerimientos_mobiliarios.json")
    @diccionario_requerimientos_mobiliarios = JSON.parse(file)

  end

  def lista

    cond = []
    args = []
    estados = []

    if params[:form_buscar_requerimientos_mobiliarios] && params[:form_buscar_requerimientos_mobiliarios][:periodo].present? #OK

      cond << "periodo = ?"
      args << params[:form_buscar_requerimientos_mobiliarios][:periodo]

    end
    
    if params[:form_buscar_requerimientos_mobiliarios_numero_prioridad].present? #OK

      cond << "numero_prioridad = ?"
      args << params[:form_buscar_requerimientos_mobiliarios_numero_prioridad]

    end
    
    if params[:form_buscar_requerimientos_mobiliarios_codigo_establecimiento].present? #OK

      cond << "codigo_establecimiento ilike ?"
      args << "%#{params[:form_buscar_requerimientos_mobiliarios_codigo_establecimiento]}%"

    end
    
    if params[:form_buscar_requerimientos_mobiliarios_codigo_institucion].present? #OK

      cond << "codigo_institucion ilike ?"
      args << "%#{params[:form_buscar_requerimientos_mobiliarios_codigo_institucion]}%"

    end
    
    if params[:form_buscar_requerimientos_mobiliarios_nombre_institucion].present? #OK

      cond << "nombre_institucion ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_requerimientos_mobiliarios_nombre_institucion])}%"

    end

    if params[:form_buscar_requerimientos_mobiliarios_nombre_departamento].present? #OK

      cond << "nombre_departamento ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_requerimientos_mobiliarios_nombre_departamento])}%"

    end

    if params[:form_buscar_requerimientos_mobiliarios_nombre_distrito].present? #OK

      cond << "nombre_distrito ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_requerimientos_mobiliarios_nombre_distrito])}%"

    end
    
    if params[:form_buscar_requerimientos_mobiliarios][:nombre_zona].present?

      cond << "nombre_zona = ?"
      args << "#{params[:form_buscar_requerimientos_mobiliarios][:nombre_zona]}"

    end

    if params[:form_buscar_requerimientos_mobiliarios_nivel_educativo_beneficiado].present?

      cond << "nivel_educativo_beneficiado ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_requerimientos_mobiliarios_nivel_educativo_beneficiado])}%"

    end
    
    if params[:form_buscar_requerimientos_mobiliarios_nombre_mobiliario].present?

      cond << "nombre_mobiliario ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_requerimientos_mobiliarios_nombre_mobiliario])}%"

    end
    
    if params[:form_buscar_requerimientos_mobiliarios_cantidad_requerida].present?

      cond << "cantidad_requerida #{params[:form_buscar_requerimientos_mobiliarios_cantidad_requerida_operador]} ?"
      args << params[:form_buscar_requerimientos_mobiliarios_cantidad_requerida]

    end

    if params[:form_buscar_requerimientos_mobiliarios_justificacion].present?

      cond << "justificacion ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_requerimientos_mobiliarios_justificacion])}%"

    end
    
    if params[:form_buscar_requerimientos_mobiliarios_numero_beneficiados].present?

      cond << "numero_beneficiados #{params[:form_buscar_requerimientos_mobiliarios_numero_beneficiados_operador]} ?"
      args << params[:form_buscar_requerimientos_mobiliarios_numero_beneficiados]

    end

    cond = cond.join(" and ").lines.to_a + args if cond.size > 0
    
    if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
      @requerimientos_mobiliarios = VRequerimientoMobiliario.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond).paginate(page: params[:page], per_page: 15)
    else
      @requerimientos_mobiliarios = VRequerimientoMobiliario.orden_dep_dis.where(cond).paginate(page: params[:page], per_page: 15)
    end

    @total_registros = VRequerimientoMobiliario.count 

    if params[:format] == 'csv'

      require 'csv'
      
      if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
        requerimientos_mobiliarios_csv = VRequerimientoMobiliario.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond).all
      else
        requerimientos_mobiliarios_csv = VRequerimientoMobiliario.orden_dep_dis.where(cond).all
      end

      csv = CSV.generate do |csv|
        # header row
        csv << ["periodo", "codigo_departamento", "nombre_departamento", "codigo_distrito", "nombre_distrito", "numero_prioridad",
          "codigo_establecimiento", "codigo_institucion","nombre_institucion",
          "codigo_zona", "nombre_zona",
          "nivel_educativo_beneficiado", "nombre_mobiliario","cantidad_requerida",
          "numero_beneficiados", "justificacion", "uri_establecimiento", "uri_institucion"
        ]
 
        # data rows
        requerimientos_mobiliarios_csv.each do |i|
          csv << [i.periodo, i.codigo_departamento, i.nombre_departamento, i.codigo_distrito, i.nombre_distrito,i.numero_prioridad, 
            i.codigo_establecimiento, i.codigo_institucion, i.nombre_institucion,
            i.codigo_zona,i.nombre_zona,
            i.nivel_educativo_beneficiado, i.nombre_mobiliario, i.cantidad_requerida,
            i.numero_beneficiados, i.justificacion,i.uri_establecimiento,i.uri_institucion
          ]
        end

      end
    
      send_data(csv, :type => 'text/csv', :filename => "requerimientos_mobiliarios_#{Time.now.strftime('%Y%m%d')}.csv")

    elsif params[:format] == 'xlsx'
      
      if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
        requerimientos_mobiliarios_xlsx = VRequerimientoMobiliario.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond).all
      else
        requerimientos_mobiliarios_xlsx = VRequerimientoMobiliario.orden_dep_dis.where(cond).all
      end
       
      p = Axlsx::Package.new
        
      p.workbook.add_worksheet(:name => "RequerimientosMobiliarios") do |sheet|
          
        sheet.add_row [:periodo, :codigo_departamento, :nombre_departamento, :codigo_distrito, :nombre_distrito,:numero_prioridad,
          :codigo_establecimiento, :codigo_institucion, :nombre_institucion,
          :codigo_zona,:nombre_zona,
          :nivel_educativo_beneficiado, :nombre_mobiliario, :cantidad_requerida,
          :numero_beneficiados, :justificacion, :uri_establecimiento, :uri_institucion]

        requerimientos_mobiliarios_xlsx.each do |i|
              
          sheet.add_row [i.periodo, i.codigo_departamento, i.nombre_departamento, i.codigo_distrito, i.nombre_distrito,i.numero_prioridad, 
            i.codigo_establecimiento, i.codigo_institucion, i.nombre_institucion,
            i.codigo_zona,i.nombre_zona,
            i.nivel_educativo_beneficiado, i.nombre_mobiliario, i.cantidad_requerida,
            i.numero_beneficiados, i.justificacion,i.uri_establecimiento,i.uri_institucion
          ]
                
        end

      end
            
      p.use_shared_strings = true
      
      send_data p.to_stream.read, filename: "requerimientos_mobiliarios_#{Time.now.strftime('%d%m%Y__%H%M')}.xlsx", :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet", disposition: 'attachment'

    else
      
      if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
        @requerimientos_mobiliarios_todos = VRequerimientoMobiliario.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond).all
      else
        @requerimientos_mobiliarios_todos = VRequerimientoMobiliario.orden_dep_dis.where(cond).all
      end
      
      respond_to do |f|

        f.js
        f.json {render :json => @requerimientos_mobiliarios_todos, :methods => [:uri_establecimiento, :uri_institucion]}

      end 

    end

  end

end
