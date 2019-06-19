module ForemanUpman
  module Dao
    class ChannelWizard
      delegate :logger, to: ::Rails

      include ActiveModel::Model

      attr_accessor :base_url, :origin, :label, :suite, :version, :codename, :date, :architectures, :components, :description
    end
  end
end
