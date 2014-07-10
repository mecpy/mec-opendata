module MatriculacionesEducacionInclusivaHelper
  
  def url_def_matriculaciones_educacion_inclusiva

    Rails.env == "development" ? def_matriculaciones_educacion_inclusiva_url : "#{PARAMETRO[:subdominio]}def/matriculaciones_educacion_inclusiva"
  end

  def url_data_matriculaciones_educacion_inclusiva

    Rails.env == "development" ? data_matriculaciones_educacion_inclusiva_url : "#{PARAMETRO[:subdominio]}data/matriculaciones_educacion_inclusiva"

  end

  def url_data_matriculaciones_educacion_inclusiva_lista(parametros_development, parametros_production)

    Rails.env == "development" ? data_matriculaciones_educacion_inclusiva_lista_url(parametros_development) : "#{PARAMETRO[:subdominio]}data/matriculaciones_educacion_inclusiva_lista#{parametros_production}"

  end
end
