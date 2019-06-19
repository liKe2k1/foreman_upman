module ForemanUpman
  class Extended < ApplicationRecord
    self.table_name = 'upman_extendeds'
    include ScopedSearchExtensions

    belongs_to :packages, class_name: 'ForemanUpman::Package'
    belongs_to :related_package, class_name: 'ForemanUpman::Package'
  end
end
