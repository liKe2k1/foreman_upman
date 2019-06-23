module ForemanUpman
  class NodeHistory < ApplicationRecord
    self.table_name = 'upman_node_history'
    include ScopedSearchExtensions

    validates :uuid, presence: true
    validates :action, presence: true
    validates :package, presence: true
    validates :architecture, presence: true
    validates :old_version, presence: false
    validates :target_version, presence: false
    validates :created_at, presence: true

    belongs_to :node, class_name: 'ForemanUpman::Node'
  end
end
