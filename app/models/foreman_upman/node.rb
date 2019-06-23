module ForemanUpman
  class Node < ApplicationRecord
    self.table_name = 'upman_nodes'
    include ScopedSearchExtensions

    validates :hostname, presence: true
    validates :uuid, presence: true
    validates :operatingsystem, presence: true
    validates :rubyversion, presence: true
    validates :operatingsystemrelease, presence: true


    scoped_search on: :hostname, complete_value: true, default_order: true
    scoped_search on: :operatingsystem, complete_value: true, default_order: true
    scoped_search on: :rubyversion, complete_value: true, default_order: true
    scoped_search on: :operatingsystemrelease, complete_value: true, default_order: true

    has_many :packages, class_name: 'ForemanUpman::NodePackage', dependent: :nullify
    has_many :history, class_name: 'ForemanUpman::NodeHistory', dependent: :nullify
  end
end
