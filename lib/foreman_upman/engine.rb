module ForemanUpman
  class Engine < ::Rails::Engine
    engine_name 'foreman_upman'

    config.autoload_paths += Dir["#{config.root}/app/controllers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/helpers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/models/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/overrides"]
    config.autoload_paths += Dir["#{config.root}/app/datatables"]

    config.eager_load_paths << "#{config.root}/app/lib"

    # Add any db migrations
    initializer 'foreman_upman.load_app_instance_data' do |app|
      ForemanUpman::Engine.paths['db/migrate'].existent.each do |path|
        app.config.paths['db/migrate'] << path
      end
    end

    initializer 'foreman_upman.apipie' do
      # this condition is here for compatibility reason to work with Foreman 1.4.x
      if Apipie.configuration.api_controllers_matcher.is_a?(Array) &&
          Apipie.configuration.respond_to?(:checksum_path)
        Apipie.configuration.api_controllers_matcher << "#{ForemanUpman::Engine.root}/app/controllers/api/v2/upman/**/*.rb"
        Apipie.configuration.checksum_path += ['/upman/api/']
      end
    end

    initializer 'foreman_upman.register_plugin', :before => :finisher_hook do |_app|
      Foreman::Plugin.register :foreman_upman do
        requires_foreman '>= 1.22'

        # Add permissions
        security_block :upman do
          ## Channels
          permission :view_channels, {
              :'foreman_upman/channels' => [:index]
          }, :resource_type => 'ForemanUpman::Channels'
          permission :create_channels, {
              :'foreman_upman/channels' => %i[new create wizard create_from_wizard]
          }, :resource_type => 'ForemanUpman::Channels'
          permission :edit_channels, {
              :'foreman_upman/channels' => %i[edit update]
          }, :resource_type => 'ForemanUpman::Channels'
          permission :destroy_channels, {
              :'foreman_upman/channels' => [:destroy]
          }, :resource_type => 'ForemanUpman::Channels'

          ## Repositories
          permission :view_repositories, {
              :'foreman_upman/repositories' => [:index]
          }, :resource_type => 'ForemanUpman::Repositories'
          permission :create_repositories, {
              :'foreman_upman/repositories' => %i[new create]
          }, :resource_type => 'ForemanUpman::Repositories'
          permission :edit_repositories, {
              :'foreman_upman/repositories' => %i[edit update]
          }, :resource_type => 'ForemanUpman::Repositories'
          permission :destroy_repositories, {
              :'foreman_upman/repositories' => [:destroy]
          }, :resource_type => 'ForemanUpman::Repositories'
          permission :sync_repositories, {
              :'foreman_upman/repositories' => %i[sync sync_progress sync_cancel]
          }, :resource_type => 'ForemanUpman::Repositories'

          ## Nodes
          permission :view_nodes, {
              :'foreman_upman/nodes' => [:index]
          }, :resource_type => 'ForemanUpman::Nodes'

          permission :installed_packages_nodes, {
              :'foreman_upman/nodes' => [:installed_packages]
          }, :resource_type => 'ForemanUpman::Nodes'

          permission :install_history_nodes, {
              :'foreman_upman/nodes' => [:install_history]
          }, :resource_type => 'ForemanUpman::Nodes'


          ## Repositories
          permission :view_packages, {
              :'foreman_upman/packages' => [:index]
          }, :resource_type => 'ForemanUpman::Packages'
        end

        MANAGER = [
            :view_channels,
            :create_channels,
            :edit_channels,
            :destroy_channels,
            :view_repositories,
            :create_repositories,
            :edit_repositories,
            :destroy_repositories,
            :sync_repositories,
            :view_packages,
            :view_nodes,
            :installed_packages_nodes,
            :install_history_nodes
        ]
        role 'UpMan Manager', MANAGER
        add_all_permissions_to_default_roles

        # add menu entry
        sub_menu :top_menu, :upman, :after => :infrastructure_menu, :icon => 'pficon pficon-topology', :caption => N_('Update Manager') do
          menu :top_menu, :status, :url_hash => {controller: :'foreman_upman/status', action: :index}, :caption => N_('Status')
          menu :top_menu, :nodes, :url_hash => {controller: :'foreman_upman/nodes', action: :index}, :caption => N_('Nodes')
          menu :top_menu, :repositories, :url_hash => {controller: :'foreman_upman/repositories', action: :index}, :caption => N_('Repositories')
          menu :top_menu, :channels, :url_hash => {controller: :'foreman_upman/channels', action: :index}, :caption => N_('Channels')
          menu :top_menu, :errata, :url_hash => {controller: :'foreman_upman/errata', action: :index}, :caption => N_('Errata')
          menu :top_menu, :config, :url_hash => {controller: :'foreman_upman/config', action: :index}, :caption => N_('Configuration')
        end

        widget 'foreman_upman_widget', name: N_('Update Manager Status'), sizex: 4, sizey: 1
      end
    end

    # Precompile any JS or CSS files under app/assets/
    # If requiring files from each other, list them explicitly here to avoid precompiling the same
    # content twice.
    assets_to_precompile = Dir.chdir(root) do
      Dir['app/assets/javascripts/**/*', 'app/assets/stylesheets/**/*'].map do |f|
        f.split(File::SEPARATOR, 4).last
      end
    end

    initializer 'foreman_upman.assets.precompile' do |app|
      app.config.assets.precompile += assets_to_precompile
    end

    initializer 'foreman_upman.configure_assets', group: :assets do
      SETTINGS[:foreman_upman] = {assets: {precompile: assets_to_precompile}}
    end

    #
    # Later stuff for install updates on remote targets
    #
    #initializer 'foreman_upman.require_dynflow', :before => 'foreman_tasks.initialize_dynflow' do |app|
    #  ForemanTasks.dynflow.require!
    #  ForemanTasks.dynflow.config.queues.add(DYNFLOW_QUEUE, :pool_size => Setting['upman_workers_pool_size']) if Setting.table_exists? rescue(false)
    #  ForemanTasks.dynflow.config.eager_load_paths << File.join(ForemanUpman::Engine.root, 'app/lib/actions')
    #end

    # Include concerns in this config.to_prepare block
    config.to_prepare do
      begin
        Host::Managed.send(:include, ForemanUpman::HostExtensions)
        HostsHelper.send(:include, ForemanUpman::HostsHelperExtensions)
      rescue StandardError => e
        Rails.logger.warn "ForemanUpman: skipping engine hook (#{e})"
      end
    end

    rake_tasks do
      Rake::Task['db:seed'].enhance do
        ForemanUpman::Engine.load_seed
      end
    end

    initializer 'foreman_upman.register_gettext', after: :load_config_initializers do |_app|
      locale_dir = File.join(File.expand_path('../..', __dir__), 'locale')
      locale_domain = 'foreman_upman'
      Foreman::Gettext::Support.add_text_domain locale_domain, locale_dir
    end
  end
end
