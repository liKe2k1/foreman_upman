module ForemanUpman
  module Dao
    class ExtPackage < Base
      include ActiveModel::Model

      attr_accessor :guid
      attr_accessor :package
      attr_accessor :type
      attr_accessor :version_mask
      attr_accessor :version
      attr_accessor :condition

    end
  end
end
