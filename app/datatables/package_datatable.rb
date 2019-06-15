class PackageDatatable < AjaxDatatablesRails::ActiveRecord
  extend Forwardable

  include ActionView::Helpers::NumberHelper

  def_delegator :@view, :link_to
  def initialize(params, opts = {})
    @view = opts[:view_context]
    super
  end

  def view_columns
    @view_columns ||= {
        id: {source: "ForemanUpman::Package.id"},
        name: {source: "ForemanUpman::Package.name", cond: :start_with, searchable: true, orderable: true},
        version: {source: "ForemanUpman::Package.version", searchable: true, orderable: true},
        description: {source: "ForemanUpman::Package.description",searchable: true, orderable: true},
        installed_size: {source: "ForemanUpman::Package.installed_size", orderable: true},
    }
  end

  def data
    records.map do |record|
      {
          id: record.id,
          name: record.name,
          version: record.version,
          description: record.description,
          installed_size: number_to_human_size(record.installed_size),
          DT_RowId:   record.id, # This will automagically set the id attribute on the corresponding <tr> in the datatable
      }
    end
  end

  def repository_id
    @repository_id ||= options[:repository_id]
  end

  def get_raw_records
    ForemanUpman::Package.where("repository_id = #{repository_id}")
  end
end