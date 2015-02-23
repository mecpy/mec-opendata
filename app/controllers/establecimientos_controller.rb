class EstablecimientosController < ApplicationController
  
  before_filter :redireccionar_uri
  
  def diccionario

    require 'json'
    file = File.read("#{Rails.root}/app/assets/javascripts/diccionario/establecimientos.json")
    @diccionario_establecimientos = JSON.parse(file)
    
  end
  
  def index

    @establecimientos = Establecimiento.orden_dep_dis.paginate :per_page => 15, :page => params[:page]

    respond_to do |f|

      f.html {render :layout => 'application'}

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

    if params[:form_buscar_establecimientos_codigo_establecimiento].present?

      cond << "codigo_establecimiento ilike ?"
      args << "%#{params[:form_buscar_establecimientos_codigo_establecimiento]}%"

    end

    if params[:form_buscar_establecimientos_nombre_departamento].present?

      cond << "nombre_departamento ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_establecimientos_nombre_departamento])}%"

    end

    if params[:form_buscar_establecimientos_nombre_distrito].present?

      cond << "nombre_distrito ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_establecimientos_nombre_distrito])}%"

    end

    if params[:form_buscar_establecimientos][:nombre_zona].present?

      cond << "nombre_zona = ?"
      args << "#{params[:form_buscar_establecimientos][:nombre_zona]}"

    end

    if params[:form_buscar_establecimientos_nombre_barrio_localidad].present?

      cond << "nombre_barrio_localidad ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_establecimientos_nombre_barrio_localidad])}%"

    end

    if params[:form_buscar_establecimientos_direccion].present?

      cond << "direccion ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_establecimientos_direccion])}%"

    end

    if params[:form_buscar_establecimientos] && params[:form_buscar_establecimientos][:programa].present?

      cond << "programa = ?"
      args << params[:form_buscar_establecimientos][:programa]

    end

    cond = cond.join(" and ").lines.to_a + args if cond.size > 0
    
    if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
      @establecimientos = Establecimiento.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond).paginate(page: params[:page], per_page: 15)
    else
      @establecimientos = Establecimiento.orden_dep_dis.where(cond).paginate(page: params[:page], per_page: 15)
    end

    @total_registros = Establecimiento.count 

    if params[:format] == 'csv'

      require 'csv'

      establecimientos_csv = Establecimiento.orden_dep_dis.where(cond)

      csv = CSV.generate do |csv|
        # header row
        csv << ["anio", "codigo_establecimiento", "codigo_departamento", "nombre_departamento", "codigo_distrito", "nombre_distrito", "codigo_zona", "nombre_zona", "codigo_barrio_localidad",
          "nombre_barrio_localidad", "direccion", "coordenadas_y", "coordenadas_x", "latitud", "longitud", "anho_cod_geo", "uri"]
 
        # data rows
        establecimientos_csv.each do |e|
          csv << [e.anio, e.codigo_establecimiento, e.codigo_departamento, e.nombre_departamento, e.codigo_distrito, e.nombre_distrito, e.codigo_zona, e.nombre_zona, e.codigo_barrio_localidad,
            e.nombre_barrio_localidad, e.direccion, e.coordenadas_y, e.coordenadas_x, e.latitud, e.longitud, e.anho_cod_geo, e.uri ]
        end

      end
    
      send_data(csv, :type => 'text/csv', :filename => "establecimientos_#{Time.now.strftime('%Y%m%d')}.csv")

    elsif params[:format] == 'xlsx'
      
      if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
        @establecimientos = Establecimiento.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond)
      else
        @establecimientos = Establecimiento.orden_dep_dis.where(cond)
      end

      p = Axlsx::Package.new
      
      p.workbook.add_worksheet(:name => "Establecimientos") do |sheet|
          
        sheet.add_row [:anio, :codigo_establecimiento, :codigo_departamento, :nombre_departamento, :codigo_distrito, :nombre_distrito, :codigo_zona, :nombre_zona, :codigo_barrio_localidad, :nombre_barrio_localidad, :direccion, :coordenadas_y, :coordenadas_x, :latitud, :longitud, :anho_cod_geo, :uri] 
          
        @establecimientos.each do |e|
            
          sheet.add_row [e.anio, e.codigo_establecimiento, e.codigo_departamento, e.nombre_departamento, e.codigo_distrito, e.nombre_distrito, e.codigo_zona, e.nombre_zona, e.codigo_barrio_localidad, e.nombre_barrio_localidad, e.direccion, e.coordenadas_y, e.coordenadas_x, e.latitud, e.longitud, e.anho_cod_geo, e.uri] 
          
        end

      end
      
      p.use_shared_strings = true
      
      p.serialize('public/data/establecimientos_2012.xlsx')
        
      send_file "public/data/establecimientos_2012.xlsx", :filename => "establecimientos_#{Time.now.strftime('%d%m%Y__%H%M')}.xlsx", :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet", disposition: 'attachment'

    elsif params[:format] == 'pdf'

      report = ThinReports::Report.new layout: File.join(Rails.root, 'app', 'reports', 'establecimientos.tlf')
      
      if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
        establecimientos = Establecimiento.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond)
      else
        establecimientos = Establecimiento.orden_dep_dis.where(cond)
      end
    
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
            #anho_cod_geo: e.anho_cod_geo.to_s,
          uri: e.uri.to_s
        end

      end


      send_data report.generate, filename: "establecimientos_#{Time.now.strftime('%d%m%Y__%H%M')}.pdf", 
        type: 'application/pdf', 
        disposition: 'attachment'

    else
      
      if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
        @establecimientos_todos = Establecimiento.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond)
      else
        @establecimientos_todos = Establecimiento.orden_dep_dis.where(cond)
      end
      
      respond_to do |f|

        f.js
        f.json {render :json => @establecimientos_todos , :methods => :uri}

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

    if params[:form_buscar_establecimientos][:nombre_zona].present?

      cond << "nombre_zona = ?"
      args << "#{params[:form_buscar_establecimientos][:nombre_zona]}"

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

    @establecimientos = Establecimiento.orden_dep_dis.where(cond)
    
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
    
    @establecimiento = Establecimiento.find_by_codigo_establecimiento_and_anio(params[:codigo_establecimiento], anio)
    @codigo_establecimiento_doc=params[:codigo_establecimiento]
    @instituciones = VDirectorioInstitucion.where('codigo_establecimiento = ? and periodo = ?', @establecimiento.codigo_establecimiento, anio).order('codigo_institucion')if @establecimiento.present?

    respond_to do |f|

      f.html
      f.json {render :json => @establecimiento , :methods => :uri}

    end 
  
  end

end