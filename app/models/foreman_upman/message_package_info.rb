module ForemanUpman
  class MessagePackageInfo < ApplicationRecord

    validates :release, presence: true
    validates :file, presence: true
    validates :version, presence: true

  end
end

#self.release = pkg_release
#self.filename = pkg_file
#self.version = pkg_version
