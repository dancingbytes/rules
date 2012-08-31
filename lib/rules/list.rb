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
    @titles  = {}
    @models  = ::Hash.new{ |k,v| k[v] = {} }
    @lists   = []
    @reject  = {}

    def titles(context, name)

      context = context.to_s

      @titles[context] = name

      if (i = @lists.rindex { |v| v[:model] == context })
        @lists[i][:title] = name
      end

      self

    end # titles

    def list
      @lists
    end # list

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
        :title => (@titles[context] || context),
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

    def reject(context, &block)

      @reject[context] = block if block_given?
      @reject[context]

    end # reject

=begin
    private

    def restore_list

      @titles.each do |key, value|

        if (i = @lists.rindex { |v| v[:model] == key })
          @lists[i][:title] = key
        end

      end # each

    end # restore_list

    def update_list

      @titles.each do |key, value|

        if (i = @lists.rindex { |v| v[:model] == key })
          @lists[i][:title] = value
        end

      end # each

    end # update_list
=end

  end # List

end # Rules