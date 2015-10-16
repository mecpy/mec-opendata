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
    diccionario = JSON.parse(file)
    @diccionario_rendiciones = clean_json(diccionario)

    if params[:format] == 'json'
      
      generate_json_table_schema(@diccionario_rendiciones)

    elsif params[:format] == 'pdf'
      
      send_data(generate_pdf(@diccionario_rendiciones, params[:nombre]), :filename => "diccionario_rendiciones.pdf", :type => "application/pdf")

    end

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
      
      rendiciones_csv = Rendicion.ordenado_periodo_orden_nivel.where(cond)
      
      #if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
      #  rendiciones_csv = Rendicion.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond)
     # else
      #  rendiciones_csv = Rendicion.ordenado_periodo_orden_nivel.where(cond)
     # end

      csv = CSV.generate do |csv|
        # header row
        
        csv << ["nivel", "periodo","pago", "codigo_establecimiento", "codigo_institucion", "denominacion_institucion", "nombre_departamento", "nombre_distrito", "codigo_persona", "nombre_persona", "monto_desembolso_834", "monto_rendicion_834", "saldo_rendicion_834", "estado_transferencia_834", "monto_desembolso_894", "monto_rendicion_894", "saldo_rendicion_894", "estado_transferencia_894" ]
 
        # data rows
        rendiciones_csv.each do |n|
          csv << [n.nivel, n.periodo, n.codigo_establecimiento, n.codigo_institucion, n.denominacion_institucion, n.nombre_departamento, n.nombre_distrito, n.codigo_persona, n.nombre_persona, n.monto_desembolso_834, n.monto_rendicion_834, n.saldo_rendicion_834, n.estado_transferencia_834, n.monto_desembolso_894, n.monto_rendicion_894, n.saldo_rendicion_894, n.estado_transferencia_894]
        end

      end
    
      send_data(csv, :type => 'text/csv', :filename => "rendicion_#{Time.now.strftime('%Y%m%d')}.csv")

    elsif params[:format] == 'xlsx'

      if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
        rendiciones_xlsx = Rendicion.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond)
        #       send_data Rendicion.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond).to_xlsx(:columns => columnas).to_stream.read, 
        #       :filename => "rendicion_#{Time.now.strftime('%d%m%Y__%H%M')}.xlsx", 
        #       :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet", 
        #       disposition: 'attachment'
      else
        rendiciones_xlsx = Rendicion.ordenado_periodo_orden_nivel.where(cond)
        #       send_data Rendicion.ordenado_periodo_orden_nivel.where(cond).to_xlsx(:columns => columnas).to_stream.read, 
        #       :filename => "rendicion_#{Time.now.strftime('%d%m%Y__%H%M')}.xlsx", 
        #       :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet", 
        #       disposition: 'attachment'
      end

      
      p = Axlsx::Package.new
        
      p.workbook.add_worksheet(:name => "Rendiciones") do |sheet|
          
        sheet.add_row [:nivel, :periodo, :pago, :codigo_establecimiento, :codigo_institucion, :denominacion_institucion, :nombre_departamento, :nombre_distrito, :codigo_persona, :nombre_persona, :monto_desembolso_834, :monto_rendicion_834, :saldo_rendicion_834, :estado_transferencia_834, :monto_desembolso_894, :monto_rendicion_894, :saldo_rendicion_894, :estado_transferencia_894] 

        rendiciones_xlsx.each do |r|
              
          sheet.add_row [r.nivel, r.periodo, r.pago, r.codigo_establecimiento, r.codigo_institucion, r.denominacion_institucion, r.nombre_departamento, r.nombre_distrito, r.codigo_persona, r.nombre_persona, r.monto_desembolso_834, r.monto_rendicion_834, r.saldo_rendicion_834, r.estado_transferencia_834, r.monto_desembolso_894, r.monto_rendicion_894, r.saldo_rendicion_894, r.estado_transferencia_894]
                
        end

      end
            
      p.use_shared_strings = true
      
      send_data p.to_stream.read, filename: "rendiciones_#{Time.now.strftime('%d%m%Y__%H%M')}.xlsx", :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet", disposition: 'attachment'
      
      
      
      # respond_to do |format|
      
      #   format.xlsx {
          
      #     columnas = [:nivel, :periodo, :pago, :codigo_nautilus, :codigo_establecimiento, :codigo_institucion, :denominacion_institucion, :nombre_departamento, :nombre_distrito, :codigo_persona, :nombre_persona, :monto_desembolso_834, :monto_rendicion_834, :saldo_rendicion_834, :estado_transferencia_834, :monto_desembolso_894, :monto_rendicion_894, :saldo_rendicion_894, :estado_transferencia_894]
          
      #     if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
      #       send_data Rendicion.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond).to_xlsx(:columns => columnas).to_stream.read, 
      #       :filename => "rendicion_#{Time.now.strftime('%d%m%Y__%H%M')}.xlsx", 
      #       :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet", 
      #       disposition: 'attachment'
      #     else
      #       send_data Rendicion.ordenado_periodo_orden_nivel.where(cond).to_xlsx(:columns => columnas).to_stream.read, 
      #       :filename => "rendicion_#{Time.now.strftime('%d%m%Y__%H%M')}.xlsx", 
      #       :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet", 
      #       disposition: 'attachment'
      #     end
      #   }
      
      # end

    elsif params[:format] == 'pdf'

      report = ThinReports::Report.new layout: File.join(Rails.root, 'app', 'reports', 'rendiciones.tlf')
      
      if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
        rendicion = Rendicion.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond)
      else
        rendicion = Rendicion.ordenado_periodo_orden_nivel.where(cond)
      end
   
      report.layout.config.list(:rendicion) do
        
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

      rendicion.each do |r|
      
        report.list(:rendicion).add_row do |row|

          row.values  nivel: r.nivel,
            periodo: r.periodo, 
            pago: r.pago, 
            codigo_establecimiento: r.codigo_establecimiento, 
            codigo_institucion: r.codigo_institucion, 
            denominacion_institucion: r.denominacion_institucion, 
            nombre_departamento: r.nombre_departamento, 
            nombre_distrito: r.nombre_distrito, 
            codigo_persona: r.codigo_persona, 
            nombre_persona: r.nombre_persona, 
            monto_desembolso_834: r.monto_desembolso_834, 
            monto_rendicion_834: r.monto_rendicion_834, 
            saldo_rendicion_834: r.saldo_rendicion_834, 
            estado_transferencia_834: r.estado_transferencia_834, 
            monto_desembolso_894: r.monto_desembolso_894, 
            monto_rendicion_894: r.monto_rendicion_894, 
            saldo_rendicion_894: r.saldo_rendicion_894, 
            estado_transferencia_894: r.estado_transferencia_894
        end

        report.page.list(:rendicion) do |list|
        
          list.store.total_page +=  0

        end

      end

      send_data report.generate, filename: "rendicion_#{Time.now.strftime('%d%m%Y__%H%M')}.pdf", 
        type: 'application/pdf', 
        disposition: 'attachment'

    else
      if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
        @rendiciones_todos = Rendicion.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond)
      else
        @rendiciones_todos = Rendicion.ordenado_periodo_orden_nivel.where(cond)
      end
      
      respond_to do |f|

        f.js
        f.json {render :json => @rendiciones_todos , :methods => :uri}

      end 
    end
  end
end
