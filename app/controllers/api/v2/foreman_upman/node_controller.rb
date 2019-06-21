module Api
  module V2
    module ForemanUpman
      class NodeController < ForemanUpman::BaseController
        include ::ForemanUpman::Controller::Parameters::HostData

        before_action :find_optional_nested_object
        before_action :find_resource, :only => %w{show}

        param_group :search_and_pagination, ::Api::V2::BaseController

        api :GET, "/upman/nodes/", N_("List all registered nodes")

        def index
          @nodes = resource_scope_for_index
        end

        api :GET, "/upman/nodes/:id/", N_("Show a node")
        param :id, :identifier, :required => true

        def show
        end

        api :POST, '/upman/node/register', N_('Register new node')

        def register
          host = ::ForemanUpman::HostData.where("uuid = '#{host_data_params[:uuid]}'").first
          if host.present?
            @host_data = host.update(host_data_params)
          else
            @host_data = ::ForemanUpman::HostData.new(host_data_params)
            @host_data.save
          end
        end

      end
    end
  end
end