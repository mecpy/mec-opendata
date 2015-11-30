class ProductosController < ApplicationController
  
  before_filter :redireccionar_uri

  def index

    @productos = Producto.paginate :per_page => 15, :page => params[:page]

    respond_to do |f|

      f.html {render :layout => 'application'}

    end

  end

  def diccionario
    
    require 'json'
    file = File.read("#{Rails.root}/app/assets/javascripts/diccionario/productos.json")
    diccionario = JSON.parse(file)
    @diccionario_productos = clean_json(diccionario)

    if params[:format] == 'json'
      
      generate_json_table_schema(@diccionario_productos)

    elsif params[:format] == 'pdf'
      
      send_data(generate_pdf(@diccionario_productos, params[:nombre]), :filename => "diccionario_productos.pdf", :type => "application/pdf")

    end

  end

  def lista

    cond = []
    args = []
    estados = []

    if params[:form_buscar_productos_producto_codigo].present?

      cond << "producto_codigo ilike ?"
      args << "%#{params[:form_buscar_productos_producto_codigo]}%"

    end

    if params[:form_buscar_productos_objeto_gasto_codigo].present?

      cond << "objeto_gasto_codigo = ?"
      args << "#{params[:form_buscar_productos_objeto_gasto_codigo]}"

    end

    if params[:form_buscar_productos_objeto_gasto].present?

      cond << "objeto_gasto ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_productos_objeto_gasto])}%"

    end

    if params[:form_buscar_productos_naturaleza_producto].present?

      cond << "naturaleza_producto ilike ?"
      args << "%#{params[:form_buscar_productos_naturaleza_producto]}%"

    end
    
    if params[:form_buscar_productos_concepto_codigo].present?

      cond << "concepto_codigo = ?"
      args << "#{params[:form_buscar_productos_concepto_codigo]}"

    end

    if params[:form_buscar_productos_concepto].present?

      cond << "concepto ilike ?"
      args << "%#{params[:form_buscar_productos_concepto]}%"

    end

    if params[:form_buscar_productos_codigo_clasificador_bien].present?

      cond << "codigo_clasificador_bien = ?"
      args << params[:form_buscar_productos_codigo_clasificador_bien]

    end

    if params[:form_buscar_productos_clasificador_bien].present?

      cond << "clasificador_bien ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_productos_clasificador_bien])}%"

    end

    if params[:form_buscar_productos_descripcion].present?

      cond << "descripcion ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_productos_descripcion])}%"

    end

    if params[:form_buscar_productos_unidad_medida].present?

      cond << "unidad_medida ilike ?"
      args << "%#{quita_acentos(params[:form_buscar_productos_unidad_medida])}%"

    end

    if params[:form_buscar_productos_cantidad_maxima].present?

      cond << "cantidad_maxima #{params[:form_buscar_productos_cantidad_maxima_operador]} ?"
      args << params[:form_buscar_productos_cantidad_maxima]

    end

    if params[:form_buscar_productos_cantidad_minima].present?

      cond << "cantidad_minima #{params[:form_buscar_productos_cantidad_minima_operador]} ?"
      args << params[:form_buscar_productos_cantidad_minima]

    end

    if params[:form_buscar_productos_cantidad_actual].present?

      cond << "cantidad_actual #{params[:form_buscar_productos_cantidad_actual_operador]} ?"
      args << params[:form_buscar_productos_cantidad_actual]

    end

    cond = cond.join(" and ").lines.to_a + args if cond.size > 0
    
    if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
      
      @productos = Producto.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond).paginate(page: params[:page], per_page: 15)
    
    else
      
      @productos = Producto.order("objeto_gasto, naturaleza_producto, concepto").where(cond).paginate(page: params[:page], per_page: 15)
    
    end

    @total_registros = Producto.count 

    if params[:format] == 'csv'

      require 'csv'
      
      if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
    
        productos_csv = Producto.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond).all
      
      else
        
        productos_csv = Producto.order("objeto_gasto, naturaleza_producto, concepto").where(cond).all
      
      end

      csv = CSV.generate do |csv|

        # header row
        csv << ["producto_codigo, objeto_gasto_codigo, objeto_gasto, naturaleza_producto, concepto_codigo, concepto, codigo_clasificador_bien, clasificador_bien, descripcion, unidad_medida, cantidad_maxima, cantidad_minima, cantidad_actual"]
 
        # data rows
        productos_csv.each do |p|
          csv << [p.producto_codigo, p.objeto_gasto_codigo, p.objeto_gasto, p.naturaleza_producto, p.concepto_codigo, p.concepto, p.codigo_clasificador_bien, p.clasificador_bien, p.descripcion, p.unidad_medida, p.cantidad_maxima, p.cantidad_minima, p.cantidad_actual]
        end

      end
    
      send_data(csv, :type => 'text/csv', :filename => "inventarios_#{Time.now.strftime('%Y%m%d')}.csv")

    elsif params[:format] == 'xlsx'
      
      if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
        productos_xlsx = Producto.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond).all
      else
        productos_xlsx = Producto.order("objeto_gasto, naturaleza_producto, concepto").where(cond).all
      end
       
      px = Axlsx::Package.new
        
      px.workbook.add_worksheet(:name => "Inventarios") do |sheet|
          
        sheet.add_row [ :producto_codigo, :objeto_gasto_codigo, :objeto_gasto, :naturaleza_producto, :concepto_codigo, :concepto, :codigo_clasificador_bien, :clasificador_bien, :descripcion, :unidad_medida, :cantidad_maxima, :cantidad_minima, :cantidad_actual ]

        productos_xlsx.each do |p|
              
          sheet.add_row [p.producto_codigo, p.objeto_gasto_codigo, p.objeto_gasto, p.naturaleza_producto, p.concepto_codigo, p.concepto, p.codigo_clasificador_bien, p.clasificador_bien, p.descripcion, p.unidad_medida, p.cantidad_maxima, p.cantidad_minima, p.cantidad_actual]
                
        end

      end
            
      px.use_shared_strings = true
      
      send_data px.to_stream.read, filename: "inventarios_#{Time.now.strftime('%d%m%Y__%H%M')}.xlsx", :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet", disposition: 'attachment'

    elsif params[:format] == 'json'
      
      if params[:ordenacion_columna].present? && params[:ordenacion_direccion].present?
        productos_json = Producto.order(params[:ordenacion_columna] + " " + params[:ordenacion_direccion]).where(cond)
      else
        productos_json = Producto.order("objeto_gasto, naturaleza_producto, concepto").where(cond)
      end
      
      respond_to do |f|

        f.js
        f.json {render :json => productos_json }

      end
    
    else
      
      @productos_todos = Producto.order("objeto_gasto, naturaleza_producto, concepto").where(cond).all

    end

  end
 
end
