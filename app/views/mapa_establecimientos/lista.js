$("#mapa-establecimientos-lista").html("<%= escape_javascript(render :partial => "lista", :locals => { :mapa_establecimientos => @mapa_establecimientos}) %>");
