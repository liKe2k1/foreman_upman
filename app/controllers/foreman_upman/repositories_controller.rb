module ForemanUpman
  class RepositoriesController < ForemanUpman::ApplicationController
    include ForemanUpman::Controller::Parameters::Repositories

    before_action :find_resource, only: [:show, :edit, :update, :destroy, :sync, :sync_progress]

    def index
      @repositories = resource_base_search_and_page.includes(:channel)
    end

    def new
      @repository = ForemanUpman::Repository.new
    end


    def show
      @repository = resource_base.includes(:channel).find(params[:id])
      @sync_progress = SyncStatus.where("status" => "update").where("repository_id" => @repository.id).first

      @packages = Package.where("repository_id = #{@repository.id}")
    end

    def create
      @repository = ForemanUpman::Repository.new(repositories_params)
      if @repository.save
        process_success object: @repository
      else
        process_error object: @repository
      end
    end

    def edit
    end

    def sync

      @repository.schedule_sync
      redirect_to action: "show", id: @repository.id
    end

    def sync_progress
      @uuid = params[:uuid]
    end

    def update
      if @repository.update(repositories_params)
        process_success object: @repository
      else
        process_error object: @repository
      end
    end

    def destroy
      unless params['object_only']
        @repository.packages.each { |d| d.destroy }
      else
        @repository.packages.delete_all
      end

      if @repository.destroy
        process_success success_redirect: repositories_path
      else
        process_error object: @repository
      end
    end
  end
end
