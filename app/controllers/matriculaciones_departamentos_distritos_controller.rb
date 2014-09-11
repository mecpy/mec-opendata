class MatriculacionesDepartamentosDistritosController < ApplicationController
  
  def index
    
    @matriculaciones_departamentos_distritos = MatriculacionDepartamentoDistrito.
                                                orden_dep_dis.paginate :per_page => 15, :page => params[:page]
    respond_to do |f|

      f.html {render :layout => 'layouts/application_dataset'}
    end

  end

  def lista

    cond = []
    args = []
    estados = []

    if params[:form_buscar_matriculaciones_departamentos_distritos] &&
        params[:form_buscar_matriculaciones_departamentos_distritos][:anio].present?

      cond << "anio = ?"
      args << params[:form_buscar_matriculaciones_departamentos_distritos][:anio]

    end

    if params[:form_buscar_matriculaciones_departamentos_distritos_nombre_departamento].present?

      cond << "nombre_departamento ilike ?"
      args << "%#{params[:form_buscar_matriculaciones_departamentos_distritos_nombre_departamento]}%"

    end

    if params[:form_buscar_matriculaciones_departamentos_distritos_nombre_distrito].present?

      cond << "nombre_distrito ilike ?"
      args << "%#{params[:form_buscar_matriculaciones_departamentos_distritos_nombre_distrito]}%"

    end

    if params[:form_buscar_matriculaciones_departamentos_distritos_nombre_zona].present?

      cond << "nombre_zona ilike ?"
      args << "%#{params[:form_buscar_matriculaciones_departamentos_distritos_nombre_zona]}%"

    end

    if params[:form_buscar_matriculaciones_departamentos_distritos_sector_o_tipo_gestion].present?

      cond << "sector_o_tipo_gestion ilike ?"
      args << "%#{params[:form_buscar_matriculaciones_departamentos_distritos_sector_o_tipo_gestion]}%"

    end

    if params[:form_buscar_matriculaciones_departamentos_distritos_cantidad_matriculados].present?

      cond << "cantidad_matriculados #{params[:form_buscar_matriculaciones_departamentos_distritos_cantidad_matriculados_operador]} ?"
      args << params[:form_buscar_matriculaciones_departamentos_distritos_cantidad_matriculados]

    end


    cond = cond.join(" and ").lines.to_a + args if cond.size > 0
    puts cond

    @matriculaciones_departamentos_distritos = cond.size > 0 ?
                                                (MatriculacionDepartamentoDistrito.
                                                orden_dep_dis.paginate :conditions => cond, 
                                                                               :per_page => 15,
                                                                               :page => params[:page]) : {}

    @total_registros = MatriculacionDepartamentoDistrito.count 

    if params[:format] == 'csv'

      require 'csv'

      matriculaciones_departamentos_distritos_csv = MatriculacionDepartamentoDistrito.
                                                      orden_dep_dis.find(:all, :conditions => cond)

      csv = CSV.generate do |csv|
        # header row
        csv << ["anio", "codigo_departamento", "nombre_departamento",
         "codigo_distrito", "nombre_distrito", "codigo_zona", "nombre_zona",
         "sector_o_tipo_gestion", "cantidad_matriculados", "anho_cod_geo" ]
 
        # data rows
        matriculaciones_departamentos_distritos_csv.each do |e|
          csv << [e.anio, e.codigo_departamento, 
                  e.nombre_departamento, e.codigo_distrito, e.nombre_distrito,
                  e.codigo_zona, e.nombre_zona,
                  e.sector_o_tipo_gestion, e.cantidad_matriculados, e.anho_cod_geo ]
        end

      end
    
      send_data(csv, :type => 'text/csv', :filename => "matriculaciones_departamentos_distritos_#{Time.now.strftime('%Y%m%d')}.csv")

    elsif params[:format] == 'xlsx'
      
      @matriculaciones_departamentos_distritos = MatriculacionDepartamentoDistrito.
        orden_dep_dis.find(:all, :conditions => cond)

      respond_to do |format|
      
        format.xlsx {
          
          columnas = [:anio, :codigo_departamento, :nombre_departamento, 
            :codigo_distrito, :nombre_distrito, :codigo_zona, :nombre_zona,
            :sector_o_tipo_gestion, :cantidad_matriculados, :anho_cod_geo ] 
          
          send_data MatriculacionDepartamentoDistrito.orden_dep_dis.where(cond).
            to_xlsx(:columns => columnas, :name => "Matriculaciones").to_stream.read, 
            :filename => "matriculaciones_departamentos_distritos_#{Time.now.strftime('%d%m%Y__%H%M')}.xlsx", 
            :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet", 
            disposition: 'attachment'
        }
      
      end

    elsif params[:format] == 'pdf'

      report = ThinReports::Report.new layout: File.join(Rails.root, 'app',
        'reports', 'matriculaciones_departamentos_distritos.tlf')

      matriculaciones_departamentos_distritos = MatriculacionDepartamentoDistrito.
                                                  orden_dep_dis.find(:all, :conditions => cond)
    
      report.start_new_page do |page|
      
        page.item(:fecha_hora).value("Fecha y Hora: #{Time.now.strftime('%d/%m/%Y - %H:%M')}")
    
      end

      matriculaciones_departamentos_distritos.each do |e|
      
        report.list(:matriculaciones_departamentos_distritos).add_row do |row|

          row.values  anio: e.anio,
                      codigo_departamento: e.codigo_departamento.to_s,        
                      nombre_departamento: e.nombre_departamento.to_s,       
                      codigo_distrito: e.codigo_distrito.to_s,       
                      nombre_distrito: e.nombre_distrito.to_s,       
                      codigo_zona: e.codigo_zona.to_s,       
                      nombre_zona: e.nombre_zona.to_s,
                      sector_o_tipo_gestion: e.sector_o_tipo_gestion.to_s,
                      cantidad_matriculados: e.cantidad_matriculados.to_s       

        end

      end


      send_data report.generate, filename: "matriculaciones_departamentos_distritos_#{Time.now.strftime('%d%m%Y__%H%M')}.pdf", 
                                 type: 'application/pdf', 
                                 disposition: 'attachment'

    else

      @matriculaciones_departamentos_distritos_todos = MatriculacionDepartamentoDistrito.
                                                        orden_dep_dis.find(:all, :conditions => cond)
      
      respond_to do |f|

        f.js
        f.json {render :json => @matriculaciones_departamentos_distritos_todos }

      end 

    end

  end
end
