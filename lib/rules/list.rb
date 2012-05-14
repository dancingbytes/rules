# encoding: utf-8
require 'singleton'
require 'set'

module Rules

  class List

    include Singleton

    def initialize
      @hash, @methods = {}, {}
    end # initialize

    class << self

      def has?(context)
        instance[context]
      end # has?

      def [](context)
        instance[context]
      end # []

      def []=(context, datas = {})
        instance[context] = datas
      end # []=

      def has_rule_for?(context, method_name)
        instance.has_rule_for?(context, method_name)
      end # has_rule_for?

    end # class << self

    def has?(context)

      !(@hash[context.to_s] || {}).empty?

    end # has?

    def [](context)

      @hash[context.to_s]

    end # []

    def []=(context, datas = {})

      context = context.to_s
      @hash[context] ||= {}

      n = datas[:name]
      m = datas[:methods]

      unless @hash[context][n].nil?
        raise ::Rules::DuplicateDefinitionError, "Rule `#{n}` already defined"
      end

      @hash[context][n] = m
      add_methods(context, m)

      self

    end # []=

    def has_rule_for?(context, method_name)

      s = @methods[context.to_s]
      s && s.include?(method_name.to_sym)

    end # has_rule_for?

    private

    def add_methods(context, methods)

      return unless methods.is_a?(Array) || methods.empty?

      @methods[context] ||= Set.new
      @methods[context].merge(methods)

    end # add_methods

  end # List

end # Rules