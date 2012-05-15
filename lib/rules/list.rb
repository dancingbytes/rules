# encoding: utf-8
require 'singleton'
require 'set'

module Rules

  class List

    include Singleton

    def initialize

      @hash    = {}
      @methods = {}
      @groups  = {}

    end # initialize

    class << self

      def all
        instance.all
      end # all

      def add_group(name, methods)
        instance.add_group(name, methods)
      end # add_group

      def groups(hash)
        instance.groups(hash)
      end # groups

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

    def all
      @hash
    end # all

    def add_group(name, methods)

      methods = [methods] unless methods.is_a?(Array)
      @groups[name.to_sym] = methods.map(&:to_sum)
      self

    end # add_group

    def groups(hash = {})

      return self unless hash.is_a?(Hash)

      @groups = {}
      hash.each do |key, value|

        value = (value.is_a?(Array) ? value.map(&:to_sym) : [value.to_sym])
        @groups[key.to_sym] = value

      end

      self

    end # groups

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
      m = datas[:methods] || []
      o = datas[:opts] || {}

      unless @hash[context][n].nil?
        raise ::Rules::DuplicateDefinitionError, "Rule `#{n}` already defined"
      end

      unless (groups = (o[:group] || o[:groups])).nil?

        groups = (groups.is_a?(Array) ? groups.map(&:to_sym) : [groups.to_sym])
        groups.each do |g|
          m.concat(@groups[g] || [])
        end

      end # unless

      m.uniq!
      m.compact!

      if m.empty?
        raise ::Rules::ParamsError, "Rule `#{n}` have no methods or groups"
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