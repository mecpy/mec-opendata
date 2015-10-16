class RequerimientosOtrosEspaciosController < ApplicationController
  before_filter :redireccionar_uri

  def index

    @requerimientos_otros_espacios = VRequerimientoOtroEspacio.orden_dep_dis.paginate :per_page => 15, :page => params[:page]

    respond_to do |f|

      f.html {render :layout => 'application'}

    end

  end
  
  def diccionario
    
    require 'json'
    file = File.read("#{Rails.root}/app/assets/javascripts/diccionario/requerimientos_otros_espacios.json")
    diccionario = JSON.parse(file)
    @diccionario_requerimientos_otros_espacios = clean_json(diccionario)

    if params[:format] == 'json'
      
      generate_json_table_schema(@diccionario_requerimientos_otros_espacios)

    elsif params[:format] == 'pdf'
      
      send_data(generate_pdf(@diccionario_requerimientos_otros_espacios, params[:nombre]), :filename => "diccionario_requerimientos_otros_espacios.pdf", :type => "application/pdf")

    end

  end

  def lista

    cond = []
    args = []
    estados = []

    if params[:form_buscar_requerimientos_otros_espacios] && params[:form_buscar_requerimientos_otros_espacios][:periodo].present? #OK

      cond << "periodo = ?"
      args << params[:form_buscar_requerimientos_otros_espacios][:periodo]

    end
    
    if params[:form_buscar_requerimientos_otros_espacios_numero_prioridad].present? #OK

      cond << "numero_prioridad = ?"
      args << params[:form_buscar_requerimientos_otros_espacios_numero_prioridad]

    end
    
    if params[:form_buscar_requerimientos_otros_espacios_codigo_establecimiento].present? #OK

      cond << "codigo_establecimiento ilike ?"
      args << "%#{params[:form_buscar_requerimientos_otros_espacios_codigo_establecimiento]}%"

    end
    
    if params[:form_buscar_requerimientos_otros_espacios_codigo_institucion].present? #OK

      cond << "codigo_institucion ilike ?"
      args << "%#{params[:form_buscar_requerimientos_otros_espacios_codigo_institucion]}%"

    end
    
    if params[:form_buscar_requerimientos_otros_espacios_nombre_institucion].present? #OK

      cond << "nombre_institucion ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_requerimientos_otros_espacios_nombre_institucion])}%"

    end

    if params[:form_buscar_requerimientos_otros_espacios_nombre_departamento].present? #OK

      cond << "nombre_departamento ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_requerimientos_otros_espacios_nombre_departamento])}%"

    end

    if params[:form_buscar_requerimientos_otros_espacios_nombre_distrito].present? #OK

      cond << "nombre_distrito ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_requerimientos_otros_espacios_nombre_distrito])}%"

    end
    
    if params[:form_buscar_requerimientos_otros_espacios][:nombre_zona].present?

      cond << "nombre_zona = ?"
      args << "#{params[:form_buscar_requerimientos_otros_espacios][:nombre_zona]}"

    end

    if params[:form_buscar_requerimientos_otros_espacios_nivel_educativo_beneficiado].present?

      cond << "nivel_educativo_beneficiado ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_requerimientos_otros_espacios_nivel_educativo_beneficiado])}%"

    end
    
    if params[:form_buscar_requerimientos_otros_espacios_cuenta_espacio_para_construccion].present?

      cond << "cuenta_espacio_para_construccion ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_requerimientos_otros_espacios_cuenta_espacio_para_construccion])}%"

    end
    
    if params[:form_buscar_requerimientos_otros_espacios_nombre_espacio].present?

      cond << "nombre_espacio ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_requerimientos_otros_espacios_nombre_espacio])}%"

    end

    if params[:form_buscar_requerimientos_otros_espacios][:tipo_requerimiento_infraestructura].present?

      cond << "tipo_requerimiento_infraestructura = ?"
      args << "#{params[:form_buscar_requerimientos_otros_espacios][:tipo_requerimiento_infraestructura]}"

    end   

    if params[:form_buscar_requerimientos_otros_espacios_cantidad_requerida].present?

      cond << "cantidad_requerida #{params[:form_buscar_requerimientos_otros_espacios_cantidad_requerida_operador]} ?"
      args << params[:form_buscar_requerimientos_otros_espacios_cantidad_requerida]

    end
    
    if params[:form_buscar_requerimientos_otros_espacios_numero_beneficiados].present?

      cond << "numero_beneficiados #{params[:form_buscar_requerimientos_otros_espacios_numero_beneficiados_operador]} ?"
      args << params[:form_buscar_requerimientos_otros_espacios_numero_beneficiados]

    end
    
    if params[:form_buscar_requerimientos_otros_espacios_justificacion].present?

      cond << "justificacion ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_requerimientos_otros_espacios_justificacion])}%"

    end

    cond = cond.join(" and ").lines.to_a + args if cond.size > 0
    
    if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
      @requerimientos_otros_espacios = VRequerimientoOtroEspacio.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond).paginate(page: params[:page], per_page: 15)
    else
      @requerimientos_otros_espacios = VRequerimientoOtroEspacio.orden_dep_dis.where(cond).paginate(page: params[:page], per_page: 15)
    end

    @total_registros = VRequerimientoOtroEspacio.count 

    if params[:format] == 'csv'

      require 'csv'
      
      if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
        requerimientos_otros_espacios_csv = VRequerimientoOtroEspacio.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond).all
      else
        requerimientos_otros_espacios_csv = VRequerimientoOtroEspacio.orden_dep_dis.where(cond).all
      end

      csv = CSV.generate do |csv|
        # header row
        csv << ["periodo", "codigo_departamento", "nombre_departamento", "codigo_distrito", "nombre_distrito","numero_prioridad",
          "codigo_establecimiento", "codigo_institucion","nombre_institucion",
          "codigo_zona", "nombre_zona",
          "nivel_educativo_beneficiado", "cuenta_espacio_para_construccion","nombre_espacio","tipo_requerimiento_infraestructura","cantidad_requerida",
          "numero_beneficiados", "justificacion", "uri_establecimiento", "uri_institucion"
        ]
 
        # data rows
        requerimientos_otros_espacios_csv.each do |i|
          csv << [i.periodo,i.codigo_departamento, i.nombre_departamento, i.codigo_distrito, i.nombre_distrito, i.numero_prioridad,
            i.codigo_establecimiento, i.codigo_institucion, i.nombre_institucion,
            i.codigo_zona,i.nombre_zona,
            i.nivel_educativo_beneficiado, i.cuenta_espacio_para_construccion, i.nombre_espacio, i.tipo_requerimiento_infraestructura, i.cantidad_requerida,
            i.numero_beneficiados, i.justificacion, i.uri_establecimiento,i.uri_institucion
          ]
        end

      end
    
      send_data(csv, :type => 'text/csv', :filename => "requerimientos_otros_espacios_#{Time.now.strftime('%Y%m%d')}.csv")

    elsif params[:format] == 'xlsx'
      
      if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
        requerimientos_otros_espacios_xlsx = VRequerimientoOtroEspacio.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond).all
      else
        requerimientos_otros_espacios_xlsx = VRequerimientoOtroEspacio.orden_dep_dis.where(cond).all
      end
       
      p = Axlsx::Package.new
        
      p.workbook.add_worksheet(:name => "RequerimientosOtrosEspacios") do |sheet|
          
        sheet.add_row [:periodo, :codigo_departamento, :nombre_departamento, :codigo_distrito, :nombre_distrito, :numero_prioridad, 
          :codigo_establecimiento, :codigo_institucion, :nombre_institucion,
          :codigo_zona,:nombre_zona,
          :nivel_educativo_beneficiado, :cuenta_espacio_para_construccion, :nombre_espacio, :tipo_requerimiento_infraestructura, :cantidad_requerida,
          :numero_beneficiados, :justificacion, :uri_establecimiento, :uri_institucion]

        requerimientos_otros_espacios_xlsx.each do |i|
              
          sheet.add_row [i.periodo,i.codigo_departamento, i.nombre_departamento, i.codigo_distrito, i.nombre_distrito, i.numero_prioridad,
            i.codigo_establecimiento, i.codigo_institucion, i.nombre_institucion,
            i.codigo_zona,i.nombre_zona,
            i.nivel_educativo_beneficiado, i.cuenta_espacio_para_construccion, i.nombre_espacio, i.tipo_requerimiento_infraestructura, i.cantidad_requerida,
            i.numero_beneficiados, i.justificacion, i.uri_establecimiento,i.uri_institucion
          ]
                
        end

      end
            
      p.use_shared_strings = true
      
      send_data p.to_stream.read, filename: "requerimientos_otros_espacios_#{Time.now.strftime('%d%m%Y__%H%M')}.xlsx", :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet", disposition: 'attachment'

    else
      
      if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
        @requerimientos_otros_espacios_todos = VRequerimientoOtroEspacio.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond).all
      else
        @requerimientos_otros_espacios_todos = VRequerimientoOtroEspacio.orden_dep_dis.where(cond).all
      end
      
      respond_to do |f|

        f.js
        f.json {render :json => @requerimientos_otros_espacios_todos,:methods => [:uri_establecimiento, :uri_institucion]}

      end 

    end

  end

end
