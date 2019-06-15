class FetchErrataJob < ApplicationJob

  queue_as :default

  def perform
    errata_service = ErrataService.new
    errata_service.update_for_dist('debian')
  end


  def humanized_name
    _('Synchronize errata data from web')
  end
end