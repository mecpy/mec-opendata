class InstitucionesController < ApplicationController
  before_filter :redireccionar_uri
  
  def diccionario

    require 'json'
    file = File.read("#{Rails.root}/app/assets/javascripts/diccionario/instituciones.json")
    @diccionario_instituciones = JSON.parse(file)
    
  end

  def index

    @instituciones = Institucion.orden_dep_dis.paginate :per_page => 15, :page => params[:page]

    respond_to do |f|

      f.html {render :layout => 'application'}

    end

  end

  def lista

    cond = []
    args = []
    estados = []

    if params[:form_buscar_instituciones] && params[:form_buscar_instituciones][:anio].present?

      cond << "anio = ?"
      args << params[:form_buscar_instituciones][:anio]

    end

    if params[:form_buscar_instituciones_nombre_departamento].present?

      cond << "nombre_departamento ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_instituciones_nombre_departamento])}%"

    end

    if params[:form_buscar_instituciones_nombre_distrito].present?

      cond << "nombre_distrito ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_instituciones_nombre_distrito])}%"

    end


    if params[:form_buscar_instituciones_nombre_barrio_localidad].present?

      cond << "nombre_barrio_localidad ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_instituciones_nombre_barrio_localidad])}%"

    end

    if params[:form_buscar_instituciones][:nombre_zona].present?

      cond << "nombre_zona = ?"
      args << "#{params[:form_buscar_instituciones][:nombre_zona]}"

    end

    if params[:form_buscar_instituciones_codigo_establecimiento].present?

      cond << "codigo_establecimiento ilike ?"
      args << "%#{params[:form_buscar_instituciones_codigo_establecimiento]}%"

    end

    if params[:form_buscar_instituciones_codigo_institucion].present?

      cond << "codigo_institucion = ?"
      args << params[:form_buscar_instituciones_codigo_institucion]

    end

    if params[:form_buscar_instituciones_nombre_institucion].present?

      cond << "nombre_institucion ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_instituciones_nombre_institucion])}%"

    end
    
    if params[:form_buscar_instituciones][:sector_o_tipo_gestion].present?

      cond << "sector_o_tipo_gestion = ?"
      args << "#{params[:form_buscar_instituciones][:sector_o_tipo_gestion]}"

    end

    if params[:form_buscar_instituciones_nombre_region_administrativa].present?

      cond << "nombre_region_administrativa ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_instituciones_nombre_region_administrativa])}%"

    end

    if params[:form_buscar_instituciones_nombre_supervisor].present?

      cond << "nombre_supervisor ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_instituciones_nombre_supervisor])}%"

    end

    if params[:form_buscar_instituciones_niveles_modalidades].present?

      cond << "niveles_modalidades ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_instituciones_niveles_modalidades])}%"

    end

    if params[:form_buscar_instituciones_nombre_tipo_organizacion].present?

      cond << "nombre_tipo_organizacion ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_instituciones_nombre_tipo_organizacion])}%"

    end

    if params[:form_buscar_instituciones][:participacion_comunitaria].present?

      cond << "participacion_comunitaria = ?"
      args << "#{params[:form_buscar_instituciones][:participacion_comunitaria]}"

    end

    if params[:form_buscar_instituciones_direccion].present?

      cond << "direccion ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_instituciones_direccion])}%"

    end   

    if params[:form_buscar_instituciones_nro_telefono].present?

      cond << "nro_telefono ilike ?"
      args << "%#{params[:form_buscar_instituciones_nro_telefono]}%"

    end

    if params[:form_buscar_instituciones][:tiene_internet].present?

      cond << "tiene_internet = ?"
      args << "#{params[:form_buscar_instituciones][:tiene_internet]}"

    end

    if params[:form_buscar_instituciones_paginaweb].present?

      cond << "paginaweb ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_instituciones_paginaweb])}%"

    end

    if params[:form_buscar_instituciones_correo_electronico].present?

      cond << "correo_electronico ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_instituciones_correo_electronico])}%"

    end

    cond = cond.join(" and ").lines.to_a + args if cond.size > 0
    
    if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
      @instituciones = Institucion.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond).paginate(page: params[:page], per_page: 15)
    else
      @instituciones = Institucion.orden_dep_dis.where(cond).paginate(page: params[:page], per_page: 15)
    end

    @total_registros = Institucion.count 

    if params[:format] == 'csv'

      require 'csv'
      
      if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
        instituciones_csv = Institucion.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond)
      else
        instituciones_csv = Institucion.orden_dep_dis.where(cond)
      end

      csv = CSV.generate do |csv|
        # header row
        csv << ["anio", "codigo_departamento", "nombre_departamento", "codigo_distrito", "nombre_distrito", "codigo_barrio_localidad", "nombre_barrio_localidad", "codigo_zona", "nombre_zona",
          "codigo_establecimiento", "codigo_institucion", "nombre_institucion", "sector_o_tipo_gestion", "codigo_region_administrativa", "nombre_region_administrativa", 
          "nombre_supervisor", "niveles_modalidades", "codigo_tipo_organizacion", "nombre_tipo_organizacion", "participacion_comunitaria", "direccion", "nro_telefono", "tiene_internet",
          "paginaweb", "correo_electronico"]
 
        # data rows
        instituciones_csv.each do |i|
          csv << [i.anio, i.codigo_departamento, i.nombre_departamento, i.codigo_distrito, i.nombre_distrito, i.codigo_barrio_localidad, i.nombre_barrio_localidad, i.codigo_zona, i.nombre_zona,
            i.codigo_establecimiento, i.codigo_institucion, i.nombre_institucion, i.sector_o_tipo_gestion, i.codigo_region_administrativa, i.nombre_region_administrativa, 
            i.nombre_supervisor, i.niveles_modalidades, i.codigo_tipo_organizacion, i.nombre_tipo_organizacion, i.participacion_comunitaria, i.direccion, i.nro_telefono, i.tiene_internet,
            i.paginaweb, i.correo_electronico]
        end

      end
    
      send_data(csv, :type => 'text/csv', :filename => "instituciones_#{Time.now.strftime('%Y%m%d')}.csv")

    elsif params[:format] == 'xlsx'
     
      p = Axlsx::Package.new
      
      p.workbook.add_worksheet(:name => "Instituciones") do |sheet|
          
        sheet.add_row [:anio, :codigo_departamento, :nombre_departamento, :codigo_distrito, :nombre_distrito, :codigo_barrio_localidad, :nombre_barrio_localidad, :codigo_zona, :nombre_zona,
          :codigo_establecimiento, :codigo_institucion, :nombre_institucion, :sector_o_tipo_gestion, :codigo_region_administrativa, :nombre_region_administrativa, 
          :nombre_supervisor, :niveles_modalidades, :codigo_tipo_organizacion, :nombre_tipo_organizacion, :participacion_comunitaria, :direccion, :nro_telefono, :tiene_internet,
          :paginaweb, :correo_electronico]

        @instituciones.each do |i|
            
          sheet.add_row [i.anio, i.codigo_departamento, i.nombre_departamento, i.codigo_distrito, i.nombre_distrito, i.codigo_barrio_localidad, i.nombre_barrio_localidad, i.codigo_zona, i.nombre_zona,
            i.codigo_establecimiento, i.codigo_institucion, i.nombre_institucion, i.sector_o_tipo_gestion, i.codigo_region_administrativa, i.nombre_region_administrativa, 
            i.nombre_supervisor, i.niveles_modalidades, i.codigo_tipo_organizacion, i.nombre_tipo_organizacion, i.participacion_comunitaria, i.direccion, i.nro_telefono, i.tiene_internet,
            i.paginaweb, i.correo_electronico]
          
        end

      end
      
      p.use_shared_strings = true

      p.serialize('public/data/instituciones_2012.xlsx')
        
      send_file "public/data/instituciones_2012.xlsx", :filename => "instituciones_#{Time.now.strftime('%d%m%Y__%H%M')}.xlsx", :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet", disposition: 'attachment'

    else
      
      if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
        @instituciones_todos = Institucion.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond)
      else
        @instituciones_todos = Institucion.orden_dep_dis.where(cond)
      end
      
      respond_to do |f|

        f.js
        f.json {render :json => @instituciones_todos }

      end 

    end

  end
  
  def doc

    if params[:institucion] && params[:institucion][:anio].present?
      anio = params[:institucion][:anio]
    else
      anio = 2012
    end
    
    
    #@total_eeb = MatriculacionEducacionEscolarBasica.filtrar_por_codigo_institucion_and_codigo_establecimiento(@institucion.codigo_institucion, @establecimiento.codigo_establecimiento).sum("total_matriculados")
    
    #@institucion = Institucion.find_by_codigo_institucion_and_anio(params[:codigo_institucion].gsub('.',''), anio)
    @institucion = Institucion.where("replace(codigo_institucion, '.', '') = ? and anio = ?", params[:codigo_institucion].gsub('.',''), anio)
    @institucion = @institucion.first 
    @establecimiento = Establecimiento.find_by_codigo_establecimiento(@institucion.codigo_establecimiento) 
    @total_eeb = MatriculacionEducacionEscolarBasica.filtrar_por_codigo_institucion_and_codigo_establecimiento(@institucion.codigo_institucion.gsub('.',''), @establecimiento.codigo_establecimiento.gsub('.','')).sum("total_matriculados")
    @total_ei = MatriculacionEducacionInclusiva.filtrar_por_codigo_institucion_and_codigo_establecimiento(@institucion.codigo_institucion.gsub('.',''), @establecimiento.codigo_establecimiento.gsub('.','')).sum("matricula_inicial_especial+matricula_primer_y_segundo_ciclo_especial+matricula_tercer_ciclo_especial+matricula_programas_especiales")if @institucion.present? 
    @total_ep = MatriculacionEducacionPermanente.filtrar_por_codigo_institucion_and_codigo_establecimiento(@institucion.codigo_institucion.gsub('.',''), @establecimiento.codigo_establecimiento.gsub('.','')).sum("matricula_ebbja+matricula_fpi+matricula_emapja+matricula_emdja+matricula_fp")
    @total_es = MatriculacionEducacionSuperior.filtrar_por_codigo_institucion_and_codigo_establecimiento(@institucion.codigo_institucion.gsub('.',''), @establecimiento.codigo_establecimiento.gsub('.','')).sum("matricula_ets+matricula_fed+matricula_fdes+matricula_pd")
    @total_i = MatriculacionInicial.filtrar_por_codigo_institucion_and_codigo_establecimiento(@institucion.codigo_institucion.gsub('.',''), @establecimiento.codigo_establecimiento.gsub('.','')).sum("total_matriculados")
    @total_em = MatriculacionEducacionMedia.filtrar_por_codigo_institucion_and_codigo_establecimiento(@institucion.codigo_institucion.gsub('.',''), @establecimiento.codigo_establecimiento.gsub('.','')).sum("matricula_cientifico+matricula_tecnico+matricula_media_abierta+matricula_formacion_profesional_media")
    @resultado = @total_eeb.to_i + @total_ei.to_i  + @total_ep.to_i  + @total_es.to_i  + @total_i.to_i  + @total_em.to_i 
    respond_to do |f|

      f.html  
      f.json {render :json => @institucion }

    end 
  
  end

end
