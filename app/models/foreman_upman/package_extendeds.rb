module ForemanUpman
  class PackageExtendeds < ApplicationRecord
    self.table_name = 'upman_package_extended'
    include ScopedSearchExtensions

    belongs_to :packages, :class_name => 'ForemanUpman::Package'
    belongs_to :extendeds, :class_name => 'ForemanUpman::Extended'
  end
end