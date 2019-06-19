module ForemanUpman
  class ErrataController < ForemanUpman::ApplicationController
    before_action :find_resource, only: %i[show edit update destroy sync_progress]

    def index
      @erratas = resource_base_search_and_page
    end

    def new; end

    def create; end

    def edit; end

    def show; end

    def update; end

    def destroy; end

    def sync
      scheduler = FetchErrataJob
      return scheduler.perform_later
      redirect_to action: 'index'
    end
  end
end
