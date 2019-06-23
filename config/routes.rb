Foreman::Application.routes.draw do
  # API
  namespace :api, defaults: {format: 'json'} do
    scope '(:apiv)', module: :v2, defaults: {apiv: 'v2'}, apiv: /v2/, constraints: ApiConstraints.new(version: 2, default: true) do
      scope 'upman', module: :foreman_upman do
        resources :repository do
          collection do
            get :auto_complete_search
            get :sync
            get :sync_status
            get :lookup
          end
        end
        resources :packages do
          collection do
            get :repo, concerns: [:with_datatable]
            get :auto_complete_search
          end
        end
        resources :node do
          collection do
            post :register
            post :install_history
            post :installed_packages
            get :history, concerns: [:with_datatable]
          end
        end
        resources :channels do
          collection do
            get :auto_complete_search
          end
        end
      end
    end
  end

  scope 'upman', module: :foreman_upman do
    resources :channels do
      collection do
        get :auto_complete_search
        get :wizard
        post :create_from_wizard
      end
    end
    resources :config
    resources :status
    resources :nodes do
      collection do
        get :pane_history_table
      end
    end
    resources :errata do
      collection do
        get :sync
      end
    end
    resources :packages do
      collection do
        get :pane_table
      end
    end
    resources :repositories do
      collection do
        get :auto_complete_search
        get :sync
        get :sync_progress
        get :sync_cancel
      end
    end
  end

  # Serve websocket cable requests in-process
  # Planned feature for sync status.. but seems a bit overloaded for one task
  # mount ActionCable.server => '/foreman_upman/cable'
end
