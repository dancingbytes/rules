# encoding: utf-8
require 'set'

module Rules

  module List

    extend self

    @hash    = {}
    @methods = {}
    @groups  = {}
    @models  = {}
    @aliases = {}
    @lists   = []

    def aliases(v)

      if v.is_a?(Hash)
        restore_list
        @aliases = v
        update_list
      end
      self

    end # aliases

    def list
      @lists
    end # list

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

      end # each
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

      add_to_list(context, n)
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

    def add_to_list(context, rule)

      @lists << {
        :alias => (@aliases[context] || context),
        :model => context,
        :rule  => rule
      }

    end # add_to_list

    def restore_list

      @aliases.each do |key, value|

        if (i = @lists.rindex { |v| v[:model] == key })
          @lists[i][:alias] = key
        end

      end # each

    end # restore_list

    def update_list

      @aliases.each do |key, value|

        if (i = @lists.rindex { |v| v[:model] == key })
          @lists[i][:alias] = value
        end

      end # each

    end # update_list

  end # List

end # Rules