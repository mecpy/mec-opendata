class MatriculacionesInicialController < ApplicationController

  def index

    @matriculaciones_inicial = MatriculacionInicial.ordenado_institucion.paginate :per_page => 15, :page => params[:page]

    respond_to do |f|

      f.html {render :layout => 'application_wide'}

    end
  end

  def diccionario

  end

  def lista

    cond = []
    args = []
    estados = []

    if params[:form_buscar_matriculaciones_inicial] && params[:form_buscar_matriculaciones_inicial][:anio].present?

      cond << "anio = ?"
      args << params[:form_buscar_matriculaciones_inicial][:anio]

    end

    if params[:form_buscar_matriculaciones_inicial_codigo_establecimiento].present?

      cond << "codigo_establecimiento ilike ?"
      args << "%#{params[:form_buscar_matriculaciones_inicial_codigo_establecimiento]}%"

    end

    if params[:form_buscar_matriculaciones_inicial_nombre_departamento].present?

      cond << "nombre_departamento ilike ?"
      args << "%#{params[:form_buscar_matriculaciones_inicial_nombre_departamento]}%"

    end

    if params[:form_buscar_matriculaciones_inicial_nombre_distrito].present?

      cond << "nombre_distrito ilike ?"
      args << "%#{params[:form_buscar_matriculaciones_inicial_nombre_distrito]}%"

    end

    if params[:form_buscar_matriculaciones_inicial_nombre_zona].present?

      cond << "nombre_zona ilike ?"
      args << "%#{params[:form_buscar_matriculaciones_inicial_nombre_zona]}%"

    end

    if params[:form_buscar_matriculaciones_inicial_nombre_barrio_localidad].present?

      cond << "nombre_barrio_localidad ilike ?"
      args << "%#{params[:form_buscar_matriculaciones_inicial_nombre_barrio_localidad]}%"

    end

    if params[:form_buscar_matriculaciones_inicial_codigo_institucion].present?

      cond << "codigo_institucion = ?"
      args << params[:form_buscar_matriculaciones_inicial_codigo_institucion]

    end

    if params[:form_buscar_matriculaciones_inicial_nombre_institucion].present?

      cond << "nombre_institucion ilike ?"
      args << "%#{params[:form_buscar_matriculaciones_inicial_nombre_institucion]}%"

    end

    if params[:form_buscar_matriculaciones_inicial_sector_o_tipo_gestion].present?

      cond << "sector_o_tipo_gestion ilike ?"
      args << "%#{params[:form_buscar_matriculaciones_inicial_sector_o_tipo_gestion]}%"

    end
    
    if params[:form_buscar_matriculaciones_inicial_maternal].present?

      cond << "maternal #{params[:form_buscar_matriculaciones_inicial_maternal_operador]} ?"
      args << params[:form_buscar_matriculaciones_inicial_maternal]

    end
    
    if params[:form_buscar_matriculaciones_inicial_prejardin].present?

      cond << "prejardin #{params[:form_buscar_matriculaciones_inicial_prejardin_operador]} ?"
      args << params[:form_buscar_matriculaciones_inicial_prejardin]
     end

    if params[:form_buscar_matriculaciones_inicial_jardin].present?

      cond << "jardin #{params[:form_buscar_matriculaciones_inicial_jardin_operador]} ?"
      args << params[:form_buscar_matriculaciones_inicial_jardin]

    end
   
    if params[:form_buscar_matriculaciones_inicial_preescolar].present?

      cond << "preescolar #{params[:form_buscar_matriculaciones_inicial_preescolar_operador]} ?"
      args << params[:form_buscar_matriculaciones_inicial_preescolar]

    end
   
    if params[:form_buscar_matriculaciones_inicial_total_matriculados].present?

      cond << "total_matriculados #{params[:form_buscar_matriculaciones_inicial_total_matriculados_operador]} ?"
      args << params[:form_buscar_matriculaciones_inicial_total_matriculados]

    end
  
         cond = cond.join(" and ").lines.to_a + args if cond.size > 0

    @matriculaciones_inicial = MatriculacionInicial.ordenado_institucion.where(cond).paginate(page: params[:page], per_page: 15)

    @total_registros = MatriculacionInicial.count 

    if params[:format] == 'csv'

      require 'csv'

      matriculaciones_inicial_csv = MatriculacionInicial.ordenado_institucion.where(cond)

      csv = CSV.generate do |csv|
        # header row
        csv << ["anio", "codigo_establecimiento", "codigo_departamento", "nombre_departamento", "codigo_distrito", "nombre_distrito", "codigo_zona", "nombre_zona", "codigo_barrio_localidad",
                "nombre_barrio_localidad", "codigo_institucion", "nombre_institucion", "sector_o_tipo_gestion", "maternal", "prejardin", "jardin", "preescolar",  "total_matriculados", "anho_cod_geo", "inicial_noformal"]
 
        # data rows
        matriculaciones_inicial_csv.each do |mi|
          csv << [mi.anio, mi.codigo_establecimiento, mi.codigo_departamento, mi.nombre_departamento, mi.codigo_distrito, mi.nombre_distrito, mi.codigo_zona, mi.nombre_zona, mi.codigo_barrio_localidad, mi.nombre_barrio_localidad, mi.sector_o_tipo_gestion, mi.maternal, mi.prejardin, 
      mi.jardin, mi.preescolar, mi.total_matriculados, mi.anho_cod_geo, mi.inicial_noformal ]
        end

      end
    
      send_data(csv, :type => 'text/csv', :filename => "matriculaciones_inicial_#{Time.now.strftime('%Y%m%d')}.csv")

    elsif params[:format] == 'xlsx'
      
      @matriculaciones_inicial = MatriculacionInicial.ordenado_institucion.where(cond)

      p = Axlsx::Package.new
      
      p.workbook.add_worksheet(:name => "Matriculaciones EI") do |sheet|
          
        sheet.add_row [:anio, :codigo_establecimiento, :codigo_departamento, :nombre_departamento, :codigo_distrito, :nombre_distrito, :codigo_zona, :nombre_zona, :codigo_barrio_localidad, :nombre_barrio_localidad, :codigo_institucion, :nombre_institucion, :sector_o_tipo_gestion, :maternal, :prejardin, :jardin, :preescolar, :total_matriculados, :anho_cod_geo, :inicial_noformal ] 
          
        @matriculaciones_inicial.each do |m|
            
          sheet.add_row [m.anio, m.codigo_establecimiento, m.codigo_departamento, m.nombre_departamento, m.codigo_distrito, m.nombre_distrito, m.codigo_zona, m.nombre_zona, m.codigo_barrio_localidad, m.nombre_barrio_localidad, m.codigo_institucion, m.nombre_institucion, m.sector_o_tipo_gestion, m.maternal, m.prejardin, m.jardin, m.preescolar, m.total_matriculados, m.anho_cod_geo, m.inicial_noformal ] 
          
        end

      end
      
      p.use_shared_strings = true
      
      p.serialize('public/data/matriculaciones_inicial_2012.xlsx')
        
      send_file "public/data/matriculaciones_inicial_2012.xlsx", :filename => "matriculaciones_inicial_#{Time.now.strftime('%d%m%Y__%H%M')}.xlsx", :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet", disposition: 'attachment'

    elsif params[:format] == 'pdf'

      report = ThinReports::Report.new layout: File.join(Rails.root, 'app', 'reports', 'matriculaciones_inicial.tlf')

      matriculaciones_inicial = MatriculacionInicial.ordenado_institucion.where(cond)
    
      report.start_new_page do |page|
      
        page.item(:fecha_hora).value("Fecha y Hora: #{Time.now.strftime('%d/%m/%Y - %H:%M')}")
    
      end

      matriculaciones_inicial.each do |mi|
      
        report.list(:matriculaciones_inicial).add_row do |row|

          row.values  anio: mi.anio,
                      codigo_establecimiento: mi.codigo_establecimiento,
                      codigo_departamento: mi.codigo_departamento.to_s,        
                      nombre_departamento: mi.nombre_departamento.to_s,       
                      codigo_distrito: mi.codigo_distrito.to_s,       
                      nombre_distrito: mi.nombre_distrito.to_s,       
                      codigo_zona: mi.codigo_zona.to_s,       
                      nombre_zona: mi.nombre_zona.to_s,       
                      codigo_barrio_localidad: mi.codigo_barrio_localidad.to_s,       
                      nombre_barrio_localidad: mi.nombre_barrio_localidad.to_s,
                      sector_o_tipo_gestion: mi.sector_o_tipo_gestion.to_s,
                      maternal: mi.maternal.to_s,
                      prejardin: mi.prejardin.to_s,
                      jardin: mi.jardin.to_s,
                      preescolar: mi.preescolar.to_s,
                      total_matriculados: mi.total_matriculados.to_s

       end

      end

      send_data report.generate, filename: "matriculaciones_inicial_#{Time.now.strftime('%d%m%Y__%H%M')}.pdf", 
                                 type: 'application/pdf', 
                                 disposition: 'attachment'

    else

      @matriculaciones_inicial_todos = MatriculacionInicial.ordenado_institucion.where(cond)
      
      respond_to do |f|

        f.js
        f.json {render :json => @matriculaciones_inicial_todos }

      end 

    end
  end
end


