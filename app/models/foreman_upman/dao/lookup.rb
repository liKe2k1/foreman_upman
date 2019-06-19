module ForemanUpman
  module Dao
    class Lookup
      delegate :logger, to: ::Rails

      include ActiveModel::Model

      attr_accessor :base_url, :origin, :label, :suite, :version, :codename, :date, :architectures, :components, :description

      def map(hash)
        hash.each do |key, value|
          instance_variable_set("@#{key}", value)
        end
      end
    end
  end
end
