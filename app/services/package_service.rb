module PackageService
  class << self

    delegate :logger, :to => ::Rails

    def sync_from_dao(package_dao)


      p package_dao.maintainer

    end



    def create_or_get_maintainers(maintainer)
      ForemanUpman::Maintainer.where(name: maintainer.name, email: maintainer.email).first_or_create
    end

    def create_or_get_tags

    end

    def create_or_get_depends

    end

    def create_or_get_provides

    end

    def create_or_get_conflicts

    end

    def create_or_get_suggests

    end

    def create_or_get_recommends

    end


    def create_or_get_breaks

    end

  end
end
