require "assoc_reflection_methods"
require "matchers"

ActiveRecord::Reflection::AssociationReflection.send(:include,
  AssociationReflectionMethods)