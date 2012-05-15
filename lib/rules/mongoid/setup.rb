# encoding: utf-8
if Rules.class_exists?("UserRule")
  UserRule.send(:include, Rules::UserRule)
else

  class UserRule
    include ::Rules::UserRule
  end

end # if

if defined?(Kaminari)
  require 'kaminari/models/mongoid_extension'
  UserRule.send :include, Kaminari::MongoidExtension::Document
end