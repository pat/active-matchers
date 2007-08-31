require "active_record_additions"
require "matchers"

ActiveRecord::Reflection::AssociationReflection.send(:include,
  AssociationReflectionMethods)