# encoding: utf-8
if Rules.class_exists?("OwnerRule")
  OwnerRule.send(:include, Rules::OwnerRule)
else

  class OwnerRule
    include ::Rules::OwnerRule
  end

end # if

if defined?(Kaminari)
  require 'kaminari/models/mongoid_extension'
  OwnerRule.send :include, Kaminari::MongoidExtension::Document
end