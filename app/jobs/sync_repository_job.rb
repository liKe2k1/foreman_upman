class SyncRepositoryJob < ApplicationJob
  queue_as :default

  def perform(repository)
    sync_packages = SyncPackages.new
    sync_packages.start_job(repository, {
        uuid: self.job_id
    })
  end


  def humanized_name
    _('Synchronize packages from packages.gz with database')
  end
end