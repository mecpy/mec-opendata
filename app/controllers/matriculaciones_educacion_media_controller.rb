class MatriculacionesEducacionMediaController < ApplicationController
  def index
    @matriculaciones_departamentos_distritos = MatriculacionEducacionMedia.orden_dep_dis.paginate :per_page => 15, :page => params[:page]
    respond_to do |f|

      f.html {render :layout => 'application_wide'}

    end
  end

  def lista

    cond = []
    args = []
    estados = []

    if params[:form_buscar_matriculaciones_educacion_media] &&
        params[:form_buscar_matriculaciones_educacion_media][:anio].present?

      cond << "anio = ?"
      args << params[:form_buscar_matriculaciones_educacion_media][:anio]

    end

    if params[:form_buscar_matriculaciones_educacion_media_nombre_departamento].present?

      cond << "nombre_departamento ilike ?"
      args << "%#{params[:form_buscar_matriculaciones_educacion_media_nombre_departamento]}%"

    end

    if params[:form_buscar_matriculaciones_educacion_media_nombre_distrito].present?

      cond << "nombre_distrito ilike ?"
      args << "%#{params[:form_buscar_matriculaciones_educacion_media_nombre_distrito]}%"

    end

    if params[:form_buscar_matriculaciones_educacion_media_nombre_barrio_localidad].present?

      cond << "nombre_barrio_localidad ilike ?"
      args << "%#{params[:form_buscar_matriculaciones_educacion_media_nombre_barrio_localidad]}%"

    end

    if params[:form_buscar_matriculaciones_educacion_media_nombre_zona].present?

      cond << "nombre_zona ilike ?"
      args << "%#{params[:form_buscar_matriculaciones_educacion_media_nombre_zona]}%"

    end

    if params[:form_buscar_matriculaciones_educacion_media_codigo_establecimiento].present?

      cond << "codigo_establecimiento ilike ?"
      args << "%#{params[:form_buscar_matriculaciones_educacion_media_codigo_establecimiento]}%"

    end

    if params[:form_buscar_matriculaciones_educacion_media_codigo_institucion].present?

      cond << "codigo_institucion = ?"
      args << params[:form_buscar_matriculaciones_educacion_media_codigo_institucion]

    end

    if params[:form_buscar_matriculaciones_educacion_media_nombre_institucion].present?

      cond << "nombre_institucion ilike ?"
      args << "%#{params[:form_buscar_matriculaciones_educacion_media_nombre_institucion]}%"

    end

    if params[:form_buscar_matriculaciones_educacion_media_sector_o_tipo_gestion].present?

      cond << "sector_o_tipo_gestion ilike ?"
      args << "%#{params[:form_buscar_matriculaciones_educacion_media_sector_o_tipo_gestion]}%"

    end

    if params[:form_buscar_matriculaciones_educacion_media_matricula_cientifico].present?

      cond << "matricula_cientifico #{params[:form_buscar_matriculaciones_educacion_media_matricula_cientifico_operador]} ?"
      args << params[:form_buscar_matriculaciones_educacion_media_matricula_cientifico]

    end

    if params[:form_buscar_matriculaciones_educacion_media_matricula_tecnico].present?

      cond << "matricula_tecnico #{params[:form_buscar_matriculaciones_educacion_media_matricula_tecnico_operador]} ?"
      args << params[:form_buscar_matriculaciones_educacion_media_matricula_tecnico]

    end

    if params[:form_buscar_matriculaciones_educacion_media_matricula_media_abierta].present?

      cond << "matricula_media_abierta #{params[:form_buscar_matriculaciones_educacion_media_matricula_media_abierta_operador]} ?"
      args << params[:form_buscar_matriculaciones_educacion_media_matricula_media_abierta]

    end

    if params[:form_buscar_matriculaciones_educacion_media_matricula_formacion_profesional_media].present?

      cond << "matricula_formacion_profesional_media #{params[:form_buscar_matriculaciones_educacion_media_matricula_formacion_profesional_media_operador]} ?"
      args << params[:form_buscar_matriculaciones_educacion_media_matricula_formacion_profesional_media]

    end

    cond = cond.join(" and ").lines.to_a + args if cond.size > 0

    @matriculaciones_educacion_media = MatriculacionEducacionMedia.orden_dep_dis.where(cond).paginate(page: params[:page], per_page: 15)

    @total_registros = MatriculacionEducacionMedia.count 

    if params[:format] == 'csv'

      require 'csv'

      matriculaciones_educacion_media_csv = MatriculacionEducacionMedia.orden_dep_dis.where(cond)

      csv = CSV.generate do |csv|
        # header row
        csv << ["anio", "codigo_departamento", "nombre_departamento",
         "codigo_distrito", "nombre_distrito", "codigo_barrio_localidad",
         "nombre_barrio_localidad", "codigo_zona", "nombre_zona",
         "codigo_establecimiento", "codigo_institucion", "nombre_institucion",
         "sector_o_tipo_gestion", "matricula_cientifico", "matricula_tecnico", 
         "matricula_media_abierta", "matricula_formacion_profesional_media", "anho_cod_geo" ]
 
        # data rows
        matriculaciones_educacion_media_csv.each do |e|
          csv << [e.anio, e.codigo_departamento, 
                  e.nombre_departamento, e.codigo_distrito, e.nombre_distrito,
                  e.codigo_barrio_localidad, e.nombre_barrio_localidad,
                  e.codigo_zona, e.nombre_zona, e.codigo_establecimiento,
                  e.codigo_institucion, e.nombre_institucion,
                  e.sector_o_tipo_gestion, e.matricula_cientifico, e.matricula_tecnico,
                  e.matricula_media_abierta, e.matricula_formacion_profesional_media, e.anho_cod_geo ]
        end

      end
    
      send_data(csv, :type => 'text/csv', :filename => "matriculaciones_educacion_media_#{Time.now.strftime('%Y%m%d')}.csv")

    elsif params[:format] == 'xlsx'
      
      @matriculaciones_educacion_media = MatriculacionEducacionMedia.orden_dep_dis.where(cond)

      p = Axlsx::Package.new
      
      p.workbook.add_worksheet(:name => "Matriculaciones EM") do |sheet|
          
        sheet.add_row [:anio, :codigo_departamento, :nombre_departamento, 
            :codigo_distrito, :nombre_distrito, :codigo_barrio_localidad,
            :nombre_barrio_localidad, :codigo_zona, :nombre_zona, 
            :codigo_establecimiento, :codigo_institucion, :nombre_institucion,
            :sector_o_tipo_gestion, :matricula_cientifico, :matricula_tecnico,
            :matricula_media_abierta, :matricula_formacion_profesional_media]

        @matriculaciones_educacion_media.each do |m|
            
          sheet.add_row [m.anio, m.codigo_departamento, m.nombre_departamento, 
            m.codigo_distrito, m.nombre_distrito, m.codigo_barrio_localidad,
            m.nombre_barrio_localidad, m.codigo_zona, m.nombre_zona, 
            m.codigo_establecimiento, m.codigo_institucion, m.nombre_institucion,
            m.sector_o_tipo_gestion, m.matricula_cientifico, m.matricula_tecnico,
            m.matricula_media_abierta, m.matricula_formacion_profesional_media]

        end

      end
      
      p.use_shared_strings = true
      
      p.serialize('public/data/matriculaciones_educacion_media_2012.xlsx')
        
      send_file "public/data/matriculaciones_educacion_media_2012.xlsx", :filename => "matriculaciones_educacion_media_#{Time.now.strftime('%d%m%Y__%H%M')}.xlsx", :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet", disposition: 'attachment'

    elsif params[:format] == 'pdf'

      report = ThinReports::Report.new layout: File.join(Rails.root, 'app',
        'reports', 'matriculaciones_educacion_media.tlf')

      matriculaciones_educacion_media = MatriculacionEducacionMedia.orden_dep_dis.where(cond)
    
      report.start_new_page do |page|
      
        page.item(:fecha_hora).value("Fecha y Hora: #{Time.now.strftime('%d/%m/%Y - %H:%M')}")
    
      end

      matriculaciones_educacion_media.each do |e|
      
        report.list(:matriculaciones_educacion_media).add_row do |row|

          row.values  anio: e.anio,
                      codigo_departamento: e.codigo_departamento.to_s,        
                      nombre_departamento: e.nombre_departamento.to_s,       
                      codigo_distrito: e.codigo_distrito.to_s,       
                      nombre_distrito: e.nombre_distrito.to_s,
                      codigo_barrio_localidad: e.codigo_barrio_localidad,
                      nombre_barrio_localidad: e.nombre_barrio_localidad,       
                      codigo_zona: e.codigo_zona.to_s,       
                      nombre_zona: e.nombre_zona.to_s,
                      codigo_establecimiento: e.codigo_establecimiento.to_s,
                      codigo_institucion: e.codigo_institucion.to_s,
                      nombre_institucion: e.nombre_institucion.to_s,
                      sector_o_tipo_gestion: e.sector_o_tipo_gestion.to_s,
                      matricula_cientifico: e.matricula_cientifico.to_s,
                      matricula_tecnico: e.matricula_tecnico.to_s,
                      matricula_media_abierta: e.matricula_media_abierta.to_s,
                      matricula_formacion_profesional_media: e.matricula_formacion_profesional_media.to_s      

        end

      end


      send_data report.generate, filename: "matriculaciones_educacion_media_#{Time.now.strftime('%d%m%Y__%H%M')}.pdf", 
                                 type: 'application/pdf', 
                                 disposition: 'attachment'

    else

      @matriculaciones_educacion_media_todos = MatriculacionEducacionMedia.orden_dep_dis.where(cond)
      
      respond_to do |f|

        f.js
        f.json {render :json => @matriculaciones_educacion_media_todos }

      end 

    end

  end
end
