module NominasHelper

  def link_to_nominas_detalles(nomina)

    partial = (nomina.es_categoria_administrativa == 1) ? 'link_to_nominas_detalles' : 'link_to_nomina_docentes_detalles'

		render :partial => partial, :locals => {:nomina => nomina }

	end

  def obtener_total_asignacion(id_trabajador, id_objeto_gasto, es_categoria_administrativa, ano_periodo_pago, mes_periodo_pago)

    nomina=VNomina.where('id_trabajador = ? and id_objeto_gasto = ? and es_categoria_administrativa = ? and ano_periodo_pago = ? and mes_periodo_pago = ?', id_trabajador, id_objeto_gasto, es_categoria_administrativa, ano_periodo_pago, mes_periodo_pago)
    
    asignacion = 0

    nomina.each do |n|
      asignacion += n.asignacion
    end

    asignacion

  end

  def options_periodos_nominas

    [2015, 2014]

  end

  def options_meses_nominas

    [["enero", 1],["febrero", 2],["marzo", 3], ["abril", 4], ["junio", 5], ["julio", 7],["agosto", 8], ["setiembre", 9], ["octubre", 10], ["noviembre", 11], ["diciembre", 12]]
  
  end

end
