module ForemanUpman
  module Dao
    class Base
      def map(hash, ignore_key = [])
        hash.each do |key, value|
          instance_variable_set("@#{key}", value) unless ignore_key.include? key
        end
      end
    end
  end
end
