module ForemanUpman::Controller::Parameters::Nodes
  extend ActiveSupport::Concern

  class_methods do
    def node_params_filter
      Foreman::ParameterFilter.new(::ForemanUpman::Node).tap do |filter|
        filter.permit :hostname, :uuid, :operatingsystem, :rubyversion, :operatingsystemrelease, :last_sync
      end
    end
    def report_installed_params_filter
      Foreman::ParameterFilter.new(::ForemanUpman::Node).tap do |filter|
        filter.permit :hostname, :uuid, :operatingsystem, :rubyversion, :operatingsystemrelease, :last_sync
      end
    end
  end

  def node_params
    self.class.node_params_filter.filter_params(params, parameter_filter_context)
  end

  def host_data_params
    self.class.host_data_params_filter.filter_params(params, parameter_filter_context)
  end

end
