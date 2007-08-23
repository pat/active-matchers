module RspecAdditions
  module Matchers
    class AssociationMatcher
      def initialize(macro, *attributes)
        @macro = macro
        @attributes = attributes
      end
      
      def matches?(model)
        @model = model
        confirm_association
      end
      
      def failure_message
        "Error: #{@error}"
      end
      
      def with_options(options)
        @options = options
        self
      end
      
      private
      
      def confirm_association
        return if @attributes.empty?
        
        @options ||= {}
  
        @attributes.each do |attribute|
          assoc = @model.reflect_on_association(attribute)
          if assoc.nil?
            @error = "#{@model.name} is missing the association #{attribute}"
            return false
          end
          if assoc.to_hash[:macro] != @macro
            @error = "#{@model.name}.#{attribute} should be #{@macro}, but is #{assoc.to_hash[:macro]}"
            return false
          end
          if assoc.to_hash[:options] != @options
            @error = "#{model.name}.#{attribute} should have options #{@options}, but has #{assoc.to_hash[:options]}"
            return false
          end
        end
        
        true
      end
    end
  end
end