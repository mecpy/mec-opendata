module MatriculacionesInicialHelper

def url_def_matriculaciones_inicial

    Rails.env == "development" ? def_matriculaciones_inicial_url : "#{PARAMETRO[:subdominio]}def/matriculaciones_inicial"

  end

  def url_data_matriculaciones_inicial

    Rails.env == "development" ? data_matriculaciones_inicial_url : "#{PARAMETRO[:subdominio]}data/matriculaciones_inicial"

  end

  def url_data_matriculaciones_inicial_lista(parametros_development, parametros_production)

    Rails.env == "development" ? data_matriculaciones_inicial_lista_url(parametros_development) : "#{PARAMETRO[:subdominio]}data/matriculaciones_inicial_lista#{parametros_production}"

  end
end
