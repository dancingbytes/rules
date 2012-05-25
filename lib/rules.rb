# encoding: utf-8
require 'rules/list'
require 'rules/interceptor'
require 'rules/methods'
require 'rules/builder'

module Rules

  extend self

  class ParamsError < ::StandardError; end
  class AccessDenideError < ::StandardError; end

  MONGOID = defined?(::Mongoid) ? true : false
  AR      = defined?(::ActiveRecord) ? true : false

  attr :owner_id, true

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

  def models_aliases(v)

    ::Rules::List.aliases(v)
    self

  end # models_aliases

  def class_exists?(class_name)

    return false if class_name.blank?

    begin
      ::Object.const_defined?(class_name) ? ::Object.const_get(class_name) : ::Object.const_missing(class_name)
    rescue => e
      return false if e.instance_of?(::NameError)
      raise e
    end

  end # class_exists?

  def list

    l = ::Rules::List.list
    l.sort { |x,y| x[:alias] <=> y[:alias] }

  end # list

end # Rules

require 'rules/railtie' if defined?(::Rails)