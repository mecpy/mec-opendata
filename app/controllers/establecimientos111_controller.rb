# -*- encoding : utf-8 -*-
class Establecimientos111Controller < ApplicationController
  
  before_filter :redireccionar_uri

  def diccionario

  end

  def index

    @establecimientos = Establecimiento111.orden_dep_dis.paginate :per_page => 15, :page => params[:page]

    respond_to do |f|

      f.html {render :layout => 'application_wide'}

    end

  end

  def lista

    cond = []
    args = []
    estados = []

    if params[:form_buscar_establecimientos] && params[:form_buscar_establecimientos][:anio].present?

      cond << "anio = ?"
      args << params[:form_buscar_establecimientos][:anio]

    end

    if params[:form_buscar_establecimientos_nombre_institucion].present?

      cond << "nombre_institucion ilike ?"
      args << "%#{params[:form_buscar_establecimientos_nombre_institucion]}%"

    end

    if params[:form_buscar_establecimientos_codigo_establecimiento].present?

      cond << "codigo_establecimiento ilike ?"
      args << "%#{params[:form_buscar_establecimientos_codigo_establecimiento]}%"

    end

    if params[:form_buscar_establecimientos_nombre_departamento].present?

      cond << "nombre_departamento ilike ?"
      args << "%#{params[:form_buscar_establecimientos_nombre_departamento]}%"

    end

    if params[:form_buscar_establecimientos_nombre_distrito].present?

      cond << "nombre_distrito ilike ?"
      args << "%#{params[:form_buscar_establecimientos_nombre_distrito]}%"

    end

    if params[:form_buscar_establecimientos_nombre_zona].present?

      cond << "nombre_zona ilike ?"
      args << "%#{params[:form_buscar_establecimientos_nombre_zona]}%"

    end

    if params[:form_buscar_establecimientos_nombre_barrio_localidad].present?

      cond << "nombre_barrio_localidad ilike ?"
      args << "%#{params[:form_buscar_establecimientos_nombre_barrio_localidad]}%"

    end

    if params[:form_buscar_establecimientos_direccion].present?

      cond << "direccion ilike ?"
      args << "%#{params[:form_buscar_establecimientos_direccion]}%"

    end

    if params[:form_buscar_establecimientos_asentamientos_priorizados].present?

      cond << "preescolar #{params[:form_buscar_establecimientos_asentamientos_priorizados_operador]} ?"
      args << params[:form_buscar_establecimientos_asentamientos_priorizados]

    end

    if params[:form_buscar_establecimientos_ampliacion_comedor].present?

      cond << "a_comedor #{params[:form_buscar_establecimientos_ampliacion_comedor_operador]} ?"
      args << params[:form_buscar_establecimientos_ampliacion_comedor]

    end

    if params[:form_buscar_establecimientos_ampliacion_aulas].present?

      cond << "a_aulas #{params[:form_buscar_establecimientos_ampliacion_aulas_operador]} ?"
      args << params[:form_buscar_establecimientos_ampliacion_aulas]

    end

    if params[:form_buscar_establecimientos_ampliacion_aula_preescolar].present?

      cond << "a_aula_de_pe #{params[:form_buscar_establecimientos_ampliacion_aula_preescolar_operador]} ?"
      args << params[:form_buscar_establecimientos_ampliacion_aula_preescolar]

    end

    if params[:form_buscar_establecimientos_ampliacion_centro_aprendizaje].present?

      cond << "a_cra #{params[:form_buscar_establecimientos_ampliacion_centro_aprendizaje_operador]} ?"
      args << params[:form_buscar_establecimientos_ampliacion_centro_aprendizaje]

    end

    if params[:form_buscar_establecimientos_ampliacion_laboratorios].present?

      cond << "a_lab #{params[:form_buscar_establecimientos_ampliacion_laboratorios_operador]} ?"
      args << params[:form_buscar_establecimientos_ampliacion_laboratorios]

    end

    if params[:form_buscar_establecimientos_ampliacion_bloque_administrativo].present?

      cond << "a_bloq_adm #{params[:form_buscar_establecimientos_ampliacion_bloque_administrativo_operador]} ?"
      args << params[:form_buscar_establecimientos_ampliacion_bloque_administrativo]

    end 

    if params[:form_buscar_establecimientos_ampliacion_servicios_higienicos].present?

      cond << "a_sshh #{params[:form_buscar_establecimientos_ampliacion_servicios_higienicos_operador]} ?"
      args << params[:form_buscar_establecimientos_ampliacion_servicios_higienicos]

    end

    if params[:form_buscar_establecimientos_reparacion_aulas].present?

      cond << "r_aulas #{params[:form_buscar_establecimientos_reparacion_aulas_operador]} ?"
      args << params[:form_buscar_establecimientos_reparacion_aulas]

    end

    if params[:form_buscar_establecimientos_reparacion_servicios_higienicos].present?

      cond << "r_sshh #{params[:form_buscar_establecimientos_reparacion_servicios_higienicos_operador]} ?"
      args << params[:form_buscar_establecimientos_reparacion_servicios_higienicos]

    end

    if params[:form_buscar_establecimientos_obras_exteriores].present?

      cond << "obras_exteriores #{params[:form_buscar_establecimientos_obras_exteriores_operador]} ?"
      args << params[:form_buscar_establecimientos_obras_exteriores]

    end

    if params[:form_buscar_establecimientos_cercado].present?

      cond << "cercado #{params[:form_buscar_establecimientos_cercado_operador]} ?"
      args << params[:form_buscar_establecimientos_cercado]

    end

    cond = cond.join(" and ").lines.to_a + args if cond.size > 0

    @establecimientos = cond.size > 0 ? (Establecimiento111.orden_dep_dis.paginate :conditions => cond, :per_page => 15, :page => params[:page]) : {}

    @total_registros = Establecimiento111.count 

    if params[:format] == 'csv'

      require 'csv'

      establecimientos_csv = Establecimiento111.orden_dep_dis.find(:all, :conditions => cond)

      csv = CSV.generate do |csv|
        # header row
        csv << ["anio", "codigo_establecimiento", "codigo_departamento", "nombre_departamento", "codigo_distrito", "nombre_distrito", "codigo_zona", "nombre_zona", "codigo_barrio_localidad",
                "nombre_barrio_localidad", "direccion", "latitud", "longitud", "uri", "asentamientos_priorizados", "a_comedor", "a_aulas", "a_aula_de_pe", "a_cra", "a_lab", "a_bloq_adm",
                "r_aulas", "r_sshh", "obras_exteriores", "cercado" ]
 
        # data rows
        establecimientos_csv.each do |e|
          csv << [e.anio, e.codigo_establecimiento, "#{e.codigo_departamento}", e.nombre_departamento, e.codigo_distrito, e.nombre_distrito, e.codigo_zona, e.nombre_zona, e.codigo_barrio_localidad,
                  e.nombre_barrio_localidad, e.direccion, e.latitud, e.longitud, e.uri, e.asentamientos_priorizados, e.a_comedor, e.a_aulas, e.a_aula_de_pe, e.a_cra, e.a_lab, e.a_bloq_adm,
                  e.r_aulas, e.r_sshh, e.obras_exteriores, e.cercado]
        end

      end
    
      send_data(csv, :type => 'text/csv', :filename => "establecimientos_#{Time.now.strftime('%Y%m%d')}.csv")

    elsif params[:format] == 'xlsx'
      
      @establecimientos = Establecimiento111.orden_dep_dis.find(:all, :conditions => cond)

      respond_to do |format|
      
        format.xlsx {
          
          #columnas = [:codigo, :descripcion, :tipo_articulo, :objeto_gasto, :tipo_medida, :medida, :valor_unitario, :activo ] 
          columnas = [:anio, :codigo_institucion, :codigo_establecimiento_, :codigo_departamento, :nombre_departamento, :codigo_distrito, :nombre_distrito, :codigo_zona, :nombre_zona, :codigo_barrio_localidad,
            :nombre_barrio_localidad, :direccion, :asentamientos_priorizados, :a_comedor, :a_aulas, :a_aula_de_pe, :a_cra, :a_lab, :a_bloq_adm, :r_aulas, :r_sshh, :obras_exteriores, :cercado, :uri] 
          
          send_data Establecimiento111.orden_dep_dis.where(cond).to_xlsx(:columns => columnas).to_stream.read, 
                    :filename => "establecimientos_#{Time.now.strftime('%d%m%Y__%H%M')}.xlsx", 
                    :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet", 
                    disposition: 'attachment'
        }
      
      end

    elsif params[:format] == 'pdf'

      report = ThinReports::Report.new layout: File.join(Rails.root, 'app', 'reports', 'establecimientos.tlf')

      establecimientos = Establecimiento111.orden_dep_dis.find(:all, :conditions => cond)
    
      report.start_new_page do |page|
      
        page.item(:fecha_hora).value("Fecha y Hora: #{Time.now.strftime('%d/%m/%Y - %H:%M')}")
    
      end

      establecimientos.each do |e|
      
        report.list(:establecimientos).add_row do |row|

          row.values  anio: e.anio,
                      codigo_establecimiento: e.codigo_establecimiento,
                      codigo_departamento: e.codigo_departamento.to_s,        
                      nombre_departamento: e.nombre_departamento.to_s,       
                      codigo_distrito: e.codigo_distrito.to_s,       
                      nombre_distrito: e.nombre_distrito.to_s,       
                      codigo_zona: e.codigo_zona.to_s,       
                      nombre_zona: e.nombre_zona.to_s,       
                      codigo_barrio_localidad: e.codigo_barrio_localidad.to_s,       
                      nombre_barrio_localidad: e.nombre_barrio_localidad.to_s,       
                      direccion: e.direccion.to_s,       
                      coordenadas_y: e.coordenadas_y.to_s,       
                      coordenadas_x: e.coordenadas_x.to_s,       
                      latitud: e.latitud.to_s,       
                      longitud: e.longitud.to_s,
                      proyecto_111: e.proyecto_111,       
                      proyecto_822: e.proyecto_822,       
                      uri: e.uri       
        end

      end


      send_data report.generate, filename: "establecimientos_#{Time.now.strftime('%d%m%Y__%H%M')}.pdf", 
                                 type: 'application/pdf', 
                                 disposition: 'attachment'

    else
      @establecimientos_todos = Establecimiento111.orden_dep_dis.find(:all, :conditions => cond)
      
      respond_to do |f|

        f.js
        f.json {render :json => @establecimientos_todos, :methods => :uri }

      end 

    end

  end

  def ubicacion_geografica
    @establecimiento = Establecimiento.find(params[:id])

    respond_to do |f|

      f.js

    end

  end

  def ubicaciones_geograficas

    cond = []
    args = []
    estados = []

    if params[:form_buscar_establecimientos] && params[:form_buscar_establecimientos][:anio].present?

      cond << "anio = ?"
      args << params[:form_buscar_establecimientos][:anio]

    end

    if params[:form_buscar_establecimientos_codigo_establecimiento].present?

      cond << "codigo_establecimiento ilike ?"
      args << "%#{params[:form_buscar_establecimientos_codigo_establecimiento]}%"

    end

    if params[:form_buscar_establecimientos_nombre_departamento].present?

      cond << "nombre_departamento ilike ?"
      args << "%#{params[:form_buscar_establecimientos_nombre_departamento]}%"

    end

    if params[:form_buscar_establecimientos_nombre_distrito].present?

      cond << "nombre_distrito ilike ?"
      args << "%#{params[:form_buscar_establecimientos_nombre_distrito]}%"

    end

    if params[:form_buscar_establecimientos_nombre_zona].present?

      cond << "nombre_zona ilike ?"
      args << "%#{params[:form_buscar_establecimientos_nombre_zona]}%"

    end

    if params[:form_buscar_establecimientos_nombre_barrio_localidad].present?

      cond << "nombre_barrio_localidad ilike ?"
      args << "%#{params[:form_buscar_establecimientos_nombre_barrio_localidad]}%"

    end

    if params[:form_buscar_establecimientos_direccion].present?

      cond << "direccion ilike ?"
      args << "%#{params[:form_buscar_establecimientos_direccion]}%"

    end

    if params[:form_buscar_establecimientos] && params[:form_buscar_establecimientos][:programa].present?

      cond << "programa = ?"
      args << params[:form_buscar_establecimientos][:programa]

    end

    cond = cond.join(" and ").lines.to_a + args if cond.size > 0

    #@establecimientos = cond.size > 0 ? ( Establecimiento111.orden_dep_dis.paginate :conditions => cond, 
    #                                                                           :per_page => 15,
    #                                                                           :page => params[:page]) : {}
     
    @establecimientos = cond.size > 0 ? ( Establecimiento111.orden_dep_dis.find(:all, :conditions => cond)) : {}
    
    respond_to do |f|

      f.js

    end 

  end

  def establecimientos_instituciones

    @instituciones = VDirectorioInstitucion.where('codigo_establecimiento = ? and periodo = ?', params[:codigo_establecimiento],params[:periodo]) 

    respond_to do |f|
      f.js
    end

  end

  def ejemplo_anio_cod_geo

  end

  def establecimientos_doc

    if params[:establecimiento] && params[:establecimiento][:anio].present?
      anio = params[:establecimiento][:anio]
    else
      anio = 2014
    end
    
    @establecimiento = Establecimiento111.find_by_codigo_establecimiento_and_anio(params[:codigo_establecimiento], anio)
    @codigo_establecimiento_doc=params[:codigo_establecimiento]
    @instituciones = VDirectorioInstitucion.where('codigo_establecimiento = ? and periodo = ?', @establecimiento.codigo_establecimiento, anio).order('codigo_institucion')if @establecimiento.present?

    respond_to do |f|

      f.html
      f.json {render :json => @establecimiento , :methods => :uri}

    end 
  
  end

end
