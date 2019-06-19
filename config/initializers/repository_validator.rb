class RepositoryValidator < ActiveModel::EachValidator
  RESERVED_OPTIONS = %i[schemes no_local].freeze

  def initialize(options)
    options.reverse_merge!(schemes: %w[http https])
    options.reverse_merge!(message: :url)
    options.reverse_merge!(no_local: false)
    options.reverse_merge!(public_suffix: false)

    super(options)
  end

  def validate_each(record, attribute, value)
    schemes = [*options.fetch(:schemes)].map(&:to_s)
    begin
      escaped_uri = value ? URI.escape(value) : nil
      uri = URI.parse(escaped_uri)
      host = uri && uri.host
      scheme = uri && uri.scheme

      valid_suffix = !options.fetch(:public_suffix) || (host && PublicSuffix.valid?(host, default_rule: nil))
      valid_no_local = !options.fetch(:no_local) || (host && host.include?('.'))
      valid_scheme = host && scheme && schemes.include?(scheme)

      unless valid_scheme && valid_no_local && valid_suffix
        record.errors.add(attribute, options.fetch(:message), value: value)
      end
    rescue URI::InvalidURIError
      record.errors.add(attribute, :url, filtered_options(value))
    end
  end

  protected

  def filtered_options(value)
    filtered = options.except(*RESERVED_OPTIONS)
    filtered[:value] = value
    filtered
  end
end

module ClassMethods
  def validates_url(*attr_names)
    validates_with RepositoryValidator, _merge_attributes(attr_names)
  end
end
