Foreman::Application.routes.draw do

  # API
  namespace :api, :defaults => {:format => 'json'} do
    scope "(:apiv)", :module => :v2, :defaults => {:apiv => 'v2'}, :apiv => /v2/, :constraints => ApiConstraints.new(:version => 2, :default => true) do
      scope 'upman', module: :foreman_upman do
        resources :repository do
          collection do
            get :auto_complete_search
            get :sync
            get :sync_status
          end
        end
        resources :packages do
          collection do
            get :repo, concerns: [:with_datatable]
            get :auto_complete_search
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
      end
    end
    resources :config
    resources :status
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
      end
    end

  end
end
