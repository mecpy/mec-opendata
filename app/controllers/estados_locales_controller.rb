class EstadosLocalesController < ApplicationController
    before_filter :redireccionar_uri
  def diccionario

  end

  def index

    @estados_locales = VEstadoLocal.orden_dep_dis.paginate :per_page => 15, :page => params[:page]

    respond_to do |f|

      f.html {render :layout => 'application_wide'}

    end

  end

  def lista

    cond = []
    args = []
    estados = []

    if params[:form_buscar_estados_locales] && params[:form_buscar_estados_locales][:periodo].present? #OK

      cond << "periodo = ?"
      args << params[:form_buscar_estados_locales][:periodo]

    end
    
    if params[:form_buscar_estados_locales_codigo_establecimiento].present? #OK

      cond << "codigo_establecimiento ilike ?"
      args << "%#{params[:form_buscar_estados_locales_codigo_establecimiento]}%"

    end

    if params[:form_buscar_estados_locales_nombre_departamento].present? #OK

      cond << "nombre_departamento ilike ?"
      args << "%#{params[:form_buscar_estados_locales_nombre_departamento]}%"

    end

    if params[:form_buscar_estados_locales_nombre_distrito].present? #OK

      cond << "nombre_distrito ilike ?"
      args << "%#{params[:form_buscar_estados_locales_nombre_distrito]}%"

    end
    
    if params[:form_buscar_estados_locales_nombre_barrio_localidad].present? #OK

      cond << "nombre_barrio_localidad ilike ?"
      args << "%#{params[:form_buscar_estados_locales_nombre_barrio_localidad]}%"

    end

    if params[:form_buscar_estados_locales_nombre_zona].present? #OK

      cond << "nombre_zona ilike ?"
      args << "%#{params[:form_buscar_estados_locales_nombre_zona]}%"

    end
    
    if params[:form_buscar_estados_locales_nombre_asentamiento_colonia].present? #OK

      cond << "nombre_asentamiento_colonia ilike ?"
      args << "%#{params[:form_buscar_estados_locales_nombre_asentamiento_colonia]}%"

    end
    
    if params[:form_buscar_estados_locales_suministro_energia_electrica].present? #OK

      cond << "suministro_energia_electrica ilike ?"
      args << "%#{params[:form_buscar_estados_locales_suministro_energia_electrica]}%"

    end
    
    if params[:form_buscar_estados_locales_abastecimiento_agua].present? #OK

      cond << "abastecimiento_agua ilike ?"
      args << "%#{params[:form_buscar_estados_locales_abastecimiento_agua]}%"

    end
    
    if params[:form_buscar_estados_locales_servicio_sanitario_actual].present? #OK

      cond << "servicio_sanitario_actual ilike ?"
      args << "%#{params[:form_buscar_estados_locales_servicio_sanitario_actual]}%"

    end
    
    if params[:form_buscar_estados_locales_titulo_de_propiedad].present? #OK

      cond << "titulo_de_propiedad ilike ?"
      args << "%#{params[:form_buscar_estados_locales_titulo_de_propiedad]}%"

    end
    
    if params[:form_buscar_estados_locales_cuenta_plano].present? #OK

      cond << "cuenta_plano ilike ?"
      args << "%#{params[:form_buscar_estados_locales_cuenta_plano]}%"

    end
    
    if params[:form_buscar_estados_locales_prevencion_incendio].present? #OK

      cond << "prevencion_incendio ilike ?"
      args << "%#{params[:form_buscar_estados_locales_prevencion_incendio]}%"

    end

    cond = cond.join(" and ").lines.to_a + args if cond.size > 0

    @estados_locales = cond.size > 0 ? (VEstadoLocal.orden_dep_dis.paginate :conditions => cond, 
                                                                               :per_page => 15,
                                                                               :page => params[:page]) : {}
                                               
    @total_registros = VEstadoLocal.count 

    if params[:format] == 'csv'

      require 'csv'

      estados_locales_csv = VEstadoLocal.orden_dep_dis.find(:all, :conditions => cond)

      csv = CSV.generate do |csv|
        # header row
        csv << ["periodo", "codigo_departamento", "nombre_departamento", "codigo_distrito", "nombre_distrito",
          "codigo_establecimiento","codigo_barrio_localidad", "nombre_barrio_localidad",
          "codigo_zona", "nombre_zona",
          "nombre_asentamiento_colonia", "suministro_energia_electrica","abastecimiento_agua","servicio_sanitario_actual",
          "titulo_de_propiedad","cuenta_plano","prevencion_incendio","uri_establecimiento"
          ]
 
        # data rows
        estados_locales_csv.each do |i|
          csv << [i.periodo, i.codigo_departamento, i.nombre_departamento, i.codigo_distrito, i.nombre_distrito,
            i.codigo_establecimiento, i.codigo_barrio_localidad, i.nombre_barrio_localidad,
            i.codigo_zona,i.nombre_zona,
            i.nombre_asentamiento_colonia, i.suministro_energia_electrica, i.abastecimiento_agua, i.servicio_sanitario_actual,
            i.titulo_de_propiedad, i.cuenta_plano,i.prevencion_incendio,i.uri_establecimiento
          ]
        end

      end
    
      send_data(csv, :type => 'text/csv', :filename => "estados_locales_#{Time.now.strftime('%Y%m%d')}.csv")

    elsif params[:format] == 'xlsx'
      
      @estados_locales = VEstadoLocal.orden_dep_dis.find(:all, :conditions => cond)

      respond_to do |format|
      
        format.xlsx {

          columnas = [:periodo, :codigo_departamento, :nombre_departamento, :codigo_distrito, :nombre_distrito,
            :codigo_establecimiento, :codigo_barrio_localidad, :nombre_barrio_localidad,
            :codigo_zona,:nombre_zona,
            :nombre_asentamiento_colonia, :suministro_energia_electrica, :abastecimiento_agua, :servicio_sanitario_actual,
            :titulo_de_propiedad, :cuenta_plano, :prevencion_incendio, :uri_establecimiento]
         
          send_data VEstadoLocal.orden_dep_dis.where(cond).to_xlsx(:columns => columnas).to_stream.read, 
                    :filename => "estados_locales_#{Time.now.strftime('%d%m%Y__%H%M')}.xlsx", 
                    :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet", 
                    disposition: 'attachment'
        }
      
      end

    else

      @estados_locales_todos = VEstadoLocal.orden_dep_dis.find(:all, :conditions => cond)
      
      respond_to do |f|

        f.js
        f.json {render :json => @estados_locales_todos, :methods => :uri_establecimiento}

      end 

    end

  end

end
