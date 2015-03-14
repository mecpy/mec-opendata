module AutocompleteHelper

  def autocomplete_help(*args)
    
    options = args.extract_options!

    # Valores por defecto
    options.reverse_merge!({
      :min_length => 2 
    })

    render(:partial => "helpers/autocomplete", :locals => { 
      
      ruta: options[:ruta],
      parametro_id: options[:parametro_id],
      resultado_id: options[:resultado_id],
      min_length: options[:min_length]
    
    })


  end

end
