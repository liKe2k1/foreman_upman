module ForemanUpman
  class Tag < ActiveRecord::Base
    self.table_name = 'upman_tags'
    include ScopedSearchExtensions

    validates :label, presence: true

    has_many :package_tags, :class_name => 'ForemanUpman::PackageTags'
    has_many :packages, :through => :package_tags

  end
end
