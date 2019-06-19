module ForemanUpman
  module Dao
    class Tag
      include ActiveModel::Model

      attr_accessor :label

      def initialize(label)
        self.label = label
      end
    end
  end
end
