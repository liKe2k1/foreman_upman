module ForemanUpman
  module PackageLib
    class Parser
      require 'pp'

      include ForemanUpman::TimingHelper
      include ForemanUpman::CompressionHelper
      include ForemanUpman::DebParseHelper
      include ForemanUpman::RemoteFileHelper

      def fetch_repository_information(repository)
        package_file = repository.build_mirror_url + '/binary-' + repository.channel.architecture + '/Packages.gz'
        tmp_file = download package_file
        return gunzip_file_to_string(tmp_file)
      end

      def parse(repository)
        package_content = fetch_repository_information(repository)
        package_chunks = package_content.split("\n\n")
        package_chunks.each do |chunk|
          _parse_release_chunk(chunk)
        end
      end

      def _parse_release_chunk(chunk)
        body = Body.new.parse(chunk)

        maintainer = Maintainer.new.parse(chunk)
        body.inject_maintainer(maintainer)

        tag = Tag.new.parse(chunk)
        body.inject_tag(tag)

        depends = Package.new.parse(chunk, "Depends")
        suggests = Package.new.parse(chunk, "Suggests")
        recommends = Package.new.parse(chunk, "Recommends")
        p recommends
        #pp body.package_dao
      end
    end
  end
end