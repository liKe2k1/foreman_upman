module Api
  module V2
    module ForemanUpman
      class RepositoryController < ForemanUpman::BaseController
	      #include ::ForemanUpman::Controller::Parameters::Repository

        before_action :find_optional_nested_object
        before_action :find_resource, :only => %w{show update destroy}

        api :GET, "/upman/repository/", N_("List all repositories")
        param_group :search_and_pagination, ::Api::V2::BaseController
        add_scoped_search_description_for(::ForemanUpman::Repository)

        def index
          @repository = resource_scope_for_index
        end

        api :GET, "/upman/repository/lookup/:base_url/:dist_code/", N_("Lookup a repository and print its details")
        param :base_url, String, :required => true, :desc => N_("URL to repository")
        param :codename, String, :required => true, :desc => N_("Distribution codename ")
        def lookup
          lookup = ::ForemanUpman::RepositoryLib::Lookup.new
          @lookup_dao = lookup.perform(params[:base_url], params[:codename])
        end

        api :GET, "/upman/repository/:id/", N_("Show a repository")
        param :id, :identifier, :required => true
        def show
        end


        api :GET, "/upman/repository/sync_status/:uuid", N_("Show the sync status for given uuid")
        param :uuid, :identifier, :required => true
        def sync_status
          @sync_status = ::ForemanUpman::SyncStatus.where(["uuid = ?", params[:uuid]]).first
        end


      end

    end
  end
end