require "active_matchers/assoc_reflection_methods"
require "active_matchers/matchers"

ActiveRecord::Reflection::AssociationReflection.send(:include,
  ActiveMatchers::AssociationReflectionMethods)

module ActiveMatchers
  module Version #:nodoc:
    Major = 0
    Minor = 2
    Tiny  = 0
    
    String = [Major, Minor, Tiny].join('.')
  end
end