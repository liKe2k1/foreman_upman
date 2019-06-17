module ForemanUpman
  module RepositoryLib
    class Lookup

      require 'uri'
      include ForemanUpman::RemoteFileHelper
      include ForemanUpman::DebParseHelper

      delegate :logger, :to => ::Rails

      # Valid URL example
      # http://de.archive.ubuntu.com/ubuntu/dists
      # http://ftp2.de.debian.org/debian/dists
      def perform(base_url, codename)

        base_url_cleaned = URI.decode(base_url).sub(/(\/)+$/,'')
        logger.info "Download Release from #{base_url_cleaned}/dists/#{codename}/"

        package_file = download_to_string(base_url_cleaned + "/dists/" + codename + "/Release")
        release_data = _parse_release_file(package_file)

        lookup_dao = ForemanUpman::Dao::Lookup.new
        lookup_dao.base_url = base_url_cleaned
        lookup_dao.map(release_data)
        lookup_dao
      end

    end
  end
end