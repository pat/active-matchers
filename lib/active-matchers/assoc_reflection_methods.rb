module ActiveMatchers
  module AssociationReflectionMethods
    def to_hash
      {
        :macro => @macro,
        :options => @options
      }
    end
  end
end