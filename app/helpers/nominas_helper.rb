module NominasHelper

  def link_to_nominas_detalles(nomina)

    partial = (nomina.es_categoria_administrativa == 1) ? 'link_to_nominas_detalles' : 'link_to_nomina_docentes_detalles'

		render :partial => partial, :locals => {:nomina => nomina }

	end

  def obtener_total_asignacion(id_trabajador, id_objeto_gasto, es_categoria_administrativa)

    nomina = VNomina.find_all_by_id_trabajador_and_id_objeto_gasto_and_es_categoria_administrativa(id_trabajador, id_objeto_gasto, es_categoria_administrativa)
    
    asignacion = 0

    nomina.each do |n|
      asignacion += n.asignacion
    end

    asignacion

  end

end
