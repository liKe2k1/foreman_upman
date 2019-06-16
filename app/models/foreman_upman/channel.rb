module ForemanUpman
  class Channel < ActiveRecord::Base
    self.table_name = 'upman_channels'
    include ScopedSearchExtensions
    include Authorizable

    ARCHITECTURES = [
        'x86',
        'x64'
    ]

    CHECKSUM_TYPES = [
        'SHA-1',
        'SHA-256',
        'SHA-384',
        'SHA-512'
    ]

    validates :name, presence: true, uniqueness: true, length: {maximum: 50}

    validates :label, presence: true
    validates :base_url, repository: { allow_blank: false }

    validates :architecture, length: {maximum: 3},
              inclusion: {in: ARCHITECTURES, message: "Architecture must be one of: #{ARCHITECTURES.join(', ')}"},
              allow_blank: false

    validates :repository_checksum_type, length: {maximum: 7},
              inclusion: {in: CHECKSUM_TYPES, message: "Checksum must be one of: #{CHECKSUM_TYPES.join(', ')}"},
              allow_blank: false

    has_many :repositories, :class_name => 'ForemanUpman::Repository', dependent: :nullify

    def repositories_count
      @repositories_count ||= repositories.count
    end

    scoped_search on: :name, complete_value: true, default_order: true
    scoped_search on: :label, complete_value: true, default_order: true
    scoped_search on: :base_url, complete_value: true, default_order: true
    scoped_search on: :architecture, complete_value: true, default_order: true
    scoped_search on: :repository_checksum_type, complete_value: true, default_order: true
    scoped_search on: :created_at, complete_value: true, default_order: true
    scoped_search on: :updated_at, complete_value: true, default_order: true
  end
end