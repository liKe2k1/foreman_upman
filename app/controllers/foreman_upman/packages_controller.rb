module ForemanUpman
  class PackagesController < ForemanUpman::ApplicationController
    def show
      @package = resource_base.find(params[:id])
    end

    def pane_table
      # @packages = resource_base.where("repository_id = #{params[:repository_id]}")
      @package_id = params[:repository_id]
      render partial: 'foreman_upman/packages/list_pane'
    rescue Foreman::Exception => exception
      process_ajax_error exception
    end

    def action_permission
      case params[:action]
      when 'pane_table'
        :view
      else
        super
      end
    end
  end
end
