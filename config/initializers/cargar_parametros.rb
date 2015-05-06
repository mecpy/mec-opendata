PARAMETRO = YAML.load_file(Rails.root.join('config', 'parametros.yml'))[Rails.env].symbolize_keys
APP_CONFIG = YAML.load_file(Rails.root.join('config', 'config.yml'))[Rails.env].symbolize_keys
