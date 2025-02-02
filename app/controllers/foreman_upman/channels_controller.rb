module ForemanUpman
  class ChannelsController < ForemanUpman::ApplicationController
    include Foreman::Controller::AutoCompleteSearch
    include ForemanUpman::Controller::Parameters::Channels

    before_action :find_resource, only: %i[edit update destroy]

    def index
      @channels = resource_base_search_and_page
    end

    def new
      @channel = ForemanUpman::Channel.new
    end

    def wizard
      @channel_wizard = ForemanUpman::Dao::ChannelWizard.new
    end

    def create_from_wizard
      success 'The channel and repositories created successfully'

      wizard = ForemanUpman::RepositoryLib::Wizard.new
      wizard.create(params)

      redirect_to action: 'index'
    end

    def create
      @channel = ForemanUpman::Channel.new(channel_params)
      if @channel.save
        process_success object: @channel
      else
        process_error object: @channel
      end
    end

    def edit; end

    def show
      @channel = resource_base.includes(:repositories).find(params[:id])
    end

    def update
      if @channel.update(channel_params)
        process_success object: @channel
      else
        process_error object: @channel
      end
    end

    def destroy
      if @channel.destroy_all
        process_success success_redirect: channels_path
      else
        process_error object: @channel
      end
    end
  end
end
