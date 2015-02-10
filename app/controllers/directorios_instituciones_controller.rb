class DirectoriosInstitucionesController < ApplicationController
  before_filter :redireccionar_uri
  
  def diccionario
    
    require 'json'
    file = File.read("#{Rails.root}/app/assets/javascripts/diccionario/directorios_instituciones.json")
    @diccionario_directorio_instituciones = JSON.parse(file)

  end

  def index

    @directorios_instituciones = VDirectorioInstitucion.orden_dep_dis.paginate :per_page => 15, :page => params[:page]

    respond_to do |f|

      f.html {render :layout => 'application'}

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

    if params[:form_buscar_directorios_instituciones_nombre_zona].present?

      cond << "nombre_zona ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_directorios_instituciones_nombre_zona])}%"

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

    @directorios_instituciones = VDirectorioInstitucion.orden_dep_dis.where(cond).paginate(page: params[:page], per_page: 15)

    @total_registros = VDirectorioInstitucion.count 

    if params[:format] == 'csv'

      require 'csv'

      directorios_instituciones_csv = VDirectorioInstitucion.orden_dep_dis.where(cond).all

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
      
      directorios_instituciones_xlsx = VDirectorioInstitucion.orden_dep_dis.where(cond).all
       
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
      
      directorios_instituciones_json = VDirectorioInstitucion.orden_dep_dis.where(cond).all
      
      respond_to do |f|

        f.js
        f.json {render :json => directorios_instituciones_json, :methods => [:uri_establecimiento, :uri_institucion]}

      end
    
    else
      
      @directorios_instituciones_todos = VDirectorioInstitucion.orden_dep_dis.where(cond).all

    end

  end
=begin  
  def doc

    if params[:directorios_instituciones] && params[:directorios_instituciones][:periodo].present?
      anio = params[:directorios_instituciones][:anio]
    else
      anio = 2012
    end
    
  
    #@total_eeb = MatriculacionEducacionEscolarBasica.filtrar_por_codigo_institucion_and_codigo_establecimiento(@institucion.codigo_institucion, @establecimiento.codigo_establecimiento).sum("total_matriculados")
    
    #@institucion = Institucion.find_by_codigo_institucion_and_anio(params[:codigo_institucion].gsub('.',''), anio)
    @directorios_instituciones = Institucion.where("replace(codigo_institucion, '.', '') = ? and anio = ?", params[:codigo_institucion].gsub('.',''), anio)
    @directorios_instituciones = @directorios_instituciones.first 
    @establecimiento = Establecimiento.find_by_codigo_establecimiento(@directorios_instituciones.codigo_establecimiento) 
    @total_eeb = MatriculacionEducacionEscolarBasica.filtrar_por_codigo_institucion_and_codigo_establecimiento(@directorios_instituciones.codigo_institucion.gsub('.',''), @establecimiento.codigo_establecimiento.gsub('.','')).sum("total_matriculados")
    @total_ei = MatriculacionEducacionInclusiva.filtrar_por_codigo_institucion_and_codigo_establecimiento(@directorios_instituciones.codigo_institucion.gsub('.',''), @establecimiento.codigo_establecimiento.gsub('.','')).sum("matricula_inicial_especial+matricula_primer_y_segundo_ciclo_especial+matricula_tercer_ciclo_especial+matricula_programas_especiales")if @directorios_instituciones.present? 
    @total_ep = MatriculacionEducacionPermanente.filtrar_por_codigo_institucion_and_codigo_establecimiento(@directorios_instituciones.codigo_institucion.gsub('.',''), @establecimiento.codigo_establecimiento.gsub('.','')).sum("matricula_ebbja+matricula_fpi+matricula_emapja+matricula_emdja+matricula_fp")
    @total_es = MatriculacionEducacionSuperior.filtrar_por_codigo_institucion_and_codigo_establecimiento(@directorios_instituciones.codigo_institucion.gsub('.',''), @establecimiento.codigo_establecimiento.gsub('.','')).sum("matricula_ets+matricula_fed+matricula_fdes+matricula_pd")
    @total_i = MatriculacionInicial.filtrar_por_codigo_institucion_and_codigo_establecimiento(@directorios_instituciones.codigo_institucion.gsub('.',''), @establecimiento.codigo_establecimiento.gsub('.','')).sum("total_matriculados")
    @total_em = MatriculacionEducacionMedia.filtrar_por_codigo_institucion_and_codigo_establecimiento(@directorios_instituciones.codigo_institucion.gsub('.',''), @establecimiento.codigo_establecimiento.gsub('.','')).sum("matricula_cientifico+matricula_tecnico+matricula_media_abierta+matricula_formacion_profesional_media")
    @resultado = @total_eeb.to_i + @total_ei.to_i  + @total_ep.to_i  + @total_es.to_i  + @total_i.to_i  + @total_em.to_i 
    respond_to do |f|

      f.html  
      f.json {render :json => @directorios_instituciones }

    end 
  
  end
=end
end
