module ForemanUpman
  class Repository < ActiveRecord::Base
    self.table_name = 'upman_repositories'
    include ScopedSearchExtensions
    include Authorizable

    belongs_to :channel, class_name: 'ForemanUpman::Channel'

    has_many :packages, class_name: 'ForemanUpman::Package', dependent: :nullify

    has_many :sync_status, class_name: 'ForemanUpman::SyncStatus', dependent: :nullify

    validates :channel_id, presence: true
    validates :label, presence: true, uniqueness: true, length: { maximum: 50 }

    validates :dist, presence: true, length: { maximum: 50 }
    validates :component, presence: true, length: { maximum: 50 }

    validates :gpg_key, presence: false

    scoped_search on: :label, complete_value: true, default_order: true
    scoped_search on: :created_at, complete_value: true, default_order: true
    scoped_search on: :updated_at, complete_value: true, default_order: true

    scoped_search in: :channel, on: :name, complete_value: true, rename: :channel

    def packages_count
      @packages_count ||= packages.count
    end

    def build_mirror_url
      channel.base_url + '/dists/' + dist + '/' + component
    end

    def get_last_successfull_sync
      sync_status = self.sync_status.where("repository_id = #{id}").last
      if sync_status.present?
        return 'Finished' if sync_status.status == 'finished'
        if sync_status.status == 'update'
          return "In progress (#{sync_status.get_progress_in_percent}%)"
        end
        return 'Failed' if sync_status.status == 'failed'
      end

      'Repository not synchronized'
    end
  end
end
