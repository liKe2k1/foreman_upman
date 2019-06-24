module ForemanUpman
  class NodeRepositories < ApplicationRecord
    self.table_name = 'upman_node_repositories'
    include ScopedSearchExtensions

    belongs_to :node, class_name: 'ForemanUpman::Node'
    belongs_to :repositories, class_name: 'ForemanUpman::Repository'
  end
end
