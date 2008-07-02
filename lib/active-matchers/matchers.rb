require "active-matchers/matchers/association_matcher"
require "active-matchers/matchers/validation_matcher"
require "active-matchers/matchers/response_matchers"

module ActiveMatchers
  module Matchers
    # Test validates_presence_of :name
    #   Model.should need(:name).using(@valid_attributes)
    #
    # Test validates_uniqueness_of :name
    #   Model.should need(:name).to_be_unique.using(@valid_attributes)
    #
    # Test presence of at least one field being required
    #   Model.should need.one_of(:first_name, :last_name).using(@valid_attributes)
    # 
    def need(*fields)
      ValidationMatcher.new(:require, *fields).using(@base_attributes)
    end
    
    alias_method :mandate, :need
    
    # Test validates_length_of :name matches database field length
    #   Model.should limit_length_of(:name).using(@valid_attributes)
    #
    # Test validates_length_of :name, :maximum => 255
    #   Model.should limit_length_of(:name).to(255).using(@valid_attributes)
    #
    def limit_length_of(*fields)
      ValidationMatcher.new(:length, *fields).using(@base_attributes)
    end
    
    # Test belongs_to :parent
    #   Model.should belong_to(:parent)
    #
    # Test belongs_to :parent, :class_name => "CustomClass", :foreign_key => "some_id"
    #   Model.should belong_to(:parent).with_options(
    #     :class_name => "CustomClass", :foreign_key => "some_id")
    #
    def belong_to(*fields)
      AssociationMatcher.new(:belongs_to, *fields)
    end
    
    # Test has_many :items
    #   Model.should have_many(:items)
    #
    # Test has_many :items, :class_name => "CustomClass", :foreign_key => "some_id"
    #   Model.should have_many(:items).with_options(
    #     :class_name => "CustomClass", :foreign_key => "some_id")
    #
    def have_many(*fields)
      AssociationMatcher.new(:has_many, *fields)
    end
    
    # Test has_one :item
    #   Model.should have_one(:item)
    #
    # Test has_one :item, :class_name => "CustomClass", :foreign_key => "some_id"
    #   Model.should have_one(:item).with_options(
    #     :class_name => "CustomClass", :foreign_key => "some_id")
    #
    def have_one(*fields)
      AssociationMatcher.new(:has_one, *fields)
    end
    
    # Test has_and_belongs_to_many :items
    #   Model.should have_and_belong_to_many(:items)
    #
    # Test has_and_belongs_to_many :items, :class_name => "CustomClass"
    #   Model.should have_one(:item).with_options(
    #     :class_name => "CustomClass")
    #
    def have_and_belong_to_many(*fields)
      AssociationMatcher.new(:has_and_belongs_to_many, *fields)
    end
    
    # Useful for multiple requests using the same base attributes
    #
    #   using(@valid_attributes) do
    #     Model.should need(:name)
    #     Model.should limit_length_of(:name).to(100)
    #   end
    #
    def using(base_attributes={}, &block)
      @base_attributes = base_attributes
      yield
      @base_attributes= {}
    end
    
    #
    def succeed
      ResponseMatchers::SuccessMatcher.new(@controller)
    end
    
    # Use to confirm whether a response is/is not a 404
    #
    #   response.should be_a_404
    #
    def be_a_404
      ResponseMatchers::NotFoundMatcher.new
    end
    
    # Use to confirm whether a response redirected
    #
    #   response.should redirect
    #   response.should_not redirect
    #   response.should redirect.to("url")
    #   response.should_not redirect.to("url")
    #
    def redirect
      ResponseMatchers::RedirectMatcher.new
    end
  end
end