module ForemanUpman
  class NodesController < ForemanUpman::ApplicationController

    before_action :find_resource, only: %i[show edit update destroy sync sync_progress sync_cancel]

    def index
      @nodes = resource_base_search_and_page
    end

    def pane_history_table
      @uuid = params[:uuid]
      render partial: 'foreman_upman/nodes/list_history_pane'
    rescue Foreman::Exception => exception
      process_ajax_error exception
    end


    def show
    end
  end
end
