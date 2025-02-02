module PackageSyncService
  class << self
    delegate :logger, to: ::Rails


    def calculate_prerequisites(job, repository)
      repo_lib = ForemanUpman::RepositoryLib::Synchronize.new
      package_daos = repo_lib.get_packages_from_repository(repository)

      p job
      sync_service = SyncService.new
      sync_service.create_job(
          uuid: job.job_id,
          repository: repository,
          packages_count: package_daos.size
      )

      return sync_service
    end


    def perform_job(repository)
      scheduler = SyncRepositoryJob
      job = scheduler.perform_later(repository)
      self.calculate_prerequisites(job, repository)
      return job
    end


    def from_dao(repository, package_dao)
      package = create_or_get_package(repository, package_dao)

      extendeds = []
      %w[depends replaces conflicts provides breaks recommends suggests].each do |type|
        package_dao.send(type.to_s).each do |extends|
          ext = create_or_get_extendeds(type, extends)
          extendeds.append ext
        end
      end
      inject_extends(package, extendeds)

      maintainer = create_or_get_maintainer(package_dao.maintainer)
      inject_maintainer(package, maintainer)

      tags = []
      package_dao.tag.each do |dao_tag|
        tag = create_or_get_tag(dao_tag)
        tags.append tag
      end
      inject_tags(package, tags)

      package.save!

      package
    end

    def create_or_get_package(repository, package_dao)
      package = ForemanUpman::Package.where(name: package_dao.package, version: package_dao.version, repository: repository).first_or_create

      # logger.info "- Process Package #{package.name}"

      package.installed_size = package_dao.installed_size

      package.repository = repository

      package.architecture = package_dao.architecture
      if package_dao.try(:multi_arch)
        package.multi_arch = package_dao.multi_arch
      end
      package.description = package_dao.description
      package.homepage = package_dao.homepage
      if package_dao.try(:description_md5)
        package.description_md5 = package_dao.description_md5
      end
      package.section = package_dao.section
      package.priority = package_dao.priority
      package.filename = package_dao.filename
      package.size = package_dao.size
      package.md5sum = package_dao.md5sum
      package.sha265 = package_dao.sha256

      package.save!
      package
    end

    def create_or_get_maintainer(maintainer_dao)
      raise 'Maintainer can not be unset' if maintainer_dao.nil?

      ForemanUpman::Maintainer.where(name: maintainer_dao.name, email: maintainer_dao.email).first_or_create
    end

    def create_or_get_tag(tag)
      unless tag.nil?
        return ForemanUpman::Tag.where(label: tag.label).first_or_create
      end

      nil
    end

    def create_or_get_extendeds(_type, extended_dao)
      extended = ForemanUpman::Extended.where(package: extended_dao.package, extend_type: extended_dao.type, version: extended_dao.version).first_or_create
      extended.guid = extended_dao.guid
      extended.version_mask = extended_dao.version_mask
      extended.condition = extended_dao.condition
      extended.save!
      extended
    end

    def inject_tags(package, _tags)
      _tags.each do |_tag|
        unless ForemanUpman::Package.includes(:tags).where(upman_package_tags: { tags_id: _tag.id }).exists?
          package.tags << _tag
        end
      end
      package
    end

    def inject_extends(package, _extends)
      _extends.each do |_extend|
        next if _extend.nil?
        next if ForemanUpman::Package.includes(:extendeds).where(upman_package_extended: { extendeds_id: _extend.id }).exists?

        package.extendeds << _extend
      end
      package
    end

    def inject_maintainer(package, _maintainer)
      if _maintainer.nil?
        _abort_job(package, 'Cannot find Maintainer in Package %s')
      end

      unless ForemanUpman::Package.includes(:maintainers).where(upman_package_maintainers: { maintainers_id: _maintainer.id }).exists?
        package.maintainers << _maintainer
      end

      package
    end
  end
end
