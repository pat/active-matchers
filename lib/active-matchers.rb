$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require "active_record"
require "active-matchers/assoc_reflection_methods"
require "active-matchers/matchers"

ActiveRecord::Reflection::AssociationReflection.send(:include,
  ActiveMatchers::AssociationReflectionMethods)

module ActiveMatchers
  module Version #:nodoc:
    MAJOR = 0
    MINOR = 3
    TINY  = 1
    
    STRING = [MAJOR, MINOR, TINY].join('.').freeze
  end
end
