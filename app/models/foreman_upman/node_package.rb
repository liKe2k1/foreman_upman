module ForemanUpman
  class NodePackage < ApplicationRecord
    self.table_name = 'upman_node_packages'
    include ScopedSearchExtensions

    validates :uuid, presence: true
    validates :package, presence: true
    validates :architecture, presence: true
    validates :version, presence: true
    validates :auto_install, presence: true

    belongs_to :node, class_name: 'ForemanUpman::Node'
  end
end
