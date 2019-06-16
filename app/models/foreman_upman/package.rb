module ForemanUpman
  class Package < ActiveRecord::Base
    self.table_name = 'upman_packages'
    include ScopedSearchExtensions

    validates :name, presence: true
    validates :version, presence: true
    validates :installed_size, presence: false
    validates :architecture, presence: true
    validates :description, presence: true
    validates :multi_arch, presence: false
    validates :description_md5, presence: true
    validates :section, presence: false
    validates :filename, presence: true
    validates :size, presence: true
    validates :md5sum, presence: true
    validates :sha265, presence: true
    validates :repository_id, presence: true

    belongs_to :repository, :class_name => 'ForemanUpman::Repository'

    has_many :package_tags, :class_name => 'ForemanUpman::PackageTags', :dependent => :destroy
    has_many :tags, :through => :package_tags

    has_many :package_maintainers, :class_name => 'ForemanUpman::PackageMaintainers', :dependent => :destroy
    has_many :maintainers, :through => :package_maintainers


    scoped_search on: :name, complete_value: true, default_order: true
    scoped_search on: :version, complete_value: true, default_order: true

  end
end