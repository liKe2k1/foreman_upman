AjaxDatatablesRails.configure do |config|
  config.db_adapter = Rails.configuration.database_configuration[Rails.env]['adapter'].to_sym
end