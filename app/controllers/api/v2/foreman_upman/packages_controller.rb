module Api
  module V2
    module ForemanUpman
      class PackagesController < ForemanUpman::BaseController
        #include ::ForemanUpman::Controller::Parameters::Repository

        before_action :find_optional_nested_object
        before_action :find_resource, :only => %w{show update destroy}

        api :GET, "/upman/packages/", N_("List all packages")
        param_group :search_and_pagination, ::Api::V2::BaseController
        add_scoped_search_description_for(::ForemanUpman::Package)

        def index
          @packages = resource_scope_for_index
        end

        api :GET, "/upman/packages/repo/:repository_id/", N_("List all packages by repository")
        param :repository_id, :identifier, :required => true

        def repo
          render json:  PackageDatatable.new(params, repository_id: params[:repository_id])
        end


        def action_permission
          case params[:action]
          when 'repo'
            :view
          else
            super
          end
        end
      end
    end
  end
end