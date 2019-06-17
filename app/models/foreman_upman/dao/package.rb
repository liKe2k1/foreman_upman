module ForemanUpman
  module Dao
    class Package < Base
      include ActiveModel::Model

      attr_accessor :package
      attr_accessor :version
      attr_accessor :installed_size
      attr_accessor :maintainer
      attr_accessor :architecture
      attr_accessor :replaces
      attr_accessor :depends
      attr_accessor :recommends
      attr_accessor :suggests
      attr_accessor :breaks
      attr_accessor :provides
      attr_accessor :conflicts
      attr_accessor :description
      attr_accessor :homepage
      attr_accessor :description_md5
      attr_accessor :tag
      attr_accessor :section
      attr_accessor :priority
      attr_accessor :filename
      attr_accessor :size
      attr_accessor :md5sum
      attr_accessor :sha256

    end
  end
end
