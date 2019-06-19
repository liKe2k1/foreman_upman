module ForemanUpman
  module Dao
    class Release
      include ActiveModel::Model
      attr_accessor :origin, :label, :suite, :version, :codename, :changelogs, :date, :acquire_by_hash, :architectures, :components, :description
    end
  end
end
