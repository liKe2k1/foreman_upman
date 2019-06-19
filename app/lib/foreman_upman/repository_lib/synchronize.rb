module ForemanUpman
  module RepositoryLib
    class Synchronize
      def get_packages_from_repository(repository)
        parser = PackageLib::Parser.new
        package_daos = parser.parse(repository)

        package_daos
      end
    end
  end
end
