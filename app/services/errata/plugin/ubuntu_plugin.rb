class UbuntuPlugin < PluginBase
  delegate :logger, to: ::Rails

  def initialize
    @dist_code = 'ubuntu'

    # Download all nessessary information from
    # https://lists.debian.org/debian-security-announce/
    @base_url = 'https://lists.ubuntu.com/archives/ubuntu-security-announce/'
  end

  def fetch_items
    logger.info '[UbuntuPlugin] fetch_items'
  end

  private

  # Download all nessessary information from
  # https://lists.debian.org/debian-security-announce/
  def _fetch_from_web
    index_content = get_url_contents(base_url)
  end
end
