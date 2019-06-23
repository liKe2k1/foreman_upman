module Api
  module V2
    module ForemanUpman
      class ChannelsController < ForemanUpman::BaseController
        # include ::ForemanUpman::Controller::Parameters::Repository

        before_action :find_optional_nested_object
        before_action :find_resource, only: %w[show update destroy]

        api :GET, '/upman/channel/', N_('List all channels')
        param_group :search_and_pagination, ::Api::V2::BaseController
        add_scoped_search_description_for(::ForemanUpman::Channel)

        def index
          @repository = resource_scope_for_index
        end


        api :GET, '/upman/repository/:id/', N_('Show a repository')
        param :id, :identifier, required: true
        def show; end

        api :GET, '/upman/repository/sync_status/:uuid', N_('Show the sync status for given uuid')
        param :uuid, :identifier, required: true
        def sync_status
          @sync_status = ::ForemanUpman::SyncStatus.where(['uuid = ?', params[:uuid]]).first
        end
      end
    end
  end
end
