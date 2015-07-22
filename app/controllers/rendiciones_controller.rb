class RendicionesController < ApplicationController
  def index
    @rendiciones = Rendicion.paginate :per_page => 15, :page => params[:page]

    respond_to do |f|

      f.html {render :layout => 'application'}

    end
  end

  def diccionario
    require 'json'
    file = File.read("#{Rails.root}/app/assets/javascripts/diccionario/rendiciones.json")
    @diccionario_rendiciones = JSON.parse(file)
  end

  def lista
    cond = []
    args = []
    estados = []
    
    
    if params[:form_buscar_rendiciones] && params[:form_buscar_rendiciones][:nivel].present?

      cond << "nivel ilike ?"
      args << params[:form_buscar_rendiciones][:nivel]

    end
    

    if params[:form_buscar_rendiciones] && params[:form_buscar_rendiciones][:periodo].present?

      cond << "periodo = ?"
      args << params[:form_buscar_rendiciones][:periodo]

    end
    
    
    if params[:form_buscar_rendiciones] && params[:form_buscar_rendiciones][:pago].present?

      cond << "pago = ?"
      args << params[:form_buscar_rendiciones][:pago]

    end
    
    if params[:form_buscar_rendiciones_codigo_nautilus].present?

      cond << "codigo_nautilus = ?"
      args << params[:form_buscar_rendiciones_codigo_nautilus]

    end
    
    if params[:form_buscar_rendiciones_codigo_establecimiento].present?

      cond << "codigo_establecimiento like ?"
      args << params[:form_buscar_rendiciones_codigo_establecimiento]

    end
    
    if params[:form_buscar_rendiciones_codigo_institucion].present?

      cond << "codigo_institucion like ?"
      args << params[:form_buscar_rendiciones_codigo_institucion]

    end
    
    if params[:form_buscar_rendiciones_denominacion_institucion].present?

      cond << "denominacion_institucion ilike ?"
      args << params[:form_buscar_rendiciones_denominacion_institucion]

    end

    if params[:form_buscar_rendiciones_codigo_persona].present?

      cond << "rtrim(codigo_persona, ' ') = ?"
      args << params[:form_buscar_rendiciones_codigo_persona]

    end

    if params[:form_buscar_rendiciones_nombre_persona].present?

      cond << "rtrim(nombre_persona, ' ') ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_rendiciones_nombre_persona])}%"

    end

    if params[:form_buscar_rendiciones_nombre_departamento].present?

      cond << "nombre_departamento ilike ?"
      args << "%#{params[:form_buscar_rendiciones_nombre_departamento]}%"

    end
    
    if params[:form_buscar_rendiciones_nombre_distrito].present?

      cond << "nombre_distrito ilike ?"
      args << "%#{params[:form_buscar_rendiciones_nombre_distrito]}%"

    end
    
    if params[:form_buscar_rendiciones] && params[:form_buscar_rendiciones][:estado_transferencia_834].present?

      cond << "estado_transferencia_834 ilike ?"
      args << "%#{params[:form_buscar_rendiciones][:estado_transferencia_834]}%"

    end
    
    
    if params[:form_buscar_rendiciones] && params[:form_buscar_rendiciones][:estado_transferencia_894].present?

      cond << "estado_transferencia_894 ilike ?"
      args << "%#{params[:form_buscar_rendiciones][:estado_transferencia_894]}%"

    end
    
    if params[:form_buscar_rendiciones_total].present?

      cond << "total #{params[:form_buscar_rendiciones_total_operador]} ?"
      args << params[:form_buscar_rendiciones_total]

    end
    
    

    cond = cond.join(" and ").lines.to_a + args if cond.size > 0
    
    if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
      @rendiciones = Rendicion.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond).paginate(page: params[:page], per_page: 15)
    else
      @rendiciones = Rendicion.ordenado_periodo_orden_nivel.where(cond).paginate(page: params[:page], per_page: 15)
    end

    @total_registros_encontrados = Rendicion.count :conditions => cond
    @total_registros = Rendicion.count 

    if params[:format] == 'csv'

      require 'csv'
      
      if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
        rendiciones_csv = Rendicion.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond)
      else
        rendiciones_csv = Rendicion.ordenado_periodo_orden_nivel.where(cond)
      end

      csv = CSV.generate do |csv|
        # header row
        
        csv << ["periodo", "pago", "codigo_nautilus", "codigo_establecimiento", "codigo_institucion", "denominacion_institucion", "nombre_departamento", "nombre_distrito", "codigo_persona", "nombre_persona", "tipo_especialidad", "total", "primer_monto_capital", "primer_monto_corriente", "segundo_monto_capital", "segundo_monto_corriente"]
 
        # data rows
        rendiciones_csv.each do |n|
          csv << [n.periodo, n.pago, n.codigo_nautilus, n.codigo_establecimiento, n.codigo_institucion, n.denominacion_institucion, n.nombre_departamento, n.nombre_distrito, n.codigo_persona, n.nombre_persona, n.tipo_especialidad, n.total, n.primer_monto_capital, n.primer_monto_corriente, n.segundo_monto_capital, n.segundo_monto_corriente]
        end

      end
    
      send_data(csv, :type => 'text/csv', :filename => "desembolso_#{Time.now.strftime('%Y%m%d')}.csv")

    elsif params[:format] == 'xlsx'
      
      respond_to do |format|
      
        format.xlsx {
          
          columnas = [:periodo, :pago, :codigo_nautilus, :codigo_establecimiento, :codigo_institucion, :denominacion_institucion, :nombre_departamento, :nombre_distrito, :codigo_persona, :nombre_persona, :tipo_especialidad, :total, :primer_monto_capital, :primer_monto_corriente, :segundo_monto_capital, :segundo_monto_corriente]
          
          if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
            send_data Rendicion.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond).to_xlsx(:columns => columnas).to_stream.read, 
            :filename => "rendicion_#{Time.now.strftime('%d%m%Y__%H%M')}.xlsx", 
            :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet", 
            disposition: 'attachment'
          else
            send_data Rendicion.ordenado_periodo_orden_nivel.where(cond).to_xlsx(:columns => columnas).to_stream.read, 
            :filename => "rendicion_#{Time.now.strftime('%d%m%Y__%H%M')}.xlsx", 
            :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet", 
            disposition: 'attachment'
          end
        }
      
      end

    elsif params[:format] == 'pdf'

      report = ThinReports::Report.new layout: File.join(Rails.root, 'app', 'reports', 'rendiciones.tlf')
      
      if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
        rendicion = Rendicion.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond)
      else
        rendicion = Rendicion.ordenado_periodo_orden_nivel.where(cond)
      end
   
      report.layout.config.list(:desembolso) do
        
        # Define the variables used in list.
        use_stores :total_page => 0

        # Dispatched at list-page-footer insertion.
        events.on :page_footer_insert do |e|
          # e.section.item(:asignacion_total).value(e.store.total_page)
          # e.store.total_report += e.store.total_page
          #e.store.total_page = 0;
        end

        #Dispatched at list-footer insertion.
        events.on :footer_insert do |e|
          #e.section.item(:jerarquia).value(solicitud.jerarquia.descripcion)
          #e.section.item(:solicitante).value(solicitud.solicitante.nombre_completo)
        end
    
      end

      report.start_new_page do |page|
      
        page.item(:fecha_hora).value("Fecha y Hora: #{Time.now.strftime('%d/%m/%Y - %H:%M')}")
    
      end

      rendicion.each do |d|
      
        report.list(:desembolso).add_row do |row|

          row.values  periodo: d.periodo,
            pago: d.pago, 
            codigo_nautilus: d.codigo_nautilus, 
            codigo_establecimiento: d.codigo_establecimiento, 
            codigo_institucion: d.codigo_institucion, 
            denominacion_institucion: d.denominacion_institucion, 
            nombre_departamento: d.nombre_departamento, 
            nombre_distrito: d.nombre_distrito, 
            codigo_persona: d.codigo_persona, 
            nombre_persona: d.nombre_persona, 
            tipo_especialidad: d.tipo_especialidad, 
            total: d.total, 
            primer_monto_capital: d.primer_monto_capital, 
            primer_monto_corriente: d.primer_monto_corriente, 
            segundo_monto_capital: d.segundo_monto_capital, 
            segundo_monto_corriente: d.segundo_monto_corriente
        end

        report.page.list(:desembolso) do |list|
        
          list.store.total_page +=  0

        end

      end

      send_data report.generate, filename: "rendicion_#{Time.now.strftime('%d%m%Y__%H%M')}.pdf", 
        type: 'application/pdf', 
        disposition: 'attachment'

    else

      respond_to do |f|

        f.js

      end 

    end
  end
end
