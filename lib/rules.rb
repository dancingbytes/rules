# encoding: utf-8
require 'rules/config'
require 'rules/builder'
require 'rules/interceptor'
require 'rules/methods'

module Rules

  extend self

  class ParamsError < ::StandardError; end
  class AccessDenideError < ::StandardError; end
  class NotImplementedError < ::StandardError; end

  @check_permission_block = ->(key) {
    raise ::Rules::NotImplementedError, "Use method Rules.check_permission(&block) to set rules checker!"
  }

  def off

    @skip_checking = true
    puts "** Rules disable."
    self

  end # off

  def on

    @skip_checking = false
    puts "** Rules enable."
    self

  end # on

  def off?
    !!@skip_checking
  end # off?

  def skip(&block)

    begin

      before_skip_value = @skip_checking
      @skip_checking = true
      yield

    ensure
      @skip_checking = before_skip_value
    end

  end # skip

  alias :skip_for :skip

  def groups(hash)
    ::Rules::Config.groups(hash)
  end # groups

  def list

    ::Rules::Config.list.sort { |x,y|
      x[:alias] <=> y[:alias] && x[:rule] <=> y[:rule]
    }

  end # list

  def each(&block)
    list.each(&block)
  end # list

  def check_permission(&block)
    @check_permission_block = block
  end # check_permission

  def allow?(key)
    @check_permission_block.call(key) && true
  end # allow?

  alias :accept? :allow?

end # Rules

require 'rules/railtie' if defined?(::Rails)