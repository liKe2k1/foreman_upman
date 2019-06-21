module ForemanUpman::Controller::Parameters::HostData
  extend ActiveSupport::Concern

  class_methods do
    def host_data_params_filter
      Foreman::ParameterFilter.new(::ForemanUpman::HostData).tap do |filter|
        filter.permit :hostname, :uuid, :operatingsystem, :rubyversion, :operatingsystemrelease, :last_sync
      end
    end
  end

  def host_data_params
    self.class.host_data_params_filter.filter_params(params, parameter_filter_context)
  end
end
