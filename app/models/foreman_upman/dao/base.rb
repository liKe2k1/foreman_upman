module ForemanUpman
  module Dao
    class Base
      def map(hash, ignore_key = [])
        hash.each do |key, value|
          unless ignore_key.include? key
            instance_variable_set("@#{key}", value)
          end
        end
      end
    end
  end
end