module ForemanUpman
  class Repository < ActiveRecord::Base
    self.table_name = 'upman_repositories'
    include ScopedSearchExtensions
    include Authorizable

    belongs_to :channel, :class_name => 'ForemanUpman::Channel'

    has_many :packages, :class_name => 'ForemanUpman::Package', dependent: :nullify

    has_many :sync_status, :class_name => 'ForemanUpman::SyncStatus', dependent: :nullify

    validates :channel_id, presence: true
    validates :label, presence: true, uniqueness: true, length: {maximum: 50}

    validates :dist, presence: true, length: {maximum: 50}
    validates :component, presence: true, length: {maximum: 50}

    validates :gpg_key, presence: false

    scoped_search on: :label, complete_value: true, default_order: true
    scoped_search on: :created_at, complete_value: true, default_order: true
    scoped_search on: :updated_at, complete_value: true, default_order: true

    scoped_search in: :channel, on: :name, complete_value: true, rename: :channel


    def packages_count
      @packages_count ||= packages.count
    end

    def build_mirror_url
      return channel.base_url + "/dists/" + self.dist + "/" + self.component
    end

    def schedule_sync
      scheduler = SyncRepositoryJob
      return scheduler.perform_later(self)
    end

    def get_last_successfull_sync
      sync_status = self.sync_status.where("repository_id = #{self.id}").last
      if sync_status.present?
        if sync_status.status == 'finished'
          return "Finished"
        end
        if sync_status.status == 'update'
          return "In progress (%s %)" % sync_status.get_progress_in_percent
        end
        if sync_status.status == 'failed'
          return "Failed"
        end
      end

      return "Repository not synchronized"
    end
  end
end
