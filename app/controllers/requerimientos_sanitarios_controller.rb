class RequerimientosSanitariosController < ApplicationController
    before_filter :redireccionar_uri
  def diccionario

  end

  def index

    @requerimientos_sanitarios = VRequerimientoSanitario.orden_dep_dis.paginate :per_page => 15, :page => params[:page]

    respond_to do |f|

      f.html {render :layout => 'application_wide'}

    end

  end

  def lista

    cond = []
    args = []
    estados = []

    if params[:form_buscar_requerimientos_sanitarios] && params[:form_buscar_requerimientos_sanitarios][:periodo].present? #OK

      cond << "periodo = ?"
      args << params[:form_buscar_requerimientos_sanitarios][:periodo]

    end
    
    if params[:form_buscar_requerimientos_sanitarios_numero_prioridad].present? #OK

      cond << "numero_prioridad = ?"
      args << params[:form_buscar_requerimientos_sanitarios_numero_prioridad]

    end
    
    if params[:form_buscar_requerimientos_sanitarios_codigo_establecimiento].present? #OK

      cond << "codigo_establecimiento ilike ?"
      args << "%#{params[:form_buscar_requerimientos_sanitarios_codigo_establecimiento]}%"

    end
    
    if params[:form_buscar_requerimientos_sanitarios_codigo_institucion].present? #OK

      cond << "codigo_institucion ilike ?"
      args << "%#{params[:form_buscar_requerimientos_sanitarios_codigo_institucion]}%"

    end
    
    if params[:form_buscar_requerimientos_sanitarios_nombre_institucion].present? #OK

      cond << "nombre_institucion ilike ?"
      args << "%#{params[:form_buscar_requerimientos_sanitarios_nombre_institucion]}%"

    end

    if params[:form_buscar_requerimientos_sanitarios_nombre_departamento].present? #OK

      cond << "nombre_departamento ilike ?"
      args << "%#{params[:form_buscar_requerimientos_sanitarios_nombre_departamento]}%"

    end

    if params[:form_buscar_requerimientos_sanitarios_nombre_distrito].present? #OK

      cond << "nombre_distrito ilike ?"
      args << "%#{params[:form_buscar_requerimientos_sanitarios_nombre_distrito]}%"

    end


    if params[:form_buscar_requerimientos_sanitarios_nombre_barrio_localidad].present? #OK

      cond << "nombre_barrio_localidad ilike ?"
      args << "%#{params[:form_buscar_requerimientos_sanitarios_nombre_barrio_localidad]}%"

    end

    if params[:form_buscar_requerimientos_sanitarios_nombre_zona].present? #OK

      cond << "nombre_zona ilike ?"
      args << "%#{params[:form_buscar_requerimientos_sanitarios_nombre_zona]}%"

    end

    if params[:form_buscar_requerimientos_sanitarios_nivel_educativo_beneficiado].present?

      cond << "nivel_educativo_beneficiado ilike ?"
      args << "%#{params[:form_buscar_requerimientos_sanitarios_nivel_educativo_beneficiado]}%"

    end
    
    if params[:form_buscar_requerimientos_sanitarios_abastecimiento_agua].present?

      cond << "abastecimiento_agua ilike ?"
      args << "%#{params[:form_buscar_requerimientos_sanitarios_abastecimiento_agua]}%"

    end
    
    if params[:form_buscar_requerimientos_sanitarios_servicio_sanitario_actual].present?

      cond << "servicio_sanitario_actual ilike ?"
      args << "%#{params[:form_buscar_requerimientos_sanitarios_servicio_sanitario_actual]}%"

    end
    
    if params[:form_buscar_requerimientos_sanitarios_cuenta_espacio_para_construccion].present?

      cond << "cuenta_espacio_para_construccion ilike ?"
      args << "%#{params[:form_buscar_requerimientos_sanitarios_cuenta_espacio_para_construccion]}%"

    end
    
    if params[:form_buscar_requerimientos_sanitarios][:tipo_requerimiento_infraestructura].present?

      cond << "tipo_requerimiento_infraestructura = ?"
      args << "#{params[:form_buscar_requerimientos_sanitarios][:tipo_requerimiento_infraestructura]}"

    end   

    if params[:form_buscar_requerimientos_sanitarios_cantidad_requerida].present?

      cond << "cantidad_requerida = ?"
      args << params[:form_buscar_requerimientos_sanitarios_cantidad_requerida]

    end

    if params[:form_buscar_requerimientos_sanitarios_justificacion].present?

      cond << "justificacion ilike ?"
      args << "%#{params[:form_buscar_requerimientos_sanitarios_justificacion]}%"

    end

    if params[:form_buscar_requerimientos_sanitarios_numero_beneficiados].present?

      cond << "numero_beneficiados = ?"
      args << params[:form_buscar_requerimientos_sanitarios_numero_beneficiados]

    end

    cond = cond.join(" and ").lines.to_a + args if cond.size > 0

    @requerimientos_sanitarios = cond.size > 0 ? (VRequerimientoSanitario.orden_dep_dis.paginate :conditions => cond, 
                                                                               :per_page => 15,
                                                                               :page => params[:page]) : {}

    @total_registros = VRequerimientoSanitario.count 

    if params[:format] == 'csv'

      require 'csv'

      requerimientos_sanitarios_csv = VRequerimientoSanitario.orden_dep_dis.find(:all, :conditions => cond)

      csv = CSV.generate do |csv|
        # header row
        csv << ["periodo", "numero_prioridad","codigo_establecimiento", "codigo_institucion","nombre_institucion",
          "codigo_departamento", "nombre_departamento", "codigo_distrito", "nombre_distrito", "codigo_barrio_localidad", "nombre_barrio_localidad", "codigo_zona", "nombre_zona",
          "nivel_educativo_beneficiado", "abastecimiento_agua", "servicio_sanitario_actual", 
          "cuenta_espacio_para_construccion","tipo_requerimiento_infraestructura","cantidad_requerida",
          "justificacion","numero_beneficiados"
          ]
        # data rows
        requerimientos_sanitarios_csv.each do |i|
          csv << [i.periodo, i.numero_prioridad, i.codigo_establecimiento, i.codigo_institucion, i.nombre_institucion,
            i.codigo_departamento, i.nombre_departamento, i.codigo_distrito, i.nombre_distrito,i.codigo_barrio_localidad,i.nombre_barrio_localidad,i.codigo_zona,i.nombre_zona,
            i.nivel_educativo_beneficiado, i.abastecimiento_agua, i.servicio_sanitario_actual,
            i.cuenta_espacio_para_construccion, i.tipo_requerimiento_infraestructura, i.cantidad_requerida,
            i.justificacion, i.numero_beneficiados  
          ]
        end

      end
    
      send_data(csv, :type => 'text/csv', :filename => "requerimientos_sanitarios_#{Time.now.strftime('%Y%m%d')}.csv")

    elsif params[:format] == 'xlsx'
      
      @requerimientos_sanitarios = VRequerimientoSanitario.orden_dep_dis.find(:all, :conditions => cond)

      respond_to do |format|
      
        format.xlsx {

          columnas = [:periodo, :numero_prioridad, :codigo_establecimiento, :codigo_institucion, :nombre_institucion,
            :codigo_departamento, :nombre_departamento, :codigo_distrito, :nombre_distrito,:codigo_barrio_localidad,:nombre_barrio_localidad,:codigo_zona,:nombre_zona,
            :nivel_educativo_beneficiado, :abastecimiento_agua, :servicio_sanitario_actual,
            :cuenta_espacio_para_construccion, :tipo_requerimiento_infraestructura, :cantidad_requerida,
            :justificacion, :numero_beneficiados  ]
         
          send_data VRequerimientoSanitario.orden_dep_dis.where(cond).to_xlsx(:columns => columnas).to_stream.read, 
                    :filename => "requerimientos_sanitarios_#{Time.now.strftime('%d%m%Y__%H%M')}.xlsx", 
                    :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet", 
                    disposition: 'attachment'
        }
      
      end

    else

      @requerimientos_sanitarios_todos = VRequerimientoSanitario.orden_dep_dis.find(:all, :conditions => cond)
      
      respond_to do |f|

        f.js
        f.json {render :json => @requerimientos_sanitarios_todos }

      end 

    end

  end

end
