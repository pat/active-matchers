path = File.dirname(File.expand_path(__FILE__))
require "#{path}/matchers/association_matcher"
require "#{path}/matchers/validation_matcher"

module RspecAdditions
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
      ValidationMatcher.new(:require, *fields)
    end
    
    # Test validates_length_of :name matches database field length
    #   Model.should limit_length_of(:name).using(@valid_attributes)
    #
    # Test validates_length_of :name, :maximum => 255
    #   Model.should limit_length_of(:name).to(255).using(@valid_attributes)
    #
    def limit_length_of(*fields)
      ValidationMatcher.new(:length, *fields)
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
  end
end