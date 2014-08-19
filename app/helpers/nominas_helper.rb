module NominasHelper

  def link_to_nominas_detalles(nomina)

    partial = (nomina.es_categoria_administrativa == 1) ? 'link_to_nominas_detalles' : 'link_to_nomina_docentes_detalles'

		render :partial => partial, :locals => {:nomina => nomina }

	end

  def obtener_total_asignacion(id_trabajador, id_objeto_gasto, es_categoria_administrativa, ano_periodo_pago, mes_periodo_pago)

    nomina = VNomina.find_all_by_id_trabajador_and_id_objeto_gasto_and_es_categoria_administrativa_and_ano_periodo_pago_and_mes_periodo_pago(id_trabajador, id_objeto_gasto, es_categoria_administrativa, ano_periodo_pago, mes_periodo_pago)
    
    asignacion = 0

    nomina.each do |n|
      asignacion += n.asignacion
    end

    asignacion

  end

end
