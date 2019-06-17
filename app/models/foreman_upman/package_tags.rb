module ForemanUpman
  class PackageTags < ApplicationRecord
    self.table_name = 'upman_package_tags'
    include ScopedSearchExtensions

    belongs_to :packages, :class_name => 'ForemanUpman::Package'
    belongs_to :tags, :class_name => 'ForemanUpman::Tag'
  end
end