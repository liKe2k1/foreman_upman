module ForemanUpman
  class NodesController < ForemanUpman::ApplicationController

    before_action :find_resource, only: %i[show edit update destroy sync sync_progress sync_cancel]

    def index
      @nodes = resource_base_search_and_page
    end

    def show
    end
  end
end
