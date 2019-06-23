module NodeService
  class << self
    delegate :logger, to: ::Rails

    def process_installed_packages(uuid, data)
      data.each do |item|
        node_packages = ::ForemanUpman::NodePackage.where(uuid: uuid, package: item[:package], version: item[:version]).first_or_create
        node_packages.architecture = item[:architecture]
        node_packages.save!
      end
    end

    def process_install_history(uuid, data)
      data.each do |execution|
        node_history = ::ForemanUpman::NodeHistory.where(uuid: uuid, package: execution[:package], created_at: execution[:datetime]).first_or_create
        node_history.action = execution[:action]
        node_history.architecture = execution[:architecture]
        node_history.old_version = execution[:old_version]
        node_history.target_version = execution[:target_version]
        node_history.save!
      end
    end

  end
end