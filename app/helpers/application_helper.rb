module ApplicationHelper

	def mec_custom_url(url)
    if Rails.env.production?
      s = url.split("/")
      s.delete_at(s.index("data") || s.length)
      url = s.join('/')
    end
    url
  end

  def obtener_mes(mes)

    case mes
    when 1 then "enero"
    when 2 then "febrero"
    when 3 then "marzo"
    when 4 then "abril"
    when 5 then "mayo"
    when 6 then "junio"
    when 7 then "julio"
    when 8 then "agosto"
    when 9 then "setiembre"
    when 10 then "octubre"
    when 11 then "noviembre"
    when 12 then "diciembre"
    else ""
    end

  end

  def icon_delete
    image_tag("delete-icon.png", :style => "width:16px;")
  end
  
  def options_meses
    
    [["",""],["enero", 1],["febrero", 2],["marzo", 3], ["abril", 4], ["mayo", 5], ["junio", 6], ["julio", 7], ["agosto", 8], ["setiembre", 9], ["octubre", 10], ["novimiembre", 11], ["diciembre", 12]]

  end

end
