# encoding: utf-8
module Rules

  module Config

    extend self

    PACK_KEYS = 'H*H*'.freeze

    @methods = ::Hash.new{ |k,v| k[v] = {} } # ::Hash.new{ |k,v| k[v] = { :b => {}, :k => {} } }
    @groups  = {}
    @titles  = {}
    @models  = ::Hash.new{ |k,v| k[v] = {} }
    @lists   = []
    @reject  = {}
    @depends = ::Hash.new{ |k,v| k[v] = ->() { true } }

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
      key = generate_key(context, n)

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
        @methods[context][el] = {
          :block => b,
          :key   => key
        }
      end

      @lists << {

        :title => (@titles[context] || context),
        :rule  => n,
        :key   => key

      }

    end # []=

    def get_by(context, method_name)
      @methods[context.to_s][method_name]
    end # get_by

    def exists?(context, method_name)
      !get_by(context, method_name).nil?
    end # exists?

    alias exist? exists?

    def reject(context, &block)

      context = context.to_s
      @reject[context] = block if block_given?
      @reject[context]

    end # reject

    def depends(context, klass, meth)

      context = context.to_s

      # Если указываем на самого себя
      return true if context.to_sym == klass

      @depends[context] = ->() {

        return true unless class_exists?(klass)
        return ::Object.const_get(klass).can?(meth)

      }

    end # depends

    def dependence_satisfied?(context)
      @depends[context.to_s].call
    end # dependence_satisfied?

    private

    def generate_key(context, method_name)

      [context, method_name].
        pack(::Rules::Config::PACK_KEYS).
        bytes.
        map { |b| "%02X" % b }.
        join('')

    end # generate_key

    def class_exists?(class_name)

      return false if class_name.blank?

      begin
        ::Object.const_defined?(class_name) ? ::Object.const_get(class_name) : ::Object.const_missing(class_name)
      rescue => e
        return false if e.instance_of?(::NameError)
        raise e
      end

    end # class_exists?

  end # Config

end # Rules