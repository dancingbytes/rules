# encoding: utf-8
require 'set'

module Rules

  module List

    extend self

    @methods = ::Hash.new{ |k,v|

      k[v] = {

        :b => {},
        :r => {}

      }

    }

    @groups  = {}
    @aliases = {}
    @models  = ::Hash.new{ |k,v| k[v] = {} }
    @lists   = []
    @rescue  = {}

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

      n = datas[:name]
      o = datas[:opts] || {}
      m = datas[:methods] || []
      b = datas[:block]

      # Rule already defined
      return self unless @models[context][n].nil?

      if om = o.delete(:methods)
        m.concat(om.is_a?(Array) ? om : [om])
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
        raise ::Rules::ParamsError, "Rule `#{n}` has no methods or groups. Context: `#{context}`"
      end

      @models[context][n] = m

      m.each do |el|
        @methods[context][:b][el] = b
        @methods[context][:r][el] = n
      end

      @lists << {
        :alias => (@aliases[context] || context),
        :model => context,
        :rule  => n
      }

      self

    end # []=

    def block(context, method_name)
      @methods[context.to_s][:b][method_name]
    end # block

    def rule(context, method_name)
      @methods[context.to_s][:r][method_name]
    end # rule

    def rescue(context, &block)

      @rescue[context] = block if block_given?
      @rescue[context]

    end # rescue

    private

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