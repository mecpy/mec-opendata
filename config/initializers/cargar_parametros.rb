PARAMETRO = YAML.load_file(Rails.root.join('config', 'parametros.yml'))[Rails.env].symbolize_keys
