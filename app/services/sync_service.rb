class SyncService
  delegate :logger, :to => ::Rails

  def initialize(params)
    @repository = params[:repository]
    @packages_count = params[:packages_count]
    @uuid = params[:uuid]

    logger.info "[SyncService] Parsing #{@packages_count} packages for repository #{@repository.label}  [with uuid #{@uuid}]"
    @sync_status = ForemanUpman::SyncStatus.create(uuid: @uuid, packages_count: @packages_count, repository: @repository, status: 'preparing')
  end

  def update(package_count, package_name, time_elapsed)
    #logger.info "[SyncService] Package [#{package_name}] #{package_count} of #{@packages_count} parsed (#{time_elapsed}ms)"
    @sync_status.packages_processed = package_count
    @sync_status.last_update = Time.now
    @sync_status.last_package_name = package_name
    @sync_status.status = 'update'
    @sync_status.save

  end

  def finish()
    logger.info "[SyncService] Finished sync process"
    @sync_status.status = 'finished'
    @sync_status.save
  end

end