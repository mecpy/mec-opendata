module DesembolsosHelper
  
  def link_to_desembolsos_detalles(desembolso)

    partial = 'link_to_desembolsos_detalles'
    
    rendicion = VRendiciones.where("periodo = ? and pago = ? and codigo_nautilus = ? and codigo_persona = ? and id_tipo_especialidad = ?", desembolso.periodo, desembolso.pago, desembolso.codigo_nautilus, desembolso.codigo_persona, desembolso.id_tipo_especialidad)
    
		render :partial => partial, :locals => {:rendicion => rendicion }

	end
  
  def obtener_total_importe(periodo, pago, codigo_nautilus, codigo_persona, id_tipo_especialidad)
    total = 0
    
    rendicion = VRendiciones.where("periodo = ? and pago = ? and codigo_nautilus = ? and codigo_persona = ? and id_tipo_especialidad = ?", periodo, pago, codigo_nautilus, codigo_persona, id_tipo_especialidad)
    
    rendicion.each do |x|
      total +=  x.importe
    end
    
    total
  end
  
  def obtener_porcentaje_rendicion(periodo, pago, codigo_nautilus, codigo_persona, id_tipo_especialidad)
    
    @desembolso = VDesembolsos.where("periodo = ? and pago = ? and codigo_nautilus = ? and codigo_persona = ? and id_tipo_especialidad = ?", periodo, pago, codigo_nautilus, codigo_persona, id_tipo_especialidad)
    total_desembolso = 0
    total_rendicion = obtener_total_importe(periodo, pago, codigo_nautilus, codigo_persona, id_tipo_especialidad)
    
    @desembolso.each do |d|
      total_desembolso += d.primer_monto_capital + d.primer_monto_corriente + d.segundo_monto_capital + d.segundo_monto_corriente
    end
    
    puts '-------------------'
    puts total_rendicion * 100 / total_desembolso
    
    total_rendicion * 100 / total_desembolso
    
    
    
  end
  
end
