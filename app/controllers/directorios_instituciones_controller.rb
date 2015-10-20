class DirectoriosInstitucionesController < ApplicationController
  before_filter :redireccionar_uri

  def index

    @directorios_instituciones = VDirectorioInstitucion.orden_dep_dis.paginate :per_page => 15, :page => params[:page]

    respond_to do |f|

      f.html {render :layout => 'application'}

    end

  end

  def diccionario
    
    require 'json'
    file = File.read("#{Rails.root}/app/assets/javascripts/diccionario/directorios_instituciones.json")
    diccionario = JSON.parse(file)
    @diccionario_directorios_instituciones = clean_json(diccionario)

    if params[:format] == 'json'
      
      generate_json_table_schema(@diccionario_directorios_instituciones)

    elsif params[:format] == 'pdf'
      
      send_data(generate_pdf(@diccionario_directorios_instituciones, params[:nombre]), :filename => "diccionario_directorios_instituciones.pdf", :type => "application/pdf")

    end

  end

  def lista

    cond = []
    args = []
    estados = []

    if params[:form_buscar_directorios_instituciones] && params[:form_buscar_directorios_instituciones][:periodo].present?

      cond << "periodo = ?"
      args << params[:form_buscar_directorios_instituciones][:periodo]

    end

    if params[:form_buscar_directorios_instituciones_nombre_departamento].present?

      cond << "nombre_departamento ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_directorios_instituciones_nombre_departamento])}%"

    end

    if params[:form_buscar_directorios_instituciones_nombre_distrito].present?

      cond << "nombre_distrito ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_directorios_instituciones_nombre_distrito])}%"

    end


    if params[:form_buscar_directorios_instituciones_nombre_barrio_localidad].present?

      cond << "nombre_barrio_localidad ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_directorios_instituciones_nombre_barrio_localidad])}%"

    end
    
    if params[:form_buscar_directorios_instituciones][:nombre_zona].present?

      cond << "nombre_zona = ?"
      args << "#{params[:form_buscar_directorios_instituciones][:nombre_zona]}"

    end

    if params[:form_buscar_directorios_instituciones_codigo_establecimiento].present?

      cond << "codigo_establecimiento ilike ?"
      args << "%#{params[:form_buscar_directorios_instituciones_codigo_establecimiento]}%"

    end

    if params[:form_buscar_directorios_instituciones_codigo_institucion].present?

      cond << "codigo_institucion = ?"
      args << params[:form_buscar_directorios_instituciones_codigo_institucion]

    end

    if params[:form_buscar_directorios_instituciones_nombre_institucion].present?

      cond << "nombre_institucion ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_directorios_instituciones_nombre_institucion])}%"

    end

    cond = cond.join(" and ").lines.to_a + args if cond.size > 0
    
    if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
      @directorios_instituciones = VDirectorioInstitucion.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond).paginate(page: params[:page], per_page: 15)
    else
      @directorios_instituciones = VDirectorioInstitucion.orden_dep_dis.where(cond).paginate(page: params[:page], per_page: 15)
    end

    @total_registros = VDirectorioInstitucion.count 

    if params[:format] == 'csv'

      require 'csv'
      
      if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
        directorios_instituciones_csv = VDirectorioInstitucion.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond).all
      else
        directorios_instituciones_csv = VDirectorioInstitucion.orden_dep_dis.where(cond).all
      end

      csv = CSV.generate do |csv|
        # header row
        csv << ["periodo", "codigo_departamento", "nombre_departamento", "codigo_distrito", "nombre_distrito", 
          "codigo_barrio_localidad","nombre_barrio_localidad", "codigo_zona", "nombre_zona",
          "codigo_establecimiento", "codigo_institucion", "nombre_institucion", "anho_cod_geo", 
          "uri_establecimiento", "uri_institucion"]
 
        # data rows
        directorios_instituciones_csv.each do |i|
          csv << [i.periodo, i.codigo_departamento, i.nombre_departamento, i.codigo_distrito, i.nombre_distrito,
            i.codigo_barrio_localidad, i.nombre_barrio_localidad, i.codigo_zona, i.nombre_zona,
            i.codigo_establecimiento, i.codigo_institucion, i.nombre_institucion, i.anho_cod_geo, 
            i.uri_establecimiento,i.uri_institucion]
        end

      end
    
      send_data(csv, :type => 'text/csv', :filename => "directorios_instituciones_#{Time.now.strftime('%Y%m%d')}.csv")

    elsif params[:format] == 'xlsx'
      
      if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
        directorios_instituciones_xlsx = VDirectorioInstitucion.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond).all
      else
        directorios_instituciones_xlsx = VDirectorioInstitucion.orden_dep_dis.where(cond).all
      end
       
      p = Axlsx::Package.new
        
      p.workbook.add_worksheet(:name => "DirectorioInstituciones") do |sheet|
          
        sheet.add_row [:periodo, :codigo_departamento, :nombre_departamento, :codigo_distrito, :nombre_distrito,
          :codigo_barrio_localidad, :nombre_barrio_localidad, :codigo_zona, :nombre_zona,
          :codigo_establecimiento, :codigo_institucion, :nombre_institucion, :anho_cod_geo,
          :uri_establecimiento,:uri_institucion]

        directorios_instituciones_xlsx.each do |i|
              
          sheet.add_row [i.periodo, i.codigo_departamento, i.nombre_departamento, i.codigo_distrito, i.nombre_distrito,
            i.codigo_barrio_localidad, i.nombre_barrio_localidad, i.codigo_zona, i.nombre_zona,
            i.codigo_establecimiento, i.codigo_institucion, i.nombre_institucion, i.anho_cod_geo, 
            i.uri_establecimiento,i.uri_institucion]
                
        end

      end
            
      p.use_shared_strings = true
      
      send_data p.to_stream.read, filename: "directorios_instituciones_#{Time.now.strftime('%d%m%Y__%H%M')}.xlsx", :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet", disposition: 'attachment'

    elsif params[:format] == 'json'
      
      if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
        directorios_instituciones_json = VDirectorioInstitucion.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond).all
      else
        directorios_instituciones_json = VDirectorioInstitucion.orden_dep_dis.where(cond).all
      end
      
      respond_to do |f|

        f.js
        f.json {render :json => directorios_instituciones_json, :methods => [:uri_establecimiento, :uri_institucion]}

      end
    
    elsif params[:format] == 'md5_csv'

      path_file = '/home/desa3/Escritorio/Establecimientos_Confirmados_VIRTUAL.csv'
      send_data(generate_md5(path_file), :filename => "directorio_instituciones_"+params[:form_buscar_directorios_instituciones][:periodo]+".md5", :type => "application/txt")

    else
      
      @directorios_instituciones_todos = VDirectorioInstitucion.orden_dep_dis.where(cond).all

    end

  end
 
end
