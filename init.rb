require "assoc_reflection_matchers"
require "matchers"

ActiveRecord::Reflection::AssociationReflection.send(:include,
  AssociationReflectionMethods)