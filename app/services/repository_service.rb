module RepositoryService
  class << self
    require 'open-uri'

    delegate :logger, :to => ::Rails

    def fetch_repository_information(repository)

      arch = 'i386'
      if repository.channel.architecture = 'x64'
        arch = 'amd64'
      end

      package_file = repository.build_mirror_url + '/binary-' + arch + '/Packages.gz'
      tmp_file = '/tmp/' + repository.label + '.packages.gz'

      begin
        File.write tmp_file, open(package_file).read.force_encoding('UTF-8')
      rescue StandardError => err
        logger.error "[RepositoryService] Can't download #{package_file} #{err.message}"
      end

      return tmp_file
    end
  end
end