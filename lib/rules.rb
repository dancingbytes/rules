# encoding: utf-8
require 'rules/version'
require 'rules/list'
require 'rules/errors'
require 'rules/interceptor'
require 'rules/methods'
require 'rules/builder'

module Rules

  MONGOID = defined?(::Mongoid)
  AR      = defined?(::ActiveRecord)

  class << self

    def user=(usr_id)
      @user = usr_id
    end # user

    def user
      @user
    end # user

    def class_for(o)

      klass = o.class
      klass == klass.class ? o : klass

    end # class_for

    def can!(context, meth)

      raise ::Rules::AccessDenideError, "You have no rights to access for method `#{meth}`"

    end # can!

  end # class << self

end # Rules

require 'rules/railtie' if defined?(::Rails)