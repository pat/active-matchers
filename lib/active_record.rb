module ActiveRecord
  module Reflection
    class AssociationReflection
      def to_hash
        {
          :macro => @macro,
          :options => @options
        }
      end
    end
  end
end