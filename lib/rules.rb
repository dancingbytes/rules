# encoding: utf-8
require 'rules/list'
require 'rules/interceptor'
require 'rules/methods'
require 'rules/builder'

module Rules

  extend self

  class ParamsError < ::StandardError; end
  class DuplicateDefinitionError < ::StandardError; end
  class AccessDenideError < ::StandardError; end

  MONGOID = defined?(::Mongoid) ? true : false
  AR      = defined?(::ActiveRecord) ? true : false

  attr :user, true

  def class_for(o)

    klass = o.class
    klass == klass.class ? o : klass

  end # class_for

  def groups(hash)

    ::Rules::List.groups(hash)
    self

  end # groups

  def add_group(name, *args)

    ::Rules::List.add_group(name, args)
    self

  end # add_group

  def env

    return ::Rails.env if defined?(::Rails)
    ENV["RACK_ENV"]

  end # env

  def can!(context, meth)
    raise ::Rules::AccessDenideError, "You have no rights to access method `#{meth}`"
  end # can!

end # Rules

require 'rules/railtie' if defined?(::Rails)