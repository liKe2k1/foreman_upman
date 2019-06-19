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
        gunzip_file_to_string(tmp_file)
      end

      def parse(repository)
        packages = []
        package_content = fetch_repository_information(repository)
        package_chunks = package_content.split("\n\n")
        package_chunks.each do |chunk|
          packages.append _parse_release_chunk(chunk)
        end

        packages
      end

      # @param [String] chunk Package chunk content
      # @return ::ForemanUpman::Dao::PackageDao
      def _parse_release_chunk(chunk)
        body = Body.new.parse(chunk)

        maintainer = Maintainer.new.parse(chunk)
        body.inject_maintainer(maintainer)

        tag = Tag.new.parse(chunk)
        body.inject_tag(tag)

        body.inject_package_replaces(Parser::Package.new.parse(chunk, 'Replaces'))
        body.inject_package_depends(Parser::Package.new.parse(chunk, 'Depends'))
        body.inject_package_suggests(Parser::Package.new.parse(chunk, 'Suggests'))
        body.inject_package_recommends(Parser::Package.new.parse(chunk, 'Recommends'))
        body.inject_package_breaks(Parser::Package.new.parse(chunk, 'Breaks'))
        body.inject_package_provides(Parser::Package.new.parse(chunk, 'Provides'))
        body.inject_package_conflicts(Parser::Package.new.parse(chunk, 'Conflicts'))

        body.package_dao
      end
    end
  end
end
