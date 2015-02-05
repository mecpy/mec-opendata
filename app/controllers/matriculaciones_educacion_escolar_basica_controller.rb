class MatriculacionesEducacionEscolarBasicaController < ApplicationController

  def index

    @matriculaciones_educacion_escolar_basica = MatriculacionEducacionEscolarBasica.ordenado_institucion.paginate :per_page => 15, :page => params[:page]

    respond_to do |f|

      f.html {render :layout => 'application'}

    end
  end

  def diccionario

  end

  def lista

    cond = []
    args = []
    estados = []

    if params[:form_buscar_matriculaciones_educacion_escolar_basica] && params[:form_buscar_matriculaciones_educacion_escolar_basica][:anio].present?

      cond << "anio = ?"
      args << params[:form_buscar_matriculaciones_educacion_escolar_basica][:anio]

    end

    if params[:form_buscar_matriculaciones_educacion_escolar_basica_codigo_establecimiento].present?

      cond << "codigo_establecimiento ilike ?"
      args << "%#{params[:form_buscar_matriculaciones_educacion_escolar_basica_codigo_establecimiento]}%"

    end

    if params[:form_buscar_matriculaciones_educacion_escolar_basica_nombre_departamento].present?

      cond << "nombre_departamento ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_matriculaciones_educacion_escolar_basica_nombre_departamento])}%"

    end

    if params[:form_buscar_matriculaciones_educacion_escolar_basica_nombre_distrito].present?

      cond << "nombre_distrito ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_matriculaciones_educacion_escolar_basica_nombre_distrito])}%"

    end

    if params[:form_buscar_matriculaciones_educacion_escolar_basica_nombre_zona].present?

      cond << "nombre_zona ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_matriculaciones_educacion_escolar_basica_nombre_zona])}%"

    end

    if params[:form_buscar_matriculaciones_educacion_escolar_basica_nombre_barrio_localidad].present?

      cond << "nombre_barrio_localidad ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_matriculaciones_educacion_escolar_basica_nombre_barrio_localidad])}%"

    end

    if params[:form_buscar_matriculaciones_educacion_escolar_basica_codigo_institucion].present?

      cond << "codigo_institucion = ?"
      args << params[:form_buscar_matriculaciones_educacion_escolar_basica_codigo_institucion]

    end

    if params[:form_buscar_matriculaciones_educacion_escolar_basica_nombre_institucion].present?

      cond << "nombre_institucion ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_matriculaciones_educacion_escolar_basica_nombre_institucion])}%"

    end

    if params[:form_buscar_matriculaciones_educacion_escolar_basica_sector_o_tipo_gestion].present?

      cond << "sector_o_tipo_gestion ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_matriculaciones_educacion_escolar_basica_sector_o_tipo_gestion])}%"

    end
    
    if params[:form_buscar_matriculaciones_educacion_escolar_basica_primer_grado].present?

      cond << "primer_grado #{params[:form_buscar_matriculaciones_educacion_escolar_basica_primer_grado_operador]} ?"
      args << params[:form_buscar_matriculaciones_educacion_escolar_basica_primer_grado]

    end
    
    if params[:form_buscar_matriculaciones_educacion_escolar_basica_segundo_grado].present?

      cond << "segundo_grado #{params[:form_buscar_matriculaciones_educacion_escolar_basica_segundo_grado_operador]} ?"
      args << params[:form_buscar_matriculaciones_educacion_escolar_basica_segundo_grado]
    end

    if params[:form_buscar_matriculaciones_educacion_escolar_basica_tercer_grado].present?

      cond << "tercer_grado #{params[:form_buscar_matriculaciones_educacion_escolar_basica_tercer_grado_operador]} ?"
      args << params[:form_buscar_matriculaciones_educacion_escolar_basica_tercer_grado]

    end
   
    if params[:form_buscar_matriculaciones_educacion_escolar_basica_cuarto_grado].present?

      cond << "cuarto_grado #{params[:form_buscar_matriculaciones_educacion_escolar_basica_cuarto_grado_operador]} ?"
      args << params[:form_buscar_matriculaciones_educacion_escolar_basica_cuarto_grado]

    end
   
    if params[:form_buscar_matriculaciones_educacion_escolar_basica_quinto_grado].present?

      cond << "quinto_grado #{params[:form_buscar_matriculaciones_educacion_escolar_basica_quinto_grado_operador]} ?"
      args << params[:form_buscar_matriculaciones_educacion_escolar_basica_quinto_grado]

    end
  
    if params[:form_buscar_matriculaciones_educacion_escolar_basica_sexto_grado].present?

      cond << "sexto_grado #{params[:form_buscar_matriculaciones_educacion_escolar_basica_sexto_grado_operador]} ?"
      args << params[:form_buscar_matriculaciones_educacion_escolar_basica_sexto_grado]

    end
 
    if params[:form_buscar_matriculaciones_educacion_escolar_basica_septimo_grado].present?

      cond << "septimo_grado #{params[:form_buscar_matriculaciones_educacion_escolar_basica_septimo_grado_operador]} ?"
      args << params[:form_buscar_matriculaciones_educacion_escolar_basica_septimo_grado]
    end

    if params[:form_buscar_matriculaciones_educacion_escolar_basica_octavo_grado].present?

      cond << "octavo_grado #{params[:form_buscar_matriculaciones_educacion_escolar_basica_octavo_grado_operador]} ?"
      args << params[:form_buscar_matriculaciones_educacion_escolar_basica_octavo_grado]
    end


    if params[:form_buscar_matriculaciones_educacion_escolar_basica_noveno_grado].present?

      cond << "noveno_grado #{params[:form_buscar_matriculaciones_educacion_escolar_basica_noveno_grado_operador]} ?"
      args << params[:form_buscar_matriculaciones_educacion_escolar_basica_noveno_grado]

    end

    if params[:form_buscar_matriculaciones_educacion_escolar_basica_total_matriculados].present?

      cond << "total_matriculados #{params[:form_buscar_matriculaciones_educacion_escolar_basica_total_matriculados_operador]} ?"
      args << params[:form_buscar_matriculaciones_educacion_escolar_basica_total_matriculados]

    end

    cond = cond.join(" and ").lines.to_a + args if cond.size > 0
                                                                         
    @matriculaciones_educacion_escolar_basica = MatriculacionEducacionEscolarBasica.ordenado_institucion.where(cond).paginate(page: params[:page], per_page: 15)


    @total_registros = MatriculacionEducacionEscolarBasica.count 

    if params[:format] == 'csv'

      require 'csv'

      matriculaciones_educacion_escolar_basica_csv = MatriculacionEducacionEscolarBasica.ordenado_institucion.where(cond)

      csv = CSV.generate do |csv|
        csv << ["anio", "codigo_establecimiento", "codigo_departamento", "nombre_departamento", "codigo_distrito", "nombre_distrito", "codigo_zona", "nombre_zona", "codigo_barrio_localidad",
          "nombre_barrio_localidad", "codigo_institucion", "nombre_institucion", "sector_o_tipo_gestion", "primer_grado", "segundo_grado", "tercer_grado", "cuarto_grado", "quinto_grado", "sexto_grado", "septimo_grado", "octavo_grado", "noveno_grado", "total_matriculados", "anho_cod_geo" ]
 
        matriculaciones_educacion_escolar_basica_csv.each do |meeb|
          csv << [meeb.anio, meeb.codigo_establecimiento, meeb.codigo_departamento, meeb.nombre_departamento, meeb.codigo_distrito, meeb.nombre_distrito, meeb.codigo_zona, meeb.nombre_zona, meeb.codigo_barrio_localidad, meeb.nombre_barrio_localidad, meeb.sector_o_tipo_gestion, meeb.codigo_institucion, meeb.nombre_institucion,
            meeb.primer_grado, meeb.segundo_grado, meeb.tercer_grado, meeb.cuarto_grado, meeb.quinto_grado, meeb.sexto_grado, meeb.septimo_grado, meeb.octavo_grado, meeb.noveno_grado, meeb.total_matriculados, meeb.anho_cod_geo ]
        end

      end
    
      send_data(csv, :type => 'text/csv', :filename => "matriculaciones_educacion_escolar_basica_#{Time.now.strftime('%Y%m%d')}.csv")

    elsif params[:format] == 'xlsx'
      
      @matriculaciones_educacion_escolar_basica = MatriculacionEducacionEscolarBasica.ordenado_institucion.where(cond)

      p = Axlsx::Package.new
      
      p.workbook.add_worksheet(:name => "Matriculaciones EEB") do |sheet|
          
        sheet.add_row [:anio, :codigo_establecimiento, :codigo_departamento, :nombre_departamento, :codigo_distrito, :nombre_distrito, :codigo_zona, :nombre_zona, :codigo_barrio_localidad,
          :nombre_barrio_localidad, :sector_o_tipo_gestion, :codigo_institucion, :nombre_institucion, :primer_grado, :segundo_grado, :tercer_grado, :cuarto_grado, :quinto_grado, :sexto_grado, :septimo_grado, :octavo_grado, :noveno_grado, :total_matriculados, :anho_cod_geo ]
          
        @matriculaciones_educacion_escolar_basica.each do |meeb|
            
          sheet.add_row [meeb.anio, meeb.codigo_establecimiento, meeb.codigo_departamento, meeb.nombre_departamento, meeb.codigo_distrito, meeb.nombre_distrito, meeb.codigo_zona, meeb.nombre_zona, meeb.codigo_barrio_localidad,
            meeb.nombre_barrio_localidad, meeb.sector_o_tipo_gestion, meeb.codigo_institucion, meeb.nombre_institucion, meeb.primer_grado, meeb.segundo_grado, meeb.tercer_grado, meeb.cuarto_grado, meeb.quinto_grado, meeb.sexto_grado, meeb.septimo_grado, meeb.octavo_grado, meeb.noveno_grado, meeb.total_matriculados, meeb.anho_cod_geo ]
          
        end

      end
      
      p.use_shared_strings = true
      
      send_data p.to_stream.read, filename: "matriculaciones_educacion_escolar_basica_#{Time.now.strftime('%d%m%Y__%H%M')}.xlsx", :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet", disposition: 'attachment'
      
    elsif params[:format] == 'pdf'

      report = ThinReports::Report.new layout: File.join(Rails.root, 'app', 'reports', 'matriculaciones_educacion_escolar_basica.tlf')

      matriculaciones_educacion_escolar_basica = MatriculacionEducacionEscolarBasica.ordenado_institucion.where(cond)
    
      report.start_new_page do |page|
      
        page.item(:fecha_hora).value("Fecha y Hora: #{Time.now.strftime('%d/%m/%Y - %H:%M')}")
    
      end

      matriculaciones_educacion_escolar_basica.each do |meeb|
      
        report.list(:matriculaciones_educacion_escolar_basica).add_row do |row|

          row.values  anio: meeb.anio,
            codigo_establecimiento: meeb.codigo_establecimiento,
            codigo_departamento: meeb.codigo_departamento.to_s,        
            nombre_departamento: meeb.nombre_departamento.to_s,       
            codigo_distrito: meeb.codigo_distrito.to_s,       
            nombre_distrito: meeb.nombre_distrito.to_s,       
            codigo_zona: meeb.codigo_zona.to_s,       
            nombre_zona: meeb.nombre_zona.to_s,       
            codigo_barrio_localidad: meeb.codigo_barrio_localidad.to_s,       
            nombre_barrio_localidad: meeb.nombre_barrio_localidad.to_s,
            sector_o_tipo_gestion: meeb.sector_o_tipo_gestion.to_s,
            primer_grado: meeb.primer_grado.to_s,
            segundo_grado: meeb.segundo_grado.to_s,
            tercer_grado: meeb.tercer_grado.to_s,
            cuarto_grado: meeb.cuarto_grado.to_s,
            quinto_grado: meeb.quinto_grado.to_s,
            sexto_grado: meeb.sexto_grado.to_s,
            septimo_grado: meeb.septimo_grado.to_s,
            octavo_grado: meeb.octavo_grado.to_s,
            noveno_grado: meeb.noveno_grado.to_s,
            total_matriculados: meeb.total_matriculados.to_s

        end

      end

      send_data report.generate, filename: "matriculaciones_educacion_escolar_basica_#{Time.now.strftime('%d%m%Y__%H%M')}.pdf", 
        type: 'application/pdf', 
        disposition: 'attachment'

    else

      @matriculaciones_educacion_escolar_basica_todos = MatriculacionEducacionEscolarBasica.ordenado_institucion.where(cond)
      
      respond_to do |f|

        f.js
        f.json {render :json => @matriculaciones_educacion_escolar_basica_todos }

      end 

    end
  end
end


