class RequerimientosAlimentacionController < ApplicationController
  before_filter :redireccionar_uri
  def diccionario

  end

  def index

    @requerimientos_alimentacion = VRequerimientoAlimentacion.orden_dep_dis.paginate :per_page => 15, :page => params[:page]

    respond_to do |f|

      f.html {render :layout => 'application_wide'}

    end

  end

  def lista

    cond = []
    args = []
    estados = []

    if params[:form_buscar_requerimientos_alimentacion] && params[:form_buscar_requerimientos_alimentacion][:periodo].present? #OK

      cond << "periodo = ?"
      args << params[:form_buscar_requerimientos_alimentacion][:periodo]

    end
    
    if params[:form_buscar_requerimientos_alimentacion_numero_prioridad].present? #OK

      cond << "numero_prioridad = ?"
      args << params[:form_buscar_requerimientos_alimentacion_numero_prioridad]

    end
    
    if params[:form_buscar_requerimientos_alimentacion_codigo_establecimiento].present? #OK

      cond << "codigo_establecimiento ilike ?"
      args << "%#{params[:form_buscar_requerimientos_alimentacion_codigo_establecimiento]}%"

    end
    
    if params[:form_buscar_requerimientos_alimentacion_codigo_institucion].present? #OK

      cond << "codigo_institucion ilike ?"
      args << "%#{params[:form_buscar_requerimientos_alimentacion_codigo_institucion]}%"

    end
    
    if params[:form_buscar_requerimientos_alimentacion_nombre_institucion].present? #OK

      cond << "nombre_institucion ilike ?"
      args << "%#{params[:form_buscar_requerimientos_alimentacion_nombre_institucion]}%"

    end

    if params[:form_buscar_requerimientos_alimentacion_nombre_departamento].present? #OK

      cond << "nombre_departamento ilike ?"
      args << "%#{params[:form_buscar_requerimientos_alimentacion_nombre_departamento]}%"

    end

    if params[:form_buscar_requerimientos_alimentacion_nombre_distrito].present? #OK

      cond << "nombre_distrito ilike ?"
      args << "%#{params[:form_buscar_requerimientos_alimentacion_nombre_distrito]}%"

    end

    if params[:form_buscar_requerimientos_alimentacion_nombre_zona].present? #OK

      cond << "nombre_zona ilike ?"
      args << "%#{params[:form_buscar_requerimientos_alimentacion_nombre_zona]}%"

    end

    if params[:form_buscar_requerimientos_alimentacion][:espacio_cocina_comedor].present?

      cond << "espacio_cocina_comedor = ?"
      args << "#{params[:form_buscar_requerimientos_alimentacion][:espacio_cocina_comedor]}"

    end
    
    if params[:form_buscar_requerimientos_alimentacion][:doble_escolaridad].present?

      cond << "doble_escolaridad = ?"
      args << "#{params[:form_buscar_requerimientos_alimentacion][:doble_escolaridad]}"

    end
    
    if params[:form_buscar_requerimientos_alimentacion][:porcentaje_ausentismo].present?

      cond << "porcentaje_ausentismo = ?"
      args << "#{params[:form_buscar_requerimientos_alimentacion][:porcentaje_ausentismo]}"

    end
    
    if params[:form_buscar_requerimientos_alimentacion][:tipo_alimentacion_escolar].present?

      cond << "tipo_alimentacion_escolar = ?"
      args << "#{params[:form_buscar_requerimientos_alimentacion][:tipo_alimentacion_escolar]}"

    end
    
    if params[:form_buscar_requerimientos_alimentacion_cantidad_meses_merienda].present? #OK

      cond << "cantidad_meses_merienda = ?"
      args << params[:form_buscar_requerimientos_alimentacion_cantidad_meses_merienda]

    end
    
    if params[:form_buscar_requerimientos_alimentacion][:proveedor_merienda].present?

      cond << "proveedor_merienda = ?"
      args << "#{params[:form_buscar_requerimientos_alimentacion][:proveedor_merienda]}"

    end
    
    if params[:form_buscar_requerimientos_alimentacion][:tipo_merienda].present?

      cond << "tipo_merienda = ?"
      args << "#{params[:form_buscar_requerimientos_alimentacion][:tipo_merienda]}"

    end
    
    if params[:form_buscar_requerimientos_alimentacion_cantidad_meses_almuerzo].present? #OK

      cond << "cantidad_meses_almuerzo = ?"
      args << params[:form_buscar_requerimientos_alimentacion_cantidad_meses_almuerzo]

    end
    
    if params[:form_buscar_requerimientos_alimentacion][:proveedor_almuerzo].present?

      cond << "proveedor_almuerzo = ?"
      args << "#{params[:form_buscar_requerimientos_alimentacion][:proveedor_almuerzo]}"

    end
    
    if params[:form_buscar_requerimientos_alimentacion][:tipo_almuerzo].present?

      cond << "tipo_almuerzo = ?"
      args << "#{params[:form_buscar_requerimientos_alimentacion][:tipo_almuerzo]}"

    end
    
    if params[:form_buscar_requerimientos_alimentacion][:forma_obtencion_almuerzo].present?

      cond << "forma_obtencion_almuerzo = ?"
      args << "#{params[:form_buscar_requerimientos_alimentacion][:forma_obtencion_almuerzo]}"

    end
    
    if params[:form_buscar_requerimientos_alimentacion_numero_beneficiados].present?

      cond << "numero_beneficiados #{params[:form_buscar_requerimientos_alimentacion_numero_beneficiados_operador]} ?"
      args << params[:form_buscar_requerimientos_alimentacion_numero_beneficiados]

    end
    
    if params[:form_buscar_requerimientos_alimentacion_justificacion].present?

      cond << "justificacion ilike ?"
      args << "%#{params[:form_buscar_requerimientos_alimentacion_justificacion]}%"

    end

    cond = cond.join(" and ").lines.to_a + args if cond.size > 0

    @requerimientos_alimentacion = cond.size > 0 ? (VRequerimientoAlimentacion.orden_dep_dis.paginate :conditions => cond, 
      :per_page => 15,
      :page => params[:page]) : {}

    @total_registros = VRequerimientoAlimentacion.count 

    if params[:format] == 'csv'

      require 'csv'

      requerimientos_alimentacion_csv = VRequerimientoAlimentacion.orden_dep_dis.find(:all, :conditions => cond)

      csv = CSV.generate do |csv|
        # header row
        csv << ["periodo", "codigo_departamento", "nombre_departamento", "codigo_distrito", "nombre_distrito","numero_prioridad",
          "codigo_establecimiento", "codigo_institucion","nombre_institucion","codigo_zona", "nombre_zona",
          "espacio_cocina_comedor", "doble_escolaridad","porcentaje_ausentismo", "tipo_alimentacion_escolar",
          "tipo_merienda", "proveedor_merienda", "cantidad_meses_merienda",
          "tipo_almuerzo", "proveedor_almuerzo", "cantidad_meses_almuerzo", "forma_obtencion_almuerzo",
          "numero_beneficiados","justificacion","uri_establecimiento","uri_institucion"
        ]
 
        # data rows
        requerimientos_alimentacion_csv.each do |i|
          csv << [i.periodo,i.codigo_departamento, i.nombre_departamento, i.codigo_distrito, i.nombre_distrito, i.numero_prioridad,
            i.codigo_establecimiento, i.codigo_institucion, i.nombre_institucion,i.codigo_zona,i.nombre_zona,
            i.espacio_cocina_comedor, i.doble_escolaridad, i.porcentaje_ausentismo, i.tipo_alimentacion_escolar,
            i.tipo_merienda, i.proveedor_merienda, i.cantidad_meses_merienda,
            i.tipo_almuerzo, i.proveedor_almuerzo, i.cantidad_meses_almuerzo, i.forma_obtencion_almuerzo,
            i.numero_beneficiados,i.justificacion ,i.uri_establecimiento,i.uri_institucion
          ]
        end

      end
    
      send_data(csv, :type => 'text/csv', :filename => "requerimientos_alimentacion_#{Time.now.strftime('%Y%m%d')}.csv")

    elsif params[:format] == 'xlsx'
      
      @requerimientos_alimentacion = VRequerimientoAlimentacion.orden_dep_dis.find(:all, :conditions => cond)

      respond_to do |format|
      
        format.xlsx {

          columnas = [:periodo, :codigo_departamento, :nombre_departamento, :codigo_distrito, :nombre_distrito, :numero_prioridad,
            :codigo_establecimiento, :codigo_institucion, :nombre_institucion, :codigo_zona,:nombre_zona,
            :espacio_cocina_comedor, :doble_escolaridad,:porcentaje_ausentismo, :tipo_alimentacion_escolar,
            :tipo_merienda, :proveedor_merienda, :cantidad_meses_merienda,
            :tipo_almuerzo, :proveedor_almuerzo, :cantidad_meses_almuerzo, :forma_obtencion_almuerzo,
            :numero_beneficiados,:justificacion,:uri_establecimiento,:uri_institucion]
         
          send_data VRequerimientoAlimentacion.orden_dep_dis.where(cond).to_xlsx(:columns => columnas).to_stream.read, 
          :filename => "requerimientos_alimentacion_#{Time.now.strftime('%d%m%Y__%H%M')}.xlsx", 
          :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet", 
          disposition: 'attachment'
        }
      
      end

    else

      @requerimientos_alimentacion_todos = VRequerimientoAlimentacion.orden_dep_dis.find(:all, :conditions => cond)
      
      respond_to do |f|

        f.js
        f.json {render :json => @requerimientos_alimentacion_todos, :methods => [:uri_establecimiento, :uri_institucion]}

      end 

    end

  end

end
