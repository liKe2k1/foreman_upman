module ForemanUpman
  class Erratum < ActiveRecord::Base

    self.table_name = 'upman_erratum'
    validates :category, presence: true
    validates :errata_id, presence: true
    validates :release, presence: true

    validates :packages, presence: false
    validates :cves, presence: false

    validates :name, presence: true
    validates :errata_type, presence: true
    validates :date, presence: true
    validates :synopsis, presence: true
    validates :date, presence: true
    validates :from, presence: true
    validates :description, presence: true
    validates :reboot, presence: false
    validates :dist, presence: false
    validates :subject, presence: true
    #validates :references, presence: true

    scoped_search on: :errata_id, complete_value: true, default_order: true
    scoped_search on: :errata_type, complete_value: true, default_order: true
    scoped_search on: :subject, complete_value: true, default_order: true

    def get_advisory_name
      "%s-%s-%s" % [self.category, self.errata_id, self.release]
    end


    def get_packages_as_hash
      JSON.parse(self.packages)
    end
  end

end


#self.errataType = 'Security Advisory'
#self.errataName = errata_name
#self.errataID = errata_id
#self.errataRelease = errata_release
#self.errataYear = errata_year
#self.errataSynopsis = errata_synopsis
#self.errataDate = errata_date
#self.errataFrom = errata_from
#self.errataDesc = errata_desc
#self.errataReboot = errata_reboot
#self.errataDist = errata_dist
#self.messageSubject = msg_subject
#self.errataReferences = references