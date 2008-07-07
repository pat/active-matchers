module ActiveMatchers
  module Matchers
    class ValidationMatcher
      def initialize(type, *attributes)
        @type = type
        @attributes = attributes
        @create_action = 'create'
        @new_action = 'new'
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
        when :numeric
          confirm_numericality
        when :unsigned
          confirm_zero_or_greater
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
      
      def to_be_numeric
        @type = :numeric
        self
      end
      
      def to_be_unsigned
        @type = :unsigned
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
      
      def to(upper_limit)
        @upper_limit = upper_limit
        self
      end
      
      def from(lower_limit)
        @lower_limit = lower_limit
        self
      end
      
      # Override the assumed default 'create' action and allow another one to be used.
      # This makes it possible to use an 'unsafe' create to bypass attr_accessible and friends.
      def with_create(action)
        @create_action = action
        self
      end

      # Override the assumed default 'new' action and allow another one to be used.
      # This makes it possible to use an 'unsafe' new to bypass attr_accessible and friends.
      def with_new(action)
        @new_action = action
        self
      end
      
      private
      
      def confirm_required
        return true if @attributes.empty?

        @attributes.each do |attribute|
          obj = @model.send @new_action, @base_attributes.except(*attribute)
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
        @model.send @create_action, @base_attributes
        # Create second, which will be invalid because unique values
        # are duplicated
        obj = @model.send @new_action, @base_attributes
        if obj.valid?
          @error = "#{@model.name} should not be valid when it is a duplicate"
          return false 
        end
        # Change the values of the unique attributes to remove collisions
        @attributes.each do |attribute|
          if obj.errors.on(attribute).empty?
            @error = "#{@model.name} should have a value collision for #{attribute}"
            return false 
          end
          obj.send "#{attribute.to_s}=", "#{@base_attributes[attribute]} - Edit"
        end
        unless obj.valid?
          @error = "#{@model.name} should be valid without duplicate values"
          return false
        end
        true
      end
      
      def confirm_one_of_many
        return true if @attributes.empty?

        obj = @model.send @new_action, @base_attributes.except(*@attributes)
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
        
        error_msgs = []
        @lower_limit ||= 0
        
        @attributes.each do |attribute|
          obj = @model.send @new_action, @base_attributes.except(attribute)
          
          if @lower_limit > 0
            obj.send "#{attribute.to_s}=", 'a'*(@lower_limit)
            error_msgs << "#{@model.name}.valid? should be true when #{attribute} has a length of #{@lower_limit}, but returned false" unless obj.valid?
          
            obj.send "#{attribute.to_s}=", 'a'*(@lower_limit-1)
            error_msgs << "#{@model.name}.valid? should be false when #{attribute} has a length less than #{@lower_limit}, but returned true" if obj.valid?
          end
          
          @upper_limit ||= @model.columns_hash[attribute.to_s].limit unless @lower_limit > 0
          
          if @upper_limit
            obj.send "#{attribute.to_s}=", 'a'*(@upper_limit)
            error_msgs << "#{@model.name}.valid? should be true when #{attribute} has a length of #{@upper_limit}, but returned false" unless obj.valid?
      
            obj.send "#{attribute.to_s}=", 'a'*(@upper_limit+1)
            error_msgs << "#{@model.name}.valid? should be false when #{attribute} has a length greater than #{@upper_limit}, but returned true" if obj.valid?
          end
          
          unless error_msgs.empty?
            @error = "#{@model.name} " + error_msgs.join(' and ')
            return false
          end
        end
        
        true
      end
      
      def confirm_numericality
        return true if @attributes.empty?
        
        obj = @model.send @new_action, @base_attributes
        
        @attributes.each do |attribute|
          
          unless obj.valid?
            @error = "#{@model.name}.valid? should be true when #{attribute} is numeric, but returned false"
            return false
          end
          
          # Change the attribute to a string
          obj.send "#{attribute.to_s}=", "String"
          if obj.valid?
            @error = "#{@model.name}.valid? should be false when #{attribute} is not numeric, but returned true"
            return false
          end
          
          obj.send "#{attribute.to_s}=", @base_attributes[attribute]
        end
        
        true
      end
      
      def confirm_zero_or_greater
        return true if @attributes.empty?
        
        obj = @model.send @new_action, @base_attributes
        
        @attributes.each do |attribute|
          obj.send("#{attribute.to_s}=",-1)
          if obj.valid?
            @error = "#{@model.name}.valid? should be false when #{attribute} is less than zero, but returned true"
            return false
          end
          
          obj.send "#{attribute.to_s}=", @base_attributes[attribute]
        end
        
        true
      end
      
    end
  end
end
