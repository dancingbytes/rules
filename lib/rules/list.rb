# encoding: utf-8
require 'set'

module Rules

  module List

    extend self

    @hash    = {}
    @methods = {}
    @groups  = {}
    @models  = {}

    def aliases(v)

      @aliases = v if v.is_a?(Hash)
      self

    end # aliases

    def alias_for(v)
      @aliases[v.to_s]
    end # alias_for

    def all
      @models
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
      !(@models[context.to_s] || {}).empty?
    end # has?

    def [](context)
      @models[context.to_s]
    end # []

    def []=(context, datas = {})

      context = context.to_s

      @models[context] ||= {}

      n = datas[:name]
      m = datas[:methods] || []
      o = datas[:opts] || {}

      unless @models[context][n].nil?
        raise ::Rules::DuplicateDefinitionError, "Rule `#{n}` already defined in `#{context}`."
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
        raise ::Rules::ParamsError, "Rule `#{n}` has no methods or groups."
      end

      @models[context][n] = m
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