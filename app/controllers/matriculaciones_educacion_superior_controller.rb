class MatriculacionesEducacionSuperiorController < ApplicationController
  def index
    @matriculaciones_educacion_superior = MatriculacionEducacionSuperior.
                                                orden_dep_dis.paginate :per_page => 15, :page => params[:page]
    respond_to do |f|

      f.html {render :layout => 'application_wide'}

    end
  end

  def lista

    cond = []
    args = []
    estados = []

    if params[:form_buscar_matriculaciones_educacion_superior] &&
        params[:form_buscar_matriculaciones_educacion_superior][:anio].present?

      cond << "anio = ?"
      args << params[:form_buscar_matriculaciones_educacion_superior][:anio]

    end

    if params[:form_buscar_matriculaciones_educacion_superior_nombre_departamento].present?

      cond << "nombre_departamento ilike ?"
      args << "%#{params[:form_buscar_matriculaciones_educacion_superior_nombre_departamento]}%"

    end

    if params[:form_buscar_matriculaciones_educacion_superior_nombre_distrito].present?

      cond << "nombre_distrito ilike ?"
      args << "%#{params[:form_buscar_matriculaciones_educacion_superior_nombre_distrito]}%"

    end

    if params[:form_buscar_matriculaciones_educacion_superior_nombre_barrio_localidad].present?

      cond << "nombre_barrio_localidad ilike ?"
      args << "%#{params[:form_buscar_matriculaciones_educacion_superior_nombre_barrio_localidad]}%"

    end

    if params[:form_buscar_matriculaciones_educacion_superior_nombre_zona].present?

      cond << "nombre_zona ilike ?"
      args << "%#{params[:form_buscar_matriculaciones_educacion_superior_nombre_zona]}%"

    end

    if params[:form_buscar_matriculaciones_educacion_superior_codigo_establecimiento].present?

      cond << "codigo_establecimiento ilike ?"
      args << "%#{params[:form_buscar_matriculaciones_educacion_superior_codigo_establecimiento]}%"

    end

    if params[:form_buscar_matriculaciones_educacion_superior_nombre_institucion].present?

      cond << "nombre_institucion ilike ?"
      args << "%#{params[:form_buscar_matriculaciones_educacion_superior_nombre_institucion]}%"

    end

    if params[:form_buscar_matriculaciones_educacion_superior_sector_o_tipo_gestion].present?

      cond << "sector_o_tipo_gestion ilike ?"
      args << "%#{params[:form_buscar_matriculaciones_educacion_superior_sector_o_tipo_gestion]}%"

    end


    if params[:form_buscar_matriculaciones_educacion_superior_matricula_ets].present?

      cond << "matricula_ets #{params[:form_buscar_matriculaciones_educacion_superior_matricula_ets_operador]} ?"
      args << params[:form_buscar_matriculaciones_educacion_superior_matricula_ets]

    end


    if params[:form_buscar_matriculaciones_educacion_superior_matricula_fed].present?

      cond << "matricula_fed #{params[:form_buscar_matriculaciones_educacion_superior_matricula_fed_operador]} ?"
      args << params[:form_buscar_matriculaciones_educacion_superior_matricula_fed]

    end


    if params[:form_buscar_matriculaciones_educacion_superior_matricula_fdes].present?

      cond << "matricula_fdes #{params[:form_buscar_matriculaciones_educacion_superior_matricula_fdes_operador]} ?"
      args << params[:form_buscar_matriculaciones_educacion_superior_matricula_fdes]

    end


    if params[:form_buscar_matriculaciones_educacion_superior_matricula_pd].present?

      cond << "matricula_pd #{params[:form_buscar_matriculaciones_educacion_superior_matricula_pd_operador]} ?"
      args << params[:form_buscar_matriculaciones_educacion_superior_matricula_pd]

    end

    cond = cond.join(" and ").lines.to_a + args if cond.size > 0

    @matriculaciones_educacion_superior = cond.size > 0 ?
                                                (MatriculacionEducacionSuperior.
                                                orden_dep_dis.paginate :conditions => cond, 
                                                                               :per_page => 15,
                                                                               :page => params[:page]) : {}

    @total_registros = MatriculacionEducacionSuperior.count 

    if params[:format] == 'csv'

      require 'csv'

      matriculaciones_educacion_superior_csv = MatriculacionEducacionSuperior.
                                                      orden_dep_dis.find(:all, :conditions => cond)

      csv = CSV.generate do |csv|
        # header row
        csv << ["anio", "codigo_departamento", "nombre_departamento",
         "codigo_distrito", "nombre_distrito", "codigo_barrio_localidad",
         "nombre_barrio_localidad", "codigo_zona", "nombre_zona",
         "codigo_establecimiento", "codigo_institucion", "nombre_institucion",
         "sector_o_tipo_gestion", "matricula_ets", "matricula_fed", 
         "matricula_fdes", "matricula_pd"]
 
        # data rows
        matriculaciones_educacion_superior_csv.each do |e|
          csv << [e.anio, e.codigo_departamento, 
                  e.nombre_departamento, e.codigo_distrito, e.nombre_distrito,
                  e.codigo_barrio_localidad, e.nombre_barrio_localidad,
                  e.codigo_zona, e.nombre_zona, e.codigo_establecimiento,
                  e.codigo_institucion, e.nombre_institucion,
                  e.sector_o_tipo_gestion, e.matricula_ets, e.matricula_fed,
                  e.matricula_fdes, e.matricula_pd]
        end

      end
    
      send_data(csv, :type => 'text/csv', :filename => "matriculaciones_educacion_superior_#{Time.now.strftime('%Y%m%d')}.csv")

    elsif params[:format] == 'xlsx'
      
      @matriculaciones_educacion_superior = MatriculacionEducacionSuperior.
        orden_dep_dis.find(:all, :conditions => cond)

      respond_to do |format|
      
        format.xlsx {
          
          columnas = [:anio, :codigo_departamento, :nombre_departamento, 
            :codigo_distrito, :nombre_distrito, :codigo_barrio_localidad,
            :nombre_barrio_localidad, :codigo_zona, :nombre_zona, 
            :codigo_establecimiento, :codigo_institucion, :nombre_institucion,
            :sector_o_tipo_gestion, :matricula_ets, :matricula_fed,
            :matricula_fdes, :matricula_pd] 
          
          send_data MatriculacionEducacionSuperior.orden_dep_dis.where(cond).
            to_xlsx(:columns => columnas, :name => "Matriculaciones").to_stream.read, 
            :filename => "matriculaciones_educacion_superior_#{Time.now.strftime('%d%m%Y__%H%M')}.xlsx", 
            :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet", 
            disposition: 'attachment'
        }
      
      end

    elsif params[:format] == 'pdf'

      report = ThinReports::Report.new layout: File.join(Rails.root, 'app',
        'reports', 'matriculaciones_educacion_superior.tlf')

      matriculaciones_educacion_superior = MatriculacionEducacionSuperior.
                                                  orden_dep_dis.find(:all, :conditions => cond)
    
      report.start_new_page do |page|
      
        page.item(:fecha_hora).value("Fecha y Hora: #{Time.now.strftime('%d/%m/%Y - %H:%M')}")
    
      end

      matriculaciones_educacion_superior.each do |e|
      
        report.list(:matriculaciones_educacion_superior).add_row do |row|

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
                      matricula_ets: e.matricula_ets.to_s,
                      matricula_fed: e.matricula_fed.to_s,
                      matricula_fdes: e.matricula_fdes.to_s,
                      matricula_pd: e.matricula_pd.to_s      

        end

      end


      send_data report.generate, filename: "matriculaciones_educacion_superior_#{Time.now.strftime('%d%m%Y__%H%M')}.pdf", 
                                 type: 'application/pdf', 
                                 disposition: 'attachment'

    else

      @matriculaciones_educacion_superior_todos = MatriculacionEducacionSuperior.
                                                        orden_dep_dis.find(:all, :conditions => cond)
      
      respond_to do |f|

        f.js
        f.json {render :json => @matriculaciones_educacion_superior_todos }

      end 

    end

  end
end
