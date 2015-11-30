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

    [["enero", 1],["febrero", 2],["marzo", 3], ["abril", 4], ["mayo", 5], ["junio", 6], ["julio", 7],["agosto", 8], ["setiembre", 9], ["octubre", 10], ["noviembre", 11], ["diciembre", 12]]
  
  end

  def obtener_ultimo_periodo_mes(tipo_nomina)
    # tipo_nomina=1 -> 'es_administrativo' ; tipo_nomina=0 -> 'es_docente'
    anios = Nomina.select(:ano_periodo_pago).order(ano_periodo_pago: :desc).limit(1)

    if tipo_nomina == 1
      @nomina_ultimo = Nomina.select("ano_periodo_pago", "mes_periodo_pago").es_administrativo.where("ano_periodo_pago = ?", anios[0].ano_periodo_pago).order(mes_periodo_pago: :desc).limit(1)
    else
      @nomina_ultimo = Nomina.select("ano_periodo_pago", "mes_periodo_pago").es_docente.where("ano_periodo_pago = ?", anios[0].ano_periodo_pago).order(mes_periodo_pago: :desc).limit(1)
    end
  end

end
