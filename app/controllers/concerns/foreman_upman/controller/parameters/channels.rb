module ForemanUpman::Controller::Parameters::Channels
  extend ActiveSupport::Concern

  class_methods do
    def channels_params_filter
      Foreman::ParameterFilter.new(::ForemanUpman::Channel).tap do |filter|
        filter.permit :name, :label, :architecture, :base_url, :repository_checksum_type
      end
    end
  end

  def channel_params
    self.class.channels_params_filter.filter_params(params, parameter_filter_context)
  end
end
