module ActiveMatchers
  module Matchers
    class ValidationMatcher
      def initialize(type, *attributes)
        @type = type
        @attributes = attributes
      end
      
      def matches?(model)
        @model = model
        case @type
        when :require
          confirm_required(&@if)
        when :unique
          confirm_unique
        when :one_of_many
          confirm_one_of_many
        when :length
          confirm_length
        else
          false
        end
      end
      
      def failure_message
        "Error: #{@error}"
      end
      
      def to_be_unique
        @type = :unique
        self
      end
      
      def using(attributes={})
        @base_attributes = attributes
        self
      end
      
      def if(&block)
        @if = block
        self
      end
      
      def one_of(*attributes)
        @attributes = attributes
        @type = :one_of_many
        self
      end
      
      def to(length)
        @length = length
        self
      end
      
      def starting_with(base)
        @base = base
        self
      end
      
      private
      
      def confirm_required
        return true if @attributes.empty?

        @attributes.each do |attribute|
          obj = @model.new @base_attributes.except(*attribute)
          yield obj if block_given?
          
          if obj.valid?
            @error = "#{@model.name}.valid? should be false without #{attribute}, but returned true"
            return false
          end
          if obj.errors.on(attribute).empty?
            @error = "#{@model.name} should have errors on #{attribute} when #{attribute} is missing"
            return false
          end
          obj.send "#{attribute.to_s}=", @base_attributes[attribute]
          unless obj.valid?
            @error = "#{@model.name} should be valid when #{attribute} is supplied"
            return false
          end
        end
        
        true
      end
      
      def confirm_unique
        return true if @attributes.empty?

        # Create first
        @model.create @base_attributes
        # Create second, which will be invalid because unique values
        # are duplicated
        obj = @model.new @base_attributes
        return false if obj.valid?
        # Change the values of the unique attributes to remove collisions
        @attributes.each do |attribute|
          return false if obj.errors.on(attribute).empty?
          obj.send "#{attribute.to_s}=", "#{@base_attributes[attribute]} - Edit"
        end
        return obj.valid?
      end
      
      def confirm_one_of_many
        return true if @attributes.empty?

        obj = @model.new @base_attributes.except(*@attributes)
        return false if obj.valid?
        @attributes.each do |attribute|
          obj.send "#{attribute.to_s}=", @base_attributes[attribute]
          return false unless obj.valid?
          obj.send "#{attribute.to_s}=", nil
          return false if obj.valid?
        end
        
        true
      end
      
      def confirm_length
        return true if @attributes.empty?
        
        @base ||= ""

        @attributes.each do |attribute|
          # Get the maximum length from the database
          @length ||= @model.columns_hash[attribute.to_s].limit
          obj = @model.new @base_attributes.except(attribute)
          # Confirm the maximum length is valid
          obj.send "#{attribute.to_s}=", @base + "a"*(@length - @base.length)
          unless obj.valid?
            @error = "#{@model.name} should be valid when #{attribute} has a length of #{@length}"
            return false
          end
          # Confirm something longer than the maximum length is not valid
          obj.send "#{attribute.to_s}=", @base + "a"*(@length+1 - @base.length)
          if obj.valid?
            @error = "#{@model.name} should be invalid when #{attribute} has a length of #{@length+1}"
            return false
          end
        end
        
        true
      end
    end
  end
end