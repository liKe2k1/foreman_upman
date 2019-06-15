class SyncRepositoryJob < ApplicationJob
  queue_as :default

  include ForemanUpman::PackageHelper

  def perform(repository)
    @packages = sync_package_file(repository, {
        uuid: self.job_id
    })
  end


  def humanized_name
    _('Synchronize packages from packages.gz with database')
  end
end