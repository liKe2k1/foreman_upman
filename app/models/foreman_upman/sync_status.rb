module ForemanUpman
  class SyncStatus < ApplicationRecord
    self.table_name = 'upman_sync_status'
    include ScopedSearchExtensions

    validates :uuid, presence: true, uniqueness: true
    validates :packages_count, presence: false
    validates :packages_processed, presence: false
    validates :last_update, presence: false
    validates :last_package_name, presence: false
    validates :repository_id, presence: true
    validates :status, presence: true

    belongs_to :repository, class_name: 'ForemanUpman::Repository'

    def get_progress_in_percent
      ((packages_processed.to_f / packages_count.to_f) * 100).to_f.round(1)
    end
  end
end
