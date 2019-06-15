class PluginBase

  attr_accessor :dist_code, :base_url, :source_url

  delegate :logger, :to => ::Rails

  require 'open-uri'
  require 'html2text'



  @plugins = Set.new

  def self.plugins
    @plugins
  end

  def self.register_plugins
    Object.constants.each do |klass|
      const = Kernel.const_get(klass)
      if const.respond_to?(:superclass) and const.superclass == PluginBase
        @plugins << const
      end
    end
  end

  def fetch_items
    raise NotImplementedError, "Implement this method"
  end


  def html2text(message)
    return Html2Text.convert(message)
  end

  def get_url_contents(url, convert_to_plaintext=false)
    page_string = nil
    open(url) do |f|
      page_string = f.read
    end
    if convert_to_plaintext
      return html2text(page_string)
    end
    return page_string
  end

end
