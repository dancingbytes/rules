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

  @access_for = ->(key) {
    raise ::Rules::NotImplementedError, "Use method Rules.access_for to set rules checker!"
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

  def access_for(&block)
    @access_for = block
  end # access_for

  alias :access           :access_for
  alias :check_access     :access_for
  alias :check_access_for :access_for

  def accept_for?(key)
    @access_for.call(key) && true
  end # accept_for?

  alias :accept? :accept_for?

end # Rules

require 'rules/railtie' if defined?(::Rails)