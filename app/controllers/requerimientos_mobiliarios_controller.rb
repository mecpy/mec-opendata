class RequerimientosMobiliariosController < ApplicationController
    before_filter :redireccionar_uri
  def diccionario

  end

  def index

    @requerimientos_mobiliarios = VRequerimientoMobiliario.orden_dep_dis.paginate :per_page => 15, :page => params[:page]

    respond_to do |f|

      f.html {render :layout => 'application_wide'}

    end

  end

  def lista

    cond = []
    args = []
    estados = []

    if params[:form_buscar_requerimientos_mobiliarios] && params[:form_buscar_requerimientos_mobiliarios][:periodo].present? #OK

      cond << "periodo = ?"
      args << params[:form_buscar_requerimientos_mobiliarios][:periodo]

    end
    
    if params[:form_buscar_requerimientos_mobiliarios_numero_prioridad].present? #OK

      cond << "numero_prioridad = ?"
      args << params[:form_buscar_requerimientos_mobiliarios_numero_prioridad]

    end
    
    if params[:form_buscar_requerimientos_mobiliarios_codigo_establecimiento].present? #OK

      cond << "codigo_establecimiento ilike ?"
      args << "%#{params[:form_buscar_requerimientos_mobiliarios_codigo_establecimiento]}%"

    end
    
    if params[:form_buscar_requerimientos_mobiliarios_codigo_institucion].present? #OK

      cond << "codigo_institucion = ?"
      args << "%#{params[:form_buscar_requerimientos_mobiliarios_codigo_institucion]}%"

    end
    
    if params[:form_buscar_requerimientos_mobiliarios_nombre_institucion].present? #OK

      cond << "nombre_institucion ilike ?"
      args << "%#{params[:form_buscar_requerimientos_mobiliarios_nombre_institucion]}%"

    end

    if params[:form_buscar_requerimientos_mobiliarios_nombre_departamento].present? #OK

      cond << "nombre_departamento ilike ?"
      args << "%#{params[:form_buscar_requerimientos_mobiliarios_nombre_departamento]}%"

    end

    if params[:form_buscar_requerimientos_mobiliarios_nombre_distrito].present? #OK

      cond << "nombre_distrito ilike ?"
      args << "%#{params[:form_buscar_requerimientos_mobiliarios_nombre_distrito]}%"

    end


    if params[:form_buscar_requerimientos_mobiliarios_nombre_barrio_localidad].present? #OK

      cond << "nombre_barrio_localidad ilike ?"
      args << "%#{params[:form_buscar_requerimientos_mobiliarios_nombre_barrio_localidad]}%"

    end

    if params[:form_buscar_requerimientos_mobiliarios_nombre_zona].present? #OK

      cond << "nombre_zona ilike ?"
      args << "%#{params[:form_buscar_requerimientos_mobiliarios_nombre_zona]}%"

    end

    if params[:form_buscar_requerimientos_mobiliarios_nivel_educativo_beneficiado].present?

      cond << "nivel_educativo_beneficiado ilike ?"
      args << "%#{params[:form_buscar_requerimientos_mobiliarios_nivel_educativo_beneficiado]}%"

    end
    
    if params[:form_buscar_requerimientos_mobiliarios_nombre_mobiliario].present?

      cond << "nombre_mobiliario ilike ?"
      args << "%#{params[:form_buscar_requerimientos_mobiliarios_nombre_mobiliario]}%"

    end

    if params[:form_buscar_requerimientos_mobiliarios_cantidad_requerida].present?

      cond << "cantidad_requerida = ?"
      args << params[:form_buscar_requerimientos_mobiliarios_cantidad_requerida]

    end

    if params[:form_buscar_requerimientos_mobiliarios_justificacion].present?

      cond << "justificacion ilike ?"
      args << "%#{params[:form_buscar_requerimientos_mobiliarios_justificacion]}%"

    end

    if params[:form_buscar_requerimientos_mobiliarios_numero_beneficiados].present?

      cond << "numero_beneficiados = ?"
      args << params[:form_buscar_requerimientos_mobiliarios_numero_beneficiados]

    end

    cond = cond.join(" and ").lines.to_a + args if cond.size > 0

    @requerimientos_mobiliarios = cond.size > 0 ? (VRequerimientoMobiliario.orden_dep_dis.paginate :conditions => cond, 
                                                                               :per_page => 15,
                                                                               :page => params[:page]) : {}

    @total_registros = VRequerimientoMobiliario.count 

    if params[:format] == 'csv'

      require 'csv'

      requerimientos_mobiliarios_csv = VRequerimientoMobiliario.orden_dep_dis.find(:all, :conditions => cond)

      csv = CSV.generate do |csv|
        # header row
        csv << ["periodo", "numero_prioridad","codigo_establecimiento", "codigo_institucion","nombre_institucion",
          "codigo_departamento", "nombre_departamento", "codigo_distrito", "nombre_distrito", "codigo_barrio_localidad", "nombre_barrio_localidad", "codigo_zona", "nombre_zona",
          "nivel_educativo_beneficiado", "nombre_mobiliario","cantidad_requerida",
          "justificacion","numero_beneficiados"
          ]
 
        # data rows
        requerimientos_mobiliarios_csv.each do |i|
          csv << [i.periodo, i.numero_prioridad, i.codigo_establecimiento, i.codigo_institucion, i.nombre_institucion,
            i.codigo_departamento, i.nombre_departamento, i.codigo_distrito, i.nombre_distrito,i.codigo_barrio_localidad,i.nombre_barrio_localidad,i.codigo_zona,i.nombre_zona,
            i.nivel_educativo_beneficiado, i.nombre_mobiliario, i.cantidad_requerida,
            i.justificacion, i.numero_beneficiados  
          ]
        end

      end
    
      send_data(csv, :type => 'text/csv', :filename => "requerimientos_mobiliarios_#{Time.now.strftime('%Y%m%d')}.csv")

    elsif params[:format] == 'xlsx'
      
      @requerimientos_mobiliarios = VRequerimientoMobiliario.orden_dep_dis.find(:all, :conditions => cond)

      respond_to do |format|
      
        format.xlsx {

          columnas = [:periodo, :numero_prioridad, :codigo_establecimiento, :codigo_institucion, :nombre_institucion,
            :codigo_departamento, :nombre_departamento, :codigo_distrito, :nombre_distrito,:codigo_barrio_localidad,:nombre_barrio_localidad,:codigo_zona,:nombre_zona,
            :nivel_educativo_beneficiado, :nombre_mobiliario, :cantidad_requerida,
            :justificacion, :numero_beneficiados  ]
         
          send_data VRequerimientoMobiliario.orden_dep_dis.where(cond).to_xlsx(:columns => columnas).to_stream.read, 
                    :filename => "requerimientos_mobiliarios_#{Time.now.strftime('%d%m%Y__%H%M')}.xlsx", 
                    :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet", 
                    disposition: 'attachment'
        }
      
      end

    else

      @requerimientos_mobiliarios_todos = VRequerimientoMobiliario.orden_dep_dis.find(:all, :conditions => cond)
      
      respond_to do |f|

        f.js
        f.json {render :json => @requerimientos_mobiliarios_todos }

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
