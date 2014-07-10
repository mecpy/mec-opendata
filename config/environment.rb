ENV['RAILS_RELATIVE_URL_ROOT'] = '/datos'
# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
OpenData::Application.initialize!
