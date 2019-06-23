class NodeHistoryDatatable < AjaxDatatablesRails::ActiveRecord
  extend Forwardable

  include ActionView::Helpers::NumberHelper

  def_delegator :@view, :link_to
  def initialize(params, opts = {})
    @view = opts[:view_context]
    super
  end

  def view_columns
    @view_columns ||= {
      id: { source: 'ForemanUpman::NodeHistory.id' },
      uuid: { source: 'ForemanUpman::NodeHistory.uuid' },
      action: { source: 'ForemanUpman::NodeHistory.action' },
      package: { source: 'ForemanUpman::NodeHistory.package', cond: :start_with, searchable: true, orderable: true },
      old_version: { source: 'ForemanUpman::NodeHistory.old_version', cond: :start_with, searchable: true, orderable: true },
      target_version: { source: 'ForemanUpman::NodeHistory.target_version', searchable: true, orderable: true },
      created_at: { source: 'ForemanUpman::NodeHistory.created_at', orderable: true }
    }
  end

  def data
    records.map do |record|
      {
        id: record.id,
        uuid: record.uuid,
        package: record.package,
        action: record.action,
        old_version: record.old_version,
        target_version: record.target_version,
        created_at: record.created_at,
        DT_RowId: record.id # This will automagically set the id attribute on the corresponding <tr> in the datatable
      }
    end
  end

  def uuid
    @uuid ||= options[:uuid]
  end

  def get_raw_records
    ForemanUpman::NodeHistory.where("uuid = '#{uuid}'")
  end
end
