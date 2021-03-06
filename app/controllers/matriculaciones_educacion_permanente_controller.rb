class MatriculacionesEducacionPermanenteController < ApplicationController

  def index
    @matriculaciones_educacion_permanente = MatriculacionEducacionPermanente.
                                                orden_dep_dis.paginate :per_page => 15, :page => params[:page]
    respond_to do |f|

      f.html {render :layout => 'application_wide'}

    end
  end

  def lista

    cond = []
    args = []
    estados = []

    if params[:form_buscar_matriculaciones_educacion_permanente] &&
        params[:form_buscar_matriculaciones_educacion_permanente][:anio].present?

      cond << "anio = ?"
      args << params[:form_buscar_matriculaciones_educacion_permanente][:anio]

    end


    if params[:form_buscar_matriculaciones_educacion_permanente_codigo_establecimiento].present?

      cond << "codigo_establecimiento ilike ?"
      args << "%#{params[:form_buscar_matriculaciones_educacion_permanente_codigo_establecimiento]}%"

    end

    if params[:form_buscar_matriculaciones_educacion_permanente_nombre_departamento].present?

      cond << "nombre_departamento ilike ?"
      args << "%#{params[:form_buscar_matriculaciones_educacion_permanente_nombre_departamento]}%"

    end

    if params[:form_buscar_matriculaciones_educacion_permanente_nombre_distrito].present?

      cond << "nombre_distrito ilike ?"
      args << "%#{params[:form_buscar_matriculaciones_educacion_permanente_nombre_distrito]}%"

    end

    if params[:form_buscar_matriculaciones_educacion_permanente_nombre_zona].present?

      cond << "nombre_zona ilike ?"
      args << "%#{params[:form_buscar_matriculaciones_educacion_permanente_nombre_zona]}%"

    end

    if params[:form_buscar_matriculaciones_educacion_permanente_nombre_barrio_localidad].present?

      cond << "nombre_barrio_localidad ilike ?"
      args << "%#{params[:form_buscar_matriculaciones_educacion_permanente_nombre_barrio_localidad]}%"

    end

    if params[:form_buscar_matriculaciones_educacion_permanente_sector_o_tipo_gestion].present?

      cond << "sector_o_tipo_gestion ilike ?"
      args << "%#{params[:form_buscar_matriculaciones_educacion_permanente_sector_o_tipo_gestion]}%"

    end

    if params[:form_buscar_matriculaciones_educacion_permanente_codigo_institucion].present?

      cond << "codigo_institucion = ?"
      args << params[:form_buscar_matriculaciones_educacion_permanente_codigo_institucion]

    end

    if params[:form_buscar_matriculaciones_educacion_permanente_nombre_institucion].present?

      cond << "nombre_institucion ilike ?"
      args << "%#{params[:form_buscar_matriculaciones_educacion_permanente_nombre_institucion]}%"

    end

    if params[:form_buscar_matriculaciones_educacion_permanente_matricula_ebbja].present?

      cond << "matricula_ebbja #{params[:form_buscar_matriculaciones_educacion_permanente_matricula_ebbja_operador]} ?"
      args << params[:form_buscar_matriculaciones_educacion_permanente_matricula_ebbja]

    end

    if params[:form_buscar_matriculaciones_educacion_permanente_matricula_fpi].present?

      cond << "matricula_fpi #{params[:form_buscar_matriculaciones_educacion_permanente_matricula_fpi_operador]} ?"
      args << params[:form_buscar_matriculaciones_educacion_permanente_matricula_fpi]
    end

    if params[:form_buscar_matriculaciones_educacion_permanente_matricula_emapja].present?

      cond << "matricula_emapja #{params[:form_buscar_matriculaciones_educacion_permanente_matricula_emapja_operador]} ?"
      args << params[:form_buscar_matriculaciones_educacion_permanente_matricula_emapja]

    end
   
    if params[:form_buscar_matriculaciones_educacion_permanente_matricula_emdja].present?

      cond << "matricula_emdja #{params[:form_buscar_matriculaciones_educacion_permanente_matricula_emdja_operador]} ?"
      args << params[:form_buscar_matriculaciones_educacion_permanente_matricula_emdja]

    end
   
    if params[:form_buscar_matriculaciones_educacion_permanente_matricula_fp].present?

      cond << "matricula_fp #{params[:form_buscar_matriculaciones_educacion_permanente_matricula_fp_operador]} ?"
      args << params[:form_buscar_matriculaciones_educacion_permanente_matricula_fp]

    end

    cond = cond.join(" and ").lines.to_a + args if cond.size > 0

    @matriculaciones_educacion_permanente = cond.size > 0 ?
                                                (MatriculacionEducacionPermanente.
                                                orden_dep_dis.paginate :conditions => cond, 
                                                                               :per_page => 15,
                                                                               :page => params[:page]) : {}

    @total_registros = MatriculacionEducacionPermanente.count 

    if params[:format] == 'csv'

      require 'csv'

      matriculaciones_educacion_permanente_csv = MatriculacionEducacionPermanente.
                                                      orden_dep_dis.find(:all, :conditions => cond)

      csv = CSV.generate do |csv|
        # header row
        csv << ["anio", "codigo_departamento", "nombre_departamento",
         "codigo_distrito", "nombre_distrito", "codigo_zona", "nombre_zona",
         "sector_o_tipo_gestion", "cantidad_matriculados", "codigo_institucion","nombre_institucion", "matricula_ebbja",
         "matricula_fpi", "matricula_emapja", "matricula_emdja", "matricula_fp", "anho_cod_geo" ]
 
        # data rows
        matriculaciones_educacion_permanente_csv.each do |p|
          csv << [p.anio, p.codigo_departamento, 
                  p.nombre_departamento, p.codigo_distrito, p.nombre_distrito,
                  p.codigo_zona, p.nombre_zona,
                  p.sector_o_tipo_gestion, p.codigo_institucion, p.nombre_institucion, p.matricula_ebbja,
                  p.matricula_fpi, p.matricula_emapja, p.matricula_emdja, p.matricula_fp, p.anho_cod_geo ]
        end

      end
      
      send_data(csv, :type => 'text/csv', :filename => "matriculaciones_educacion_permanente_#{Time.now.strftime('%Y%m%d')}.csv")

    elsif params[:format] == 'xlsx'
      
      @matriculaciones_educacion_permanente = MatriculacionEducacionPermanente.
        orden_dep_dis.find(:all, :conditions => cond)

      respond_to do |format|
      
        format.xlsx {
          
          columnas = [:anio, :codigo_departamento, :nombre_departamento, 
            :codigo_distrito, :nombre_distrito, :codigo_zona, :nombre_zona,
            :sector_o_tipo_gestion, :codigo_institucion, :nombre_institucion, :matricula_ebbja,
            :matricula_fpi, :matricula_emapja, :matricula_emdja, :matricula_fp, :anho_cod_geo ] 
          
          send_data MatriculacionEducacionPermanente.orden_dep_dis.where(cond).
            to_xlsx(:columns => columnas, :name => "Matriculaciones").to_stream.read, 
            :filename => "matriculaciones_educacion_permanente_#{Time.now.strftime('%d%m%Y__%H%M')}.xlsx", 
            :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet", 
            disposition: 'attachment'
        }
      
      end

    elsif params[:format] == 'pdf'

      report = ThinReports::Report.new layout: File.join(Rails.root, 'app',
        'reports', 'matriculaciones_educacion_permanente.tlf')

      matriculaciones_educacion_permanente = MatriculacionEducacionPermanente.
                                                  orden_dep_dis.find(:all, :conditions => cond)
    
      report.start_new_page do |page|
      
        page.item(:fecha_hora).value("Fecha y Hora: #{Time.now.strftime('%d/%m/%Y - %H:%M')}")
    
      end

      matriculaciones_educacion_permanente.each do |p|
      
        report.list(:matriculaciones_educacion_permanente).add_row do |row|

          row.values  anio: p.anio,
                      codigo_departamento: p.codigo_departamento.to_s,        
                      nombre_departamento: p.nombre_departamento.to_s,       
                      codigo_distrito: p.codigo_distrito.to_s,       
                      nombre_distrito: p.nombre_distrito.to_s,       
                      codigo_zona: p.codigo_zona.to_s,       
                      nombre_zona: p.nombre_zona.to_s,
                      sector_o_tipo_gestion: p.sector_o_tipo_gestion.to_s,
                      codigo_institucion: p.codigo_institucion.to_s,
                      nombre_institucion: p.nombre_institucion.to_s,
                      matricula_ebbja: p.matricula_ebbja.to_s,
                      matricula_fpi: p.matricula_fpi.to_s,
                      matricula_emapja: p.matricula_emapja.to_s,
                      matricula_emdja: p.matricula_emdja.to_s,
                      matricula_fp: p.matricula_fp.to_s   

        end
 
                     
      end


      send_data report.generate, filename: "matriculaciones_educacion_permanente_#{Time.now.strftime('%d%m%Y__%H%M')}.pdf", 
                                 type: 'application/pdf', 
                                 disposition: 'attachment'

    else

      @matriculaciones_educacion_permanente_todos = MatriculacionEducacionPermanente.
                                                        orden_dep_dis.find(:all, :conditions => cond)
      
      respond_to do |f|

        f.js
        f.json {render :json => @matriculaciones_educacion_permanente_todos }

      end 

    end

  end
end
