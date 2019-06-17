module ForemanUpman
  class PackageMaintainers < ApplicationRecord
    self.table_name = 'upman_package_maintainers'
    include ScopedSearchExtensions

    belongs_to :packages, :class_name => 'ForemanUpman::Package'
    belongs_to :maintainers, :class_name => 'ForemanUpman::Maintainer'
  end
end