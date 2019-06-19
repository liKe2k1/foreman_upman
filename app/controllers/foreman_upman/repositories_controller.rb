module ForemanUpman
  class RepositoriesController < ForemanUpman::ApplicationController
    include ForemanUpman::Controller::Parameters::Repositories

    before_action :find_resource, only: %i[show edit update destroy sync sync_progress sync_cancel]

    def index
      @repositories = resource_base_search_and_page.includes(:channel)
    end

    def new
      @repository = ForemanUpman::Repository.new
    end

    def show
      @repository = resource_base.includes(:channel).find(params[:id])
      @sync_progress = SyncStatus.where('status' => 'update').or(SyncStatus.where('status' => 'preparing')).where('repository_id' => @repository.id).first

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

    def edit; end

    def sync
      job = PackageSyncService.perform_job(@repository)
      success _("The job was queued with id #{job.job_id}")
      redirect_to action: 'show', id: @repository.id
    end

    def sync_progress
      @uuid = params[:uuid]
    end

    def sync_cancel
      sync_progress = SyncService.cancel(params[:uuid])
      redirect_to action: 'show', id: @repository.id
    end

    def update
      if @repository.update(repositories_params)
        process_success object: @repository
      else
        process_error object: @repository
      end
    end

    def destroy
      if params['object_only']
        @repository.packages.delete_all
      else
        @repository.packages.each(&:destroy)
      end

      if @repository.destroy
        process_success success_redirect: repositories_path
      else
        process_error object: @repository
      end
    end
  end
end
