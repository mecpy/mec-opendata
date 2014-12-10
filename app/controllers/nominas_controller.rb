# -*- encoding : utf-8 -*-
class NominasController< ApplicationController
  before_filter :redireccionar_uri
  def diccionario

  end

  def index
    
    respond_to do |f|

      f.html {render :layout => 'layouts/application_dataset'}
  
    end
  end

  def lista

    cond = []
    args = []
    estados = []

    if params[:form_buscar_nominas] && params[:form_buscar_nominas][:ano_periodo_pago].present?

      cond << "ano_periodo_pago = ?"
      args << params[:form_buscar_nominas][:ano_periodo_pago]

    end

    if params[:form_buscar_nominas] && params[:form_buscar_nominas][:mes_periodo_pago].present?

      cond << "mes_periodo_pago = ?"
      args << params[:form_buscar_nominas][:mes_periodo_pago]

    end

    if params[:form_buscar_nominas_codigo_trabajador].present?

      cond << "rtrim(codigo_trabajador, ' ') = ?"
      args << params[:form_buscar_nominas_codigo_trabajador]

    end

    if params[:form_buscar_nominas_nombre_trabajador].present?

      cond << "rtrim(nombre_trabajador, ' ') ilike ?"
      args << "%#{params[:form_buscar_nominas_nombre_trabajador]}%"

    end

    if params[:form_buscar_nominas_nombre_objeto_gasto].present?

      cond << "nombre_objeto_gasto ilike ?"
      args << "%#{params[:form_buscar_nominas_nombre_objeto_gasto]}%"

    end

    if params[:form_buscar_nominas_estado].present?

      cond << "estado ilike ?"
      args << "%#{params[:form_buscar_nominas_estado]}%"

    end

    if params[:form_buscar_nominas_antiguedad_administrativo].present?

      cond << "antiguedad_administrativo ilike ?"
      args << "%#{params[:form_buscar_nominas_antiguedad_administrativo]}%"

    end

    if params[:form_buscar_nominas_asignacion].present?

      cond << "asignacion #{params[:form_buscar_nominas_asignacion_operador]} ?"
      args << params[:form_buscar_nominas_asignacion]

    end

    cond = cond.join(" and ").lines.to_a + args if cond.size > 0

    @nomina = cond.size > 0 ? (VNomina.es_administrativo.ordenado_anio_mes_nombre.paginate :conditions => cond, :per_page => 15, :page => params[:page]) : {}

    #@total_registros_encontrados = VNomina.count :conditions => cond
    #@total_registros = VNomina.count 

    if params[:format] == 'csv'

      require 'csv'

      nominas_csv = Nomina.ordenado_anio_mes_nombre.where(cond)

      csv = CSV.generate do |csv|
        # header row
        csv << ["mes_periodo_pago", "ano_periodo_pago", "codigo_concepto_nomina", "nombre_concepto_nomina", "codigo_trabajador", "nombre_trabajador", "anhos_antiguedad_administrativo", "meses_antiguedad_administrativo", "anhos_antiguedad_docente", "meses_antiguedad_docente", "codigo_puesto", "numero_tipo_presupuesto_puesto", "codigo_dependencia", "nombre_dependencia", "codigo_cargo", "nombre_cargo", "codigo_categoria_rubro", "monto_categoria_rubro", "cantidad", "asignacion"]
 
        # data rows
        nominas_csv.each do |n|
          csv << [n.mes_periodo_pago, n.ano_periodo_pago, n.codigo_concepto_nomina, n.nombre_concepto_nomina, n.codigo_trabajador, n.nombre_trabajador, n.anhos_antiguedad_administrativo, n.meses_antiguedad_administrativo, n.anhos_antiguedad_docente, n.meses_antiguedad_docente, n.codigo_puesto, n.numero_tipo_presupuesto_puesto, n.codigo_dependencia, n.nombre_dependencia, n.codigo_cargo, n.nombre_cargo, n.codigo_categoria_rubro, n.monto_categoria_rubro, n.cantidad, n.asignacion]
        end

      end
    
      send_data(csv, :type => 'text/csv', :filename => "nomina_#{Time.now.strftime('%Y%m%d')}.csv")

    elsif params[:format] == 'xlsx'
      
      respond_to do |format|
      
        format.xlsx {
          
          columnas = [:mes_periodo_pago, :ano_periodo_pago, :codigo_concepto_nomina, :nombre_concepto_nomina, :codigo_trabajador, :nombre_trabajador, :anhos_antiguedad_administrativo, :meses_antiguedad_administrativo, :anhos_antiguedad_docente, :meses_antiguedad_docente, :codigo_puesto, :numero_tipo_presupuesto_puesto, :codigo_dependencia, :nombre_dependencia, :codigo_cargo, :nombre_cargo, :codigo_categoria_rubro, :monto_categoria_rubro, :cantidad, :asignacion]
          
          send_data Nomina.ordenado_anio_mes_nombre.where(cond).to_xlsx(:columns => columnas).to_stream.read, 
                    :filename => "nomina_#{Time.now.strftime('%d%m%Y__%H%M')}.xlsx", 
                    :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet", 
                    disposition: 'attachment'
        }
      
      end

    elsif params[:format] == 'pdf'

      report = ThinReports::Report.new layout: File.join(Rails.root, 'app', 'reports', 'funcionario_administrativo.tlf')

      nomina = Nomina.es_administrativo.ordenado_anio_mes_nombre.where(cond)
   
      report.layout.config.list(:nomina) do
        
        # Define the variables used in list.
        use_stores :total_page => 0

        # Dispatched at list-page-footer insertion.
        events.on :page_footer_insert do |e|
          e.section.item(:asignacion_total).value(e.store.total_page)
          #e.store.total_report += e.store.total_page
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

      nomina.each do |n|
      
        report.list(:nomina).add_row do |row|

          row.values  mes_periodo_pago: n.mes_periodo_pago,
                      ano_periodo_pago: n.ano_periodo_pago,
                      codigo_trabajador: n.codigo_trabajador,        
                      nombre_trabajador: n.nombre_trabajador,       
                      nombre_objeto_gasto: "#{n.nombre_objeto_gasto} (#{n.codigo_objeto_gasto})",       
                      estado: obtener_estado_funcionario(n.numero_tipo_presupuesto_puesto),
                      antiguedad: "#{n.anhos_antiguedad_administrativo} año/s y #{n.meses_antiguedad_administrativo} mes/es",       
                      nombre_concepto_nomina: n.nombre_concepto_nomina,       
                      nombre_dependencia: n.nombre_dependencia_efectiva,       
                      nombre_cargo: n.nombre_cargo_efectivo,       
                      codigo_categoria_rubro: n.codigo_categoria_rubro,       
                      monto_categoria_rubro: n.monto_categoria_rubro,       
                      cantidad: n.cantidad.to_i,     
                      asignacion: n.asignacion,
                      monto_devuelto: n.monto_devuelto

        end

        report.page.list(:nomina) do |list|
        
          list.store.total_page +=  n.asignacion

        end

      end


      send_data report.generate, filename: "funcionario_administrativo_#{Time.now.strftime('%d%m%Y__%H%M')}.pdf", 
                                 type: 'application/pdf', 
                                 disposition: 'attachment'

    else

      #nomina = Nomina.ordenado_anio_mes_nombre.where(cond)
      #@nomina_todos = VNomina.ordenado_anio_mes_nombre.where(cond)
      
      respond_to do |f|

        f.js
        #f.json {render :json => nomina }

      end 

    end

  end

  def detalles

    @nomina = Nomina.es_administrativo.where("id_trabajador = ? and id_objeto_gasto = ? 
    and ano_periodo_pago = ? and mes_periodo_pago = ?", 
    params[:id_trabajador], params[:id_objeto_gasto], params[:ano_periodo_pago], params[:mes_periodo_pago])

    respond_to do |f|

      f.js

    end

  end

  def docentes_diccionario

  end
  
  def docentes

    respond_to do |f|

      f.html {render :layout => 'application_wide'}

    end

  end

  def docentes_lista

    cond = []
    args = []
    estados = []

    if params[:form_buscar_nominas] && params[:form_buscar_nominas][:ano_periodo_pago].present?

      cond << "ano_periodo_pago = ?"
      args << params[:form_buscar_nominas][:ano_periodo_pago]

    end

    if params[:form_buscar_nominas] && params[:form_buscar_nominas][:mes_periodo_pago].present?

      cond << "mes_periodo_pago = ?"
      args << params[:form_buscar_nominas][:mes_periodo_pago]

    end

    if params[:form_buscar_nominas_codigo_trabajador].present?

      cond << "rtrim(codigo_trabajador, ' ') = ?"
      args << params[:form_buscar_nominas_codigo_trabajador]

    end

    if params[:form_buscar_nominas_nombre_trabajador].present?

      cond << "rtrim(nombre_trabajador, ' ') ilike ?"
      args << "%#{params[:form_buscar_nominas_nombre_trabajador]}%"

    end

    if params[:form_buscar_nominas_nombre_objeto_gasto].present?

      cond << "nombre_objeto_gasto ilike ?"
      args << "%#{params[:form_buscar_nominas_nombre_objeto_gasto]}%"

    end

    if params[:form_buscar_nominas_estado].present?

      cond << "estado ilike ?"
      args << "%#{params[:form_buscar_nominas_estado]}%"

    end

    if params[:form_buscar_nominas_antiguedad_docente].present?

      cond << "antiguedad_docente ilike ?"
      args << "%#{params[:form_buscar_nominas_antiguedad_docente]}%"

    end

    if params[:form_buscar_nominas_numero_matriculacion].present?

      cond << "numero_matriculacion = ?"
      args << params[:form_buscar_nominas_numero_matriculacion]

    end

    if params[:form_buscar_nominas_asignacion].present?

      cond << "asignacion #{params[:form_buscar_nominas_asignacion_operador]} ?"
      args << params[:form_buscar_nominas_asignacion]

    end

    cond = cond.join(" and ").lines.to_a + args if cond.size > 0

    @nomina = cond.size > 0 ? (VNomina.es_docente.ordenado_anio_mes_nombre.paginate :conditions => cond, :per_page => 15, :page => params[:page]) : {}

    #@total_registros_encontrados = VNomina.count :conditions => cond
    #@total_registros = VNomina.count 

    if params[:format] == 'csv'

      require 'csv'

      nominas_csv = Nomina.ordenado_anio_mes_nombre.where(cond)

      csv = CSV.generate do |csv|
        # header row
        csv << ["mes_periodo_pago", "ano_periodo_pago", "codigo_concepto_nomina", "nombre_concepto_nomina", "codigo_trabajador", "nombre_trabajador", "anhos_antiguedad_administrativo", "meses_antiguedad_administrativo", "anhos_antiguedad_docente", "meses_antiguedad_docente", "codigo_puesto", "numero_tipo_presupuesto_puesto", "codigo_dependencia", "nombre_dependencia", "codigo_cargo", "nombre_cargo", "codigo_categoria_rubro", "monto_categoria_rubro", "cantidad", "asignacion"]
 
        # data rows
        nominas_csv.each do |n|
          csv << [n.mes_periodo_pago, n.ano_periodo_pago, n.codigo_concepto_nomina, n.nombre_concepto_nomina, n.codigo_trabajador, n.nombre_trabajador, n.anhos_antiguedad_administrativo, n.meses_antiguedad_administrativo, n.anhos_antiguedad_docente, n.meses_antiguedad_docente, n.codigo_puesto, n.numero_tipo_presupuesto_puesto, n.codigo_dependencia, n.nombre_dependencia, n.codigo_cargo, n.nombre_cargo, n.codigo_categoria_rubro, n.monto_categoria_rubro, n.cantidad, n.asignacion]
        end

      end
    
      send_data(csv, :type => 'text/csv', :filename => "nomina_#{Time.now.strftime('%Y%m%d')}.csv")

    elsif params[:format] == 'xlsx'
      
      respond_to do |format|
      
        format.xlsx {
          
          columnas = [:mes_periodo_pago, :ano_periodo_pago, :codigo_concepto_nomina, :nombre_concepto_nomina, :codigo_trabajador, :nombre_trabajador, :anhos_antiguedad_administrativo, :meses_antiguedad_administrativo, :anhos_antiguedad_docente, :meses_antiguedad_docente, :codigo_puesto, :numero_tipo_presupuesto_puesto, :codigo_dependencia, :nombre_dependencia, :codigo_cargo, :nombre_cargo, :codigo_categoria_rubro, :monto_categoria_rubro, :cantidad, :asignacion]
          
          send_data Nomina.ordenado_anio_mes_nombre.where(cond).to_xlsx(:columns => columnas).to_stream.read, 
                    :filename => "nomina_#{Time.now.strftime('%d%m%Y__%H%M')}.xlsx", 
                    :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet", 
                    disposition: 'attachment'
        }
      
      end

    elsif params[:format] == 'pdf'

      report = ThinReports::Report.new layout: File.join(Rails.root, 'app', 'reports', 'funcionario_docente.tlf')

      nomina = Nomina.es_docente.ordenado_anio_mes_nombre.where(cond)
   
      report.layout.config.list(:nomina) do
        
        # Define the variables used in list.
        use_stores :total_page => 0

        # Dispatched at list-page-footer insertion.
        events.on :page_footer_insert do |e|
          e.section.item(:asignacion_total).value(e.store.total_page)
          #e.store.total_report += e.store.total_page
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

      nomina.each do |n|
      
        report.list(:nomina).add_row do |row|

          row.values  mes_periodo_pago: n.mes_periodo_pago,
                      ano_periodo_pago: n.ano_periodo_pago,
                      codigo_trabajador: n.codigo_trabajador,        
                      nombre_trabajador: n.nombre_trabajador,       
                      nombre_objeto_gasto: "#{n.nombre_objeto_gasto} (#{n.codigo_objeto_gasto})",       
                      estado: obtener_estado_funcionario(n.numero_tipo_presupuesto_puesto),
                      antiguedad: "#{n.anhos_antiguedad_docente} año/s y #{n.meses_antiguedad_docente} mes/es",       
                      nombre_concepto_nomina: n.nombre_concepto_nomina,       
                      nombre_dependencia: n.nombre_dependencia_efectiva,       
                      nombre_cargo: n.nombre_cargo_efectivo,       
                      codigo_categoria_rubro: n.codigo_categoria_rubro,       
                      monto_categoria_rubro: n.monto_categoria_rubro,       
                      cantidad: n.cantidad.to_i, 
                      numero_matriculacion: n.numero_matriculacion,       
                      asignacion: n.asignacion

        end

        report.page.list(:nomina) do |list|
        
          list.store.total_page +=  n.asignacion

        end

      end


      send_data report.generate, filename: "funcionario_docente_#{Time.now.strftime('%d%m%Y__%H%M')}.pdf", 
                                 type: 'application/pdf', 
                                 disposition: 'attachment'

    else


      #nomina = Nomina.ordenado_anio_mes_nombre.where(cond)
      #@nomina_todos = VNomina.ordenado_anio_mes_nombre.where(cond)
      
      respond_to do |f|

        f.js
        #f.json {render :json => nomina }

      end 

    end

  end

  def docentes_detalles

    @nomina = Nomina.es_docente.where("id_trabajador = ? and id_objeto_gasto = ? and ano_periodo_pago = ? 
    and mes_periodo_pago = ?", params[:id_trabajador], params[:id_objeto_gasto],
     params[:ano_periodo_pago], params[:mes_periodo_pago])

    respond_to do |f|

      f.js

    end

  end
  
    
  
  def docentes_doc
   
     @cnomina = VNomina.find_by_codigo_trabajador(params[:codigo_trabajador],:order => 'mes_periodo_pago DESC')
     @dnomina = VNomina.where("codigo_trabajador = ? ",@cnomina.codigo_trabajador) if @cnomina.present? 
    
    respond_to do |f|

      f.html
      #f.js

    end
    
         
   end
   
   def administrativo_doc
   
     @adminnomina = VNomina.find_by_codigo_trabajador(params[:codigo_trabajador],:order => 'mes_periodo_pago DESC')
     @adnomina = VNomina.where("codigo_trabajador = ? ",@adminnomina.codigo_trabajador) if @adminnomina.present? 
    
    respond_to do |f|

      f.html

    end
    
         
   end
  

end
