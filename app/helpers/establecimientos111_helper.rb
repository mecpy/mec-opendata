module Establecimientos111Helper
  def link_to_ubicacion_geografica_111(establecimiento)

		render :partial => 'establecimientos111/link_to_ubicacion_geografica', :locals => {:establecimiento => establecimiento }

	end

  def instituciones_del_establecimiento(establecimiento)

    instituciones = VDirectorioInstitucion.where("codigo_establecimiento = ?", establecimiento.codigo_establecimiento) 

    render :partial => "instituciones_del_establecimiento", :locals => {:instituciones => instituciones}

  end

  def cantidad_total_matriculados(codigo_institucion, codigo_establecimiento)

    total_eeb = MatriculacionEducacionEscolarBasica.filtrar_por_codigo_institucion_and_codigo_establecimiento(codigo_institucion, codigo_establecimiento).sum("total_matriculados")
    total_ei = MatriculacionEducacionInclusiva.filtrar_por_codigo_institucion_and_codigo_establecimiento(codigo_institucion, codigo_establecimiento).sum("matricula_inicial_especial+matricula_primer_y_segundo_ciclo_especial+matricula_tercer_ciclo_especial+matricula_programas_especiales")
    total_ep = MatriculacionEducacionPermanente.filtrar_por_codigo_institucion_and_codigo_establecimiento(codigo_institucion, codigo_establecimiento).sum("matricula_ebbja+matricula_fpi+matricula_emapja+matricula_emdja+matricula_fp")
    total_es = MatriculacionEducacionSuperior.filtrar_por_codigo_institucion_and_codigo_establecimiento(codigo_institucion, codigo_establecimiento).sum("matricula_ets+matricula_fed+matricula_fdes+matricula_pd")
    total_i = MatriculacionInicial.filtrar_por_codigo_institucion_and_codigo_establecimiento(codigo_institucion, codigo_establecimiento).sum("total_matriculados")
    total_em = MatriculacionEducacionMedia.filtrar_por_codigo_institucion_and_codigo_establecimiento(codigo_institucion, codigo_establecimiento).sum("matricula_cientifico+matricula_tecnico+matricula_media_abierta+matricula_formacion_profesional_media")

    (total_eeb.to_i + total_ei.to_i + total_ep.to_i + total_es.to_i + total_i.to_i + total_em.to_i)

  end

  def cantidad_total_matriculados_por_anio(codigo_institucion, codigo_establecimiento, anio)

    total_eeb = MatriculacionEducacionEscolarBasica.filtrar_por_anio(anio).filtrar_por_codigo_institucion_and_codigo_establecimiento(codigo_institucion, codigo_establecimiento).sum("total_matriculados")
    total_ei = MatriculacionEducacionInclusiva.filtrar_por_anio(anio).filtrar_por_codigo_institucion_and_codigo_establecimiento(codigo_institucion, codigo_establecimiento).sum("matricula_inicial_especial+matricula_primer_y_segundo_ciclo_especial+matricula_tercer_ciclo_especial+matricula_programas_especiales")
    total_ep = MatriculacionEducacionPermanente.filtrar_por_anio(anio).filtrar_por_codigo_institucion_and_codigo_establecimiento(codigo_institucion, codigo_establecimiento).sum("matricula_ebbja+matricula_fpi+matricula_emapja+matricula_emdja+matricula_fp")
    total_es = MatriculacionEducacionSuperior.filtrar_por_anio(anio).filtrar_por_codigo_institucion_and_codigo_establecimiento(codigo_institucion, codigo_establecimiento).sum("matricula_ets+matricula_fed+matricula_fdes+matricula_pd")
    total_i = MatriculacionInicial.filtrar_por_anio(anio).filtrar_por_codigo_institucion_and_codigo_establecimiento(codigo_institucion, codigo_establecimiento).sum("total_matriculados")
    total_em = MatriculacionEducacionMedia.filtrar_por_anio(anio).filtrar_por_codigo_institucion_and_codigo_establecimiento(codigo_institucion, codigo_establecimiento).sum("matricula_cientifico+matricula_tecnico+matricula_media_abierta+matricula_formacion_profesional_media")

    (total_eeb.to_i + total_ei.to_i + total_ep.to_i + total_es.to_i + total_i.to_i + total_em.to_i)

  end

  def periodos_establecimientos
    [2014, 2012]
  end
end