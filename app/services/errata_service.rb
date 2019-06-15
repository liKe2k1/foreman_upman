class ErrataService
  delegate :logger, :to => ::Rails

  def initialize
    #_load_available_plugins
  end


  def update_for_dist(dist)
    logger.info "Updating Errata for distribution #{dist}"

    errata_plugin = DebianPlugin.new
    #errata_plugin = _get_errata_plugin(dist)
    if errata_plugin.present?
      errata_plugin.fetch_items
    end
    return nil
  end


  private

  def _load_available_plugins
    require File.join(File.dirname(__FILE__), 'errata', 'plugin_base')
    Dir[File.join(File.dirname(__FILE__), 'errata', 'plugin') + "/*.rb"].each {|f| require f}
    PluginBase.register_plugins
  end


  def _get_errata_plugin(dist)
    PluginBase.plugins.each do |plugin|
      if plugin.dist_code == dist
        return plugin.new
      end
    end
    logger.error "There is no errata plugin for this distribution [%s] - Currently available [debian, ubuntu]" % dist
    return nil
  end
end
