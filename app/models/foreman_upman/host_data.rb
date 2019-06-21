module ForemanUpman
  class HostData < ApplicationRecord
    self.table_name = 'upman_registered_hosts'
    include ScopedSearchExtensions

    validates :hostname, presence: true
    validates :uuid, presence: true
    validates :operatingsystem, presence: true
    validates :rubyversion, presence: true
    validates :operatingsystemrelease, presence: true

  end
end
