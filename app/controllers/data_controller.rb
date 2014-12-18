# -*- encoding : utf-8 -*-
class DataController < ApplicationController
  
  before_filter :redireccionar_uri

  def index
    
  end

  def about

  end

  def legal

  end

  def contactos

  end

  def contactos_lista

    cond = []
    args = []
    cond = cond.join(" and ").lines.to_a + args if cond.size > 0

    if params[:form_ordenar_contactos]

      ordenado = "fecha desc, hora desc" if params[:form_ordenar_contactos][:orden] == '1'
      ordenado = "asunto" if params[:form_ordenar_contactos][:orden] == '2'

    else

      ordenado = "fecha desc, hora desc"
    
    end

    @contactos = Contacto.paginate :per_page => 10, :page => params[:page], :order => ordenado

    @total_registros = Contacto.count 

     
    respond_to do |f|

      f.js

    end 

  end

  def contactos_guardar

    @contacto = Contacto.new(params[:contacto])
    @valido = true
    @msg = ""

    if params[:contacto] && params[:contacto][:nombre].present?
      @contacto.nombre = params[:contacto][:nombre]
    else
      @valido = false
      @msg += "El campo nombre no puede quedar vacio."
    end

    if params[:contacto] && params[:contacto][:apellido].present?
      @contacto.apellido = params[:contacto][:apellido]
    else
      @valido = false
      @msg += "El campo nombre no puede quedar vacio."
    end

    if params[:contacto] && params[:contacto][:email].present?

      if @contacto.email =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

        @contacto.email = params[:contacto][:email]

      else

        @valido = false
        @msg += "Formato de email no valido."

      end
    else
      @valido = false
      @msg += "El campo email no puede quedar vacio."
    end

    if params[:contacto] && params[:contacto][:asunto].present?
      @contacto.asunto = params[:contacto][:asunto]
    else
      @valido = false
      @msg += "El campo asunto no puede quedar vacio."
    end

    if params[:contacto] && params[:contacto][:categoria_contacto_id].present?
      @contacto.categoria_contacto_id = params[:contacto][:categoria_contacto_id]
    else
      @valido = false
      @msg += "Seleccione la categoria."
    end

    if params[:contacto] && params[:contacto][:mensaje].present?
      @contacto.mensaje = params[:contacto][:mensaje]
    else
      @valido = false
      @msg += "El campo mensaje no puede quedar vacio."
    end

    #unless verify_recaptcha
    #  @valido = false
    #  @msg += "Código de verificación no valido.".html_safe   
    #end

    if @valido

      @contacto.fecha = Time.now.strftime("%Y-%m-%d")
      @contacto.hora = Time.now.strftime("%H:%M:%S")
      
      if @contacto.save
        
        @enviado = true 

      else
        
        @enviado = false
      
      end

    end

    respond_to do |f|
      f.js
    end

  end

  def diccionario_establecimientos

  end

  def establecimientos

    @establecimientos = Establecimiento.orden_dep_dis.paginate :per_page => 15, :page => params[:page]

    respond_to do |f|

      f.html {render :layout => 'application_wide'}

    end

  end

  def establecimientos_lista

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

    if params[:form_buscar_establecimientos] && params[:form_buscar_establecimientos][:proyecto_111].present?

      cond << "proyecto_111 = ?"
      args << params[:form_buscar_establecimientos][:proyecto_111]

    end

    if params[:form_buscar_establecimientos] && params[:form_buscar_establecimientos][:proyecto_822].present?

      cond << "proyecto_822 = ?"
      args << params[:form_buscar_establecimientos][:proyecto_822]

    end

    cond = cond.join(" and ").lines.to_a + args if cond.size > 0

    @establecimientos = cond.size > 0 ? (Establecimiento.orden_dep_dis.paginate :conditions => cond, :per_page => 15, :page => params[:page]) : {}

    @total_registros = Establecimiento.count 

    if params[:format] == 'csv'

      require 'csv'

      establecimientos_csv = Establecimiento.orden_dep_dis.find(:all, :conditions => cond)

      csv = CSV.generate do |csv|
        # header row
        csv << ["anio", "codigo_establecimiento", "codigo_departamento", "nombre_departamento", "codigo_distrito", "nombre_distrito", "codigo_zona", "nombre_zona", "codigo_barrio_localidad",
                "nombre_barrio_localidad", "direccion", "coordenadas_y", "coordenadas_x", "latitud", "longitud", "anho_cod_geo", "programa", "proyecto_111", "proyecto_822", "uri"]
 
        # data rows
        establecimientos_csv.each do |e|
          csv << [e.anio, e.codigo_establecimiento, "#{e.codigo_departamento} ", e.nombre_departamento, e.codigo_distrito, e.nombre_distrito, e.codigo_zona, e.nombre_zona, e.codigo_barrio_localidad,
                  e.nombre_barrio_localidad, e.direccion, e.coordenadas_y, e.coordenadas_x, e.latitud, e.longitud, e.anho_cod_geo, e.programa, e.proyecto_111, e.proyecto_822, e.uri ]
        end

      end
    
      send_data(csv, :type => 'text/csv', :filename => "establecimientos_#{Time.now.strftime('%Y%m%d')}.csv")

    elsif params[:format] == 'xlsx'
      
      @establecimientos = Establecimiento.orden_dep_dis.find(:all, :conditions => cond)

      respond_to do |format|
      
        format.xlsx {
          
          #columnas = [:codigo, :descripcion, :tipo_articulo, :objeto_gasto, :tipo_medida, :medida, :valor_unitario, :activo ] 
          columnas = [:anio, :codigo_establecimiento_, :codigo_departamento, :nombre_departamento, :codigo_distrito, :nombre_distrito, :codigo_zona, :nombre_zona, :codigo_barrio_localidad, :nombre_barrio_localidad, :direccion, :coordenadas_y, :coordenadas_x, :latitud, :longitud, :programa, :proyecto_111, :proyecto_822, :uri] 
          
          send_data Establecimiento.orden_dep_dis.where(cond).to_xlsx(:columns => columnas).to_stream.read, 
                    :filename => "establecimientos_#{Time.now.strftime('%d%m%Y__%H%M')}.xlsx", 
                    :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet", 
                    disposition: 'attachment'
        }
      
      end

    elsif params[:format] == 'pdf'

      report = ThinReports::Report.new layout: File.join(Rails.root, 'app', 'reports', 'establecimientos.tlf')

      establecimientos = Establecimiento.orden_dep_dis.find(:all, :conditions => cond)
    
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
      @establecimientos_todos = Establecimiento.orden_dep_dis.find(:all, :conditions => cond)
      
      respond_to do |f|

        f.js
        f.json {render :json => @establecimientos_todos, :methods => :uri }

      end 

    end

  end

  def establecimientos_ubicacion_geografica

    @establecimiento = Establecimiento.find(params[:id])

    respond_to do |f|

      f.js

    end

  end

  def establecimientos_ubicaciones_geograficas

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

    #@establecimientos = cond.size > 0 ? ( Establecimiento.orden_dep_dis.paginate :conditions => cond, 
    #                                                                           :per_page => 15,
    #                                                                           :page => params[:page]) : {}
     
    @establecimientos = cond.size > 0 ? ( Establecimiento.orden_dep_dis.find(:all, :conditions => cond)) : {}
    
    respond_to do |f|

      f.js

    end 

  end

  def establecimientos_instituciones

    @instituciones = VDirectorioInstitucion.where("codigo_establecimiento = ?", params[:codigo_establecimiento]) 

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
    
    @establecimiento = Establecimiento.find_by_codigo_establecimiento_and_anio(params[:codigo_establecimiento], anio)
    @codigo_establecimiento_doc=params[:codigo_establecimiento]
    @instituciones = VDirectorioInstitucion.where('codigo_establecimiento = ? and periodo = ?', @establecimiento.codigo_establecimiento, anio).order('codigo_institucion')if @establecimiento.present?

    respond_to do |f|

      f.html
      f.json {render :json => @establecimiento , :methods => :uri}

    end 
  
  end

end
