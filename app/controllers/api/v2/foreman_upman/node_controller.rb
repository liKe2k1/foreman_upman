module Api
  module V2
    module ForemanUpman
      class NodeController < ForemanUpman::BaseController
        include ::ForemanUpman::Controller::Parameters::Nodes

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
          node = ::ForemanUpman::Node.where("uuid = '#{node_params[:uuid]}'").first
          if node.present?
            @node_data = node.update(node_params)
          else
            @node_data = ::ForemanUpman::Node.new(node_params)
            @node_data.save
          end
        end


        api :POST, '/upman/node/report/installed', N_('Report installed packages')
        def report_installed
          host = ::ForemanUpman::Node.where("uuid = '#{node_params[:uuid]}'").first
          if host.present?
            p
          end
        end

      end
    end
  end
end