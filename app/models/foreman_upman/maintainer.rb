module ForemanUpman
  class Maintainer < ApplicationRecord
    self.table_name = 'upman_maintainers'
    include ScopedSearchExtensions

    validates :name, presence: true
    validates :email, presence: true

    has_many :package_maintainers, :class_name => 'ForemanUpman::PackageMaintainers'
    has_many :packages, :through => :package_maintainers
  end
end
