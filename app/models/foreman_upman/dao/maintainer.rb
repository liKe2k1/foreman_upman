module ForemanUpman
  module Dao
    class Maintainer
      include ActiveModel::Model

      attr_accessor :name, :email

      def initialize(name, email)
        self.name = name
        self.email = email
      end
    end
  end
end
