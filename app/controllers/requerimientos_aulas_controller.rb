class RequerimientosAulasController < ApplicationController
  
  def diccionario

  end

  def index

    @requerimientos_aulas = VRequerimientoAula.orden_dep_dis.paginate :per_page => 15, :page => params[:page]

    respond_to do |f|

      f.html {render :layout => 'application_wide'}

    end

  end

  def lista

    cond = []
    args = []
    estados = []

    if params[:form_buscar_requerimientos_aulas] && params[:form_buscar_requerimientos_aulas][:periodo].present? 

      cond << "periodo = ?"
      args << params[:form_buscar_requerimientos_aulas][:periodo]

    end
    
    if params[:form_buscar_requerimientos_aulas_numero_prioridad].present? 

      cond << "numero_prioridad = ?"
      args << params[:form_buscar_requerimientos_aulas_numero_prioridad]

    end
    
    if params[:form_buscar_requerimientos_aulas_codigo_establecimiento].present? 

      cond << "codigo_establecimiento ilike ?"
      args << "%#{params[:form_buscar_requerimientos_aulas_codigo_establecimiento]}%"

    end
    
    if params[:form_buscar_requerimientos_aulas_codigo_institucion].present? 

      cond << "codigo_institucion ilike ?"
      args << "%#{params[:form_buscar_requerimientos_aulas_codigo_institucion]}%"

    end
    
    if params[:form_buscar_requerimientos_aulas_nombre_institucion].present? 

      cond << "nombre_institucion ilike ?"
      args << "%#{params[:form_buscar_requerimientos_aulas_nombre_institucion]}%"

    end

    if params[:form_buscar_requerimientos_aulas_nombre_departamento].present? 

      cond << "nombre_departamento ilike ?"
      args << "%#{params[:form_buscar_requerimientos_aulas_nombre_departamento]}%"

    end

    if params[:form_buscar_requerimientos_aulas_nombre_distrito].present? 

      cond << "nombre_distrito ilike ?"
      args << "%#{params[:form_buscar_requerimientos_aulas_nombre_distrito]}%"

    end

    if params[:form_buscar_requerimientos_aulas_nombre_zona].present? 

      cond << "nombre_zona ilike ?"
      args << "%#{params[:form_buscar_requerimientos_aulas_nombre_zona]}%"

    end

    if params[:form_buscar_requerimientos_aulas_nivel_educativo_beneficiado].present?

      cond << "nivel_educativo_beneficiado ilike ?"
      args << "%#{params[:form_buscar_requerimientos_aulas_nivel_educativo_beneficiado]}%"

    end

    if params[:form_buscar_requerimientos_aulas_cuenta_espacio_para_construccion].present?

      cond << "cuenta_espacio_para_construccion ilike ?"
      args << "%#{params[:form_buscar_requerimientos_aulas_cuenta_espacio_para_construccion]}%"

    end

    if params[:form_buscar_requerimientos_aulas][:tipo_requerimiento_infraestructura].present?

      cond << "tipo_requerimiento_infraestructura = ?"
      args << "#{params[:form_buscar_requerimientos_aulas][:tipo_requerimiento_infraestructura]}"

    end   

    if params[:form_buscar_requerimientos_aulas_cantidad_requerida].present?

      cond << "cantidad_requerida #{params[:form_buscar_requerimientos_aulas_cantidad_requerida_operador]} ?"
      args << params[:form_buscar_requerimientos_aulas_cantidad_requerida]

    end
    
    if params[:form_buscar_requerimientos_aulas_numero_beneficiados].present?

      cond << "numero_beneficiados #{params[:form_buscar_requerimientos_aulas_numero_beneficiados_operador]} ?"
      args << params[:form_buscar_requerimientos_aulas_numero_beneficiados]

    end
    
    if params[:form_buscar_requerimientos_aulas_justificacion].present?

      cond << "justificacion ilike ?"
      args << "%#{params[:form_buscar_requerimientos_aulas_justificacion]}%"

    end

    cond = cond.join(" and ").lines.to_a + args if cond.size > 0

    @requerimientos_aulas = VRequerimientoAula.orden_dep_dis.where(cond).paginate(page: params[:page], per_page: 15)
    
    @total_registros = VRequerimientoAula.count 

    if params[:format] == 'csv'

      require 'csv'

      requerimientos_aulas_csv = VRequerimientoAula.orden_dep_dis.where(cond).all

      csv = CSV.generate do |csv|
        # header row
        csv << ["periodo", "codigo_departamento", "nombre_departamento", "codigo_distrito", "nombre_distrito","numero_prioridad",
          "codigo_establecimiento", "codigo_institucion","nombre_institucion",
          "codigo_zona", "nombre_zona",
          "nivel_educativo_beneficiado", "cuenta_espacio_para_construccion","tipo_requerimiento_infraestructura","cantidad_requerida",
          "numero_beneficiados","justificacion","uri_establecimiento","uri_institucion"
        ]
 
        # data rows
        requerimientos_aulas_csv.each do |i|
          csv << [i.periodo,i.codigo_departamento, i.nombre_departamento, i.codigo_distrito, i.nombre_distrito, i.numero_prioridad,
            i.codigo_establecimiento, i.codigo_institucion, i.nombre_institucion,
            i.codigo_zona,i.nombre_zona,
            i.nivel_educativo_beneficiado, i.cuenta_espacio_para_construccion, i.tipo_requerimiento_infraestructura, i.cantidad_requerida,
            i.numero_beneficiados,i.justificacion ,i.uri_establecimiento,i.uri_institucion
          ]
        end

      end
        
      send_data(csv, :type => 'text/csv', :filename => "requerimientos_aulas_#{Time.now.strftime('%Y%m%d')}.csv")

    elsif params[:format] == 'xlsx'
      
      requerimientos_aulas_xlsx = VRequerimientoAula.orden_dep_dis.where(cond).all
       
      p = Axlsx::Package.new
        
      p.workbook.add_worksheet(:name => "RequerimientosAulas") do |sheet|
          
        sheet.add_row [:periodo,  :codigo_departamento, :nombre_departamento, :codigo_distrito, :nombre_distrito, :numero_prioridad,
          :codigo_establecimiento, :codigo_institucion, :nombre_institucion,  
          :codigo_zona,:nombre_zona,
          :nivel_educativo_beneficiado, :cuenta_espacio_para_construccion, :tipo_requerimiento_infraestructura, :cantidad_requerida,
          :numero_beneficiados,:justificacion,:uri_establecimiento,:uri_institucion]

        requerimientos_aulas_xlsx.each do |i|
              
          sheet.add_row [i.periodo,i.codigo_departamento, i.nombre_departamento, i.codigo_distrito, i.nombre_distrito, i.numero_prioridad,
            i.codigo_establecimiento, i.codigo_institucion, i.nombre_institucion,
            i.codigo_zona,i.nombre_zona,
            i.nivel_educativo_beneficiado, i.cuenta_espacio_para_construccion, i.tipo_requerimiento_infraestructura, i.cantidad_requerida,
            i.numero_beneficiados,i.justificacion ,i.uri_establecimiento,i.uri_institucion
          ]
                
        end

      end
            
      p.use_shared_strings = true
      
      send_data p.to_stream.read, filename: "requerimientos_aulas_#{Time.now.strftime('%d%m%Y__%H%M')}.xlsx", :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet", disposition: 'attachment'

    else
      
      @requerimientos_aulas_todos = VRequerimientoAula.orden_dep_dis.where(cond).all
      
      respond_to do |f|

        f.js
        f.json {render :json => @requerimientos_aulas_todos, :methods => [:uri_establecimiento, :uri_institucion]}

      end
      
    end

  end

end
