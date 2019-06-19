module ForemanUpman::Controller::Parameters::Repositories
  extend ActiveSupport::Concern

  class_methods do
    def repositories_params_filter
      Foreman::ParameterFilter.new(::ForemanUpman::Repository).tap do |filter|
        filter.permit :label, :dist, :component, :gpg_key, :channel_id
      end
    end
  end

  def repositories_params
    self.class.repositories_params_filter.filter_params(params, parameter_filter_context)
  end
end
