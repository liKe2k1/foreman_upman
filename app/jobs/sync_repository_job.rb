class SyncRepositoryJob < ApplicationJob
  queue_as :default

  include ForemanUpman::TimingHelper

  def perform(repository)


    repo_lib = ForemanUpman::RepositoryLib::Synchronize.new
    package_daos = repo_lib.get_packages_from_repository(repository)

    sync_service = SyncService.new({
                                       uuid: self.job_id,
                                       repository: repository,
                                       packages_count: package_daos.size
                                   })


    i = 0
    package_daos.each do |package_dao|
      current_package = nil

      if sync_service.is_canceled
        return nil
      end

      elapsed = measure_time do
        current_package = PackageSyncService.from_dao(repository, package_dao)
      end
      i += 1
      sync_service.update(i, current_package.name, elapsed)
    end

    sync_service.finish

  end


  def humanized_name
    _('Synchronize packages from packages.gz with database')
  end
end