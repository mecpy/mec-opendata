class ContratacionesController < ApplicationController

  def index

    respond_to do |f|

      f.html {render :layout => 'application'}

    end

  end
  
  def diccionario

    require 'json'
    file = File.read("#{Rails.root}/app/assets/javascripts/diccionario/contrataciones.json")
    diccionario = JSON.parse(file)
    @diccionario_contrataciones = clean_json(diccionario)

    if params[:format] == 'json'
      
      generate_json_table_schema(@diccionario_contrataciones)

    elsif params[:format] == 'pdf'
      
      send_data(generate_pdf(@diccionario_contrataciones, params[:nombre]), :filename => "diccionario_contrataciones.pdf", :type => "application/pdf")

    end
    
  end

  def lista

    cond = []
    args = []
    estados = []

    if params[:form_buscar_contrataciones] && params[:form_buscar_contrataciones][:ejercicio_fiscal].present?

      cond << "ejercicio_fiscal = ?"
      args << params[:form_buscar_contrataciones][:ejercicio_fiscal]

    end

    if params[:form_buscar_contrataciones_llamado_publico].present?

      cond << "llamado_publico = ?"
      args << params[:form_buscar_contrataciones_llamado_publico]

    end

    if params[:form_buscar_contrataciones_nombre].present?

      cond << "nombre ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_contrataciones_nombre])}%"

    end


    if params[:form_buscar_contrataciones_descripcion].present?

      cond << "descripcion ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_contrataciones_descripcion])}%"

    end

    if params[:form_buscar_contrataciones_fecha_contrato].present?

      cond << "fecha_contrato = ?"
      args << params[:form_buscar_contrataciones_fecha_contrato]

    end
    
    if params[:form_buscar_contrataciones_fecha_apertura_oferta].present?

      cond << "fecha_apertura_oferta = ?"
      args << params[:form_buscar_contrataciones_fecha_apertura_oferta]

    end
    
    if params[:form_buscar_contrataciones_fecha_vigencia_contrato].present?

      cond << "fecha_vigencia_contrato = ?"
      args << params[:form_buscar_contrataciones_fecha_vigencia_contrato]

    end

    if params[:form_buscar_contrataciones_estado_llamado].present?

      cond << "estado_llamado ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_contrataciones_estado_llamado])}%"

    end

    if params[:form_buscar_contrataciones_modalidad].present?

      cond << "modalidad ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_contrataciones_modalidad])}%"

    end

    if params[:form_buscar_contrataciones_categoria].present?

      cond << "categoria ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_contrataciones_catetoria])}%"

    end

    if params[:form_buscar_contrataciones_proveedor_adjudicado].present?

      cond << "proveedor_ruc || ' ' || proveedor  ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_contrataciones_proveedor_adjudicado])}%"

    end

    if params[:form_buscar_contrataciones_monto_adjudicado].present?

      cond << "monto_adjudicado #{params[:form_buscar_contrataciones_monto_adjudicado_operador]} ?"
      args << params[:form_buscar_contrataciones_monto_adjudicado]

    end

    cond = cond.join(" and ").lines.to_a + args if cond.size > 0
    
    if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
      @contrataciones = Contratacion.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond).paginate(page: params[:page], per_page: 15)
    else
      @contrataciones = Contratacion.where(cond).paginate(page: params[:page], per_page: 15)
    end

    @total_registros = Contratacion.count 

    if params[:format] == 'csv'

      require 'csv'
      
      if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
        contrataciones_csv = Contratacion.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond)
      else
        contrataciones_csv = Contratacion.where(cond)
      end

      csv = CSV.generate do |csv|
        # header row
        csv << ["llamado_publico", "estado_llamado_id", "estado_llamado", "ejercicio_fiscal", "categoria_id", "categoria", "nombre", "descripcion", "fecha_apertura_oferta", "fecha_contrato", "fecha_vigencia_contrato", "proveedor_id", "proveedor_ruc", "proveedor", "modalidad_id", "modalidad", "monto_adjudicado"]
 
        # data rows
        contrataciones_csv.each do |c|
          csv << [ c.llamado_publico, c.estado_llamado_id, c.estado_llamado, c.ejercicio_fiscal, c.categoria_id, c.categoria, c.nombre, c.descripcion, c.fecha_apertura_oferta, c.fecha_contrato,c.fecha_vigencia_contrato, c.proveedor_id, c.proveedor_ruc, c.proveedor, c.modalidad_id, c.modalidad, c.monto_adjudicado ]
        end

      end
    
      send_data(csv, :type => 'text/csv', :filename => "contrataciones_#{Time.now.strftime('%Y%m%d')}.csv")

    elsif params[:format] == 'xlsx'
      
      if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
        contrataciones_xlsx = Contratacion.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond)
      else
        contrataciones_xlsx = Contratacion.where(cond)
      end
       
      p = Axlsx::Package.new
        
      p.workbook.add_worksheet(:name => "Contrataciones") do |sheet|
          
        sheet.add_row ["llamado_publico", "estado_llamado_id", "estado_llamado", "ejercicio_fiscal", "categoria_id", "categoria", "nombre", "descripcion", "fecha_apertura_oferta", "fecha_contrato", "fecha_vigencia_contrato", "proveedor_id", "proveedor_ruc", "proveedor", "modalidad_id", "modalidad", "monto_adjudicado"]

        contrataciones_xlsx.each do |c|
              
          sheet.add_row [ c.llamado_publico, c.estado_llamado_id, c.estado_llamado, c.ejercicio_fiscal, c.categoria_id, c.categoria, c.nombre, c.descripcion, c.fecha_apertura_oferta, c.fecha_contrato,c.fecha_vigencia_contrato, c.proveedor_id, c.proveedor_ruc, c.proveedor, c.modalidad_id, c.modalidad, c.monto_adjudicado ]
                
        end

      end
            
      p.use_shared_strings = true
      
      send_data p.to_stream.read, filename: "contrataciones_#{Time.now.strftime('%d%m%Y__%H%M')}.xlsx", :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet", disposition: 'attachment'

    else
      
      if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
        @contrataciones_todos = Contratacion.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond)
      else
        @contrataciones_todos = Contratacion.where(cond)
      end
      
      respond_to do |f|

        f.js
        f.json {render :json => @contrataciones_todos }

      end 

    end

  end

end
