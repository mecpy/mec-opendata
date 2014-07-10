class DataController < ApplicationController
  
  def index
    
  end

  def about

  end

  def legal

  end

  def diccionario_establecimientos

  end

  def establecimientos

    @establecimientos = Establecimiento.orden_dep_dis.paginate :per_page => 15, :page => params[:page]

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

    cond = cond.join(" and ").lines.to_a + args if cond.size > 0

    @establecimientos = cond.size > 0 ? (Establecimiento.orden_dep_dis.paginate :conditions => cond, 
                                                                               :per_page => 15,
                                                                               :page => params[:page]) : {}

    @total_registros = Establecimiento.count 

    if params[:format] == 'csv'

      require 'csv'

      establecimientos_csv = Establecimiento.orden_dep_dis.find(:all, :conditions => cond)

      csv = CSV.generate do |csv|
        # header row
        csv << ["anio", "codigo_establecimiento", "codigo_departamento", "nombre_departamento", "codigo_distrito", "nombre_distrito", "codigo_zona", "nombre_zona", "codigo_barrio_localidad",
                "nombre_barrio_localidad", "direccion", "coordenadas_y", "coordenadas_x", "latitud", "longitud"]
 
        # data rows
        establecimientos_csv.each do |e|
          csv << [e.anio, e.codigo_establecimiento, e.codigo_departamento, e.nombre_departamento, e.codigo_distrito, e.nombre_distrito, e.codigo_zona, e.nombre_zona, e.codigo_barrio_localidad,
                  e.nombre_barrio_localidad, e.direccion, e.coordenadas_y, e.coordenadas_x, e.latitud, e.longitud ]
        end

      end
    
      send_data(csv, :type => 'text/csv', :filename => "establecimientos_#{Time.now.strftime('%Y%m%d')}.csv")

    elsif params[:format] == 'xlsx'
      
      @establecimientos = Establecimiento.orden_dep_dis.find(:all, :conditions => cond)

      respond_to do |format|
      
        format.xlsx {
          
          #columnas = [:codigo, :descripcion, :tipo_articulo, :objeto_gasto, :tipo_medida, :medida, :valor_unitario, :activo ] 
          columnas = [:anio, :codigo_establecimiento, :codigo_departamento, :nombre_departamento, :codigo_distrito, :nombre_distrito, :codigo_zona, :nombre_zona, :codigo_barrio_localidad, :nombre_barrio_localidad, :direccion, :coordenadas_y, :coordenadas_x, :latitud, :longitud] 
          
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
                      longitud: e.longitud.to_s       
        end

      end


      send_data report.generate, filename: "establecimientos_#{Time.now.strftime('%d%m%Y__%H%M')}.pdf", 
                                 type: 'application/pdf', 
                                 disposition: 'attachment'

    else
      @establecimientos_todos = Establecimiento.orden_dep_dis.find(:all, :conditions => cond)
      
      respond_to do |f|

        f.js
        f.json {render :json => @establecimientos_todos }

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

    @instituciones = Institucion.where("codigo_establecimiento = ?", params[:codigo_establecimiento]) 

    respond_to do |f|
      f.js
    end

  end

end
