module MatriculacionesEducacionEscolarBasicaHelper
  
  def url_def_matriculaciones_educacion_escolar_basica

    Rails.env == "development" ? def_matriculaciones_educacion_escolar_basica_url : "#{PARAMETRO[:subdominio]}def/matriculaciones_educacion_escolar_basica"

  end

  def url_data_matriculaciones_educacion_escolar_basica

    Rails.env == "development" ? data_matriculaciones_educacion_escolar_basica_url : "#{PARAMETRO[:subdominio]}data/matriculaciones_educacion_escolar_basica"

  end

  def url_data_matriculaciones_educacion_escolar_basica_lista(parametros_development, parametros_production)

    Rails.env == "development" ? data_matriculaciones_educacion_escolar_basica_lista_url(parametros_development) : "#{PARAMETRO[:subdominio]}data/matriculaciones_educacion_escolar_basica_lista#{parametros_production}"

  end


  

end
