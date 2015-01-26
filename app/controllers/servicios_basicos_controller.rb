class ServiciosBasicosController < ApplicationController
    #before_filter :redireccionar_uri
  def diccionario

  end

  def index

    @servicios_basicos = VServicioBasico.orden_dep_dis.paginate :per_page => 15, :page => params[:page]

    respond_to do |f|

      f.html {render :layout => 'application_wide'}

    end

  end

  def lista

    cond = []
    args = []
    estados = []

    if params[:form_buscar_servicios_basicos] && params[:form_buscar_servicios_basicos][:periodo].present? #OK

      cond << "periodo = ?"
      args << params[:form_buscar_servicios_basicos][:periodo]

    end
    
    if params[:form_buscar_servicios_basicos_codigo_establecimiento].present? #OK

      cond << "codigo_establecimiento ilike ?"
      args << "%#{params[:form_buscar_servicios_basicos_codigo_establecimiento]}%"

    end

    if params[:form_buscar_servicios_basicos_nombre_departamento].present? #OK

      cond << "nombre_departamento ilike ?"
      args << "%#{params[:form_buscar_servicios_basicos_nombre_departamento]}%"

    end

    if params[:form_buscar_servicios_basicos_nombre_distrito].present? #OK

      cond << "nombre_distrito ilike ?"
      args << "%#{params[:form_buscar_servicios_basicos_nombre_distrito]}%"

    end
    
    if params[:form_buscar_servicios_basicos_nombre_barrio_localidad].present? #OK

      cond << "nombre_barrio_localidad ilike ?"
      args << "%#{params[:form_buscar_servicios_basicos_nombre_barrio_localidad]}%"

    end

    if params[:form_buscar_servicios_basicos_nombre_zona].present? #OK

      cond << "nombre_zona ilike ?"
      args << "%#{params[:form_buscar_servicios_basicos_nombre_zona]}%"

    end
    
    if params[:form_buscar_servicios_basicos_nombre_asentamiento_colonia].present? #OK

      cond << "nombre_asentamiento_colonia ilike ?"
      args << "%#{params[:form_buscar_servicios_basicos_nombre_asentamiento_colonia]}%"

    end
    
    if params[:form_buscar_servicios_basicos_suministro_energia_electrica].present? #OK

      cond << "suministro_energia_electrica ilike ?"
      args << "%#{params[:form_buscar_servicios_basicos_suministro_energia_electrica]}%"

    end
    
    if params[:form_buscar_servicios_basicos_abastecimiento_agua].present? #OK

      cond << "abastecimiento_agua ilike ?"
      args << "%#{params[:form_buscar_servicios_basicos_abastecimiento_agua]}%"

    end
    
    if params[:form_buscar_servicios_basicos_servicio_sanitario_actual].present? #OK

      cond << "servicio_sanitario_actual ilike ?"
      args << "%#{params[:form_buscar_servicios_basicos_servicio_sanitario_actual]}%"

    end
    
    if params[:form_buscar_servicios_basicos_titulo_de_propiedad].present? #OK

      cond << "titulo_de_propiedad ilike ?"
      args << "%#{params[:form_buscar_servicios_basicos_titulo_de_propiedad]}%"

    end
    
    if params[:form_buscar_servicios_basicos_cuenta_plano].present? #OK

      cond << "cuenta_plano ilike ?"
      args << "%#{params[:form_buscar_servicios_basicos_cuenta_plano]}%"

    end
    
    if params[:form_buscar_servicios_basicos_prevencion_incendio].present? #OK

      cond << "prevencion_incendio ilike ?"
      args << "%#{params[:form_buscar_servicios_basicos_prevencion_incendio]}%"

    end

    cond = cond.join(" and ").lines.to_a + args if cond.size > 0
    
    @servicios_basicos = VServicioBasico.orden_dep_dis.where(cond).paginate(page: params[:page], per_page: 15)
                                               
    @total_registros = VServicioBasico.count 

    if params[:format] == 'csv'

      require 'csv'
      
      servicios_basicos_csv = VServicioBasico.orden_dep_dis.where(cond).all

      csv = CSV.generate do |csv|
        # header row
        csv << ["periodo", "codigo_departamento", "nombre_departamento", "codigo_distrito", "nombre_distrito",
          "codigo_establecimiento","codigo_barrio_localidad", "nombre_barrio_localidad",
          "codigo_zona", "nombre_zona",
          "nombre_asentamiento_colonia", "suministro_energia_electrica","abastecimiento_agua","servicio_sanitario_actual",
          "titulo_de_propiedad","cuenta_plano","prevencion_incendio","uri_establecimiento"
          ]
 
        # data rows
        servicios_basicos_csv.each do |i|
          csv << [i.periodo, i.codigo_departamento, i.nombre_departamento, i.codigo_distrito, i.nombre_distrito,
            i.codigo_establecimiento, i.codigo_barrio_localidad, i.nombre_barrio_localidad,
            i.codigo_zona,i.nombre_zona,
            i.nombre_asentamiento_colonia, i.suministro_energia_electrica, i.abastecimiento_agua, i.servicio_sanitario_actual,
            i.titulo_de_propiedad, i.cuenta_plano,i.prevencion_incendio,i.uri_establecimiento
          ]
        end

      end
    
      send_data(csv, :type => 'text/csv', :filename => "servicios_basicos_#{Time.now.strftime('%Y%m%d')}.csv")

    elsif params[:format] == 'xlsx'
      
      servicios_basicos_xlsx = VServicioBasico.orden_dep_dis.where(cond).all
       
      p = Axlsx::Package.new
        
      p.workbook.add_worksheet(:name => "ServiciosBasicos") do |sheet|
          
        sheet.add_row [:periodo, :codigo_departamento, :nombre_departamento, :codigo_distrito, :nombre_distrito,
            :codigo_establecimiento, :codigo_barrio_localidad, :nombre_barrio_localidad,
            :codigo_zona,:nombre_zona,
            :nombre_asentamiento_colonia, :suministro_energia_electrica, :abastecimiento_agua, :servicio_sanitario_actual,
            :titulo_de_propiedad, :cuenta_plano, :prevencion_incendio, :uri_establecimiento]

        servicios_basicos_xlsx.each do |i|
              
          sheet.add_row [i.periodo, i.codigo_departamento, i.nombre_departamento, i.codigo_distrito, i.nombre_distrito,
            i.codigo_establecimiento, i.codigo_barrio_localidad, i.nombre_barrio_localidad,
            i.codigo_zona,i.nombre_zona,
            i.nombre_asentamiento_colonia, i.suministro_energia_electrica, i.abastecimiento_agua, i.servicio_sanitario_actual,
            i.titulo_de_propiedad, i.cuenta_plano,i.prevencion_incendio,i.uri_establecimiento
          ]
                
        end

      end
            
      p.use_shared_strings = true
      
      send_data p.to_stream.read, filename: "servicios_basicos_#{Time.now.strftime('%d%m%Y__%H%M')}.xlsx", :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet", disposition: 'attachment'

    else

      @servicios_basicos_todos = VServicioBasico.orden_dep_dis.where(cond).all
      
      respond_to do |f|

        f.js
        f.json {render :json => @servicios_basicos_todos, :methods => :uri_establecimiento}

      end 

    end

  end

end
