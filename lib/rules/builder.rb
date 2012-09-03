# encoding: utf-8
module Rules

  class Builder < ::BasicObject

    def initialize(context)
      @context = context
    end # new

    private

    def rule(name, *args, opts, &block)

      raise ::Rules::ParamsError, "First parameter must be a string" unless name.is_a?(::String)

      unless opts.is_a?(::Hash)
        args << opts; opts = {}
      end

      methods = args.map(&:to_sym)

      unless ::Rules::List.has?(@context)
        @context.send :extend,  ::Rules::Interceptor::Base
      end # if

      ::Rules::List[@context] = {
        :name    => name,
        :methods => methods,
        :opts    => opts,
        :block   => block
      }

      methods.each do |meth|

        class_method(meth)    if @context.respond_to?(meth, true)
        instance_method(meth) if @context.method_defined?(meth)

      end # each

    end # rule

    def reject(&block)
      ::Rules::List.reject(@context, &block)
    end # reject

    def title(v)
      ::Rules::List.titles(@context, v)
    end # title

    def before(klass, meth)
      ::Rules::List.depends(@context, klass.to_sym, meth.to_sym)
    end # before

    def instance_method(meth)

      @context.instance_variable_set(:@recursing, true)
      ::Rules::Interceptor.redefine(meth, @context.instance_method(meth), @context)
      @context.instance_variable_set(:@recursing, nil)

    end # instance_method

    def class_method(meth)

      meta = class << @context; self; end
      @context.instance_variable_set(:@recursing, true)
      ::Rules::Interceptor.redefine(meth, @context.method(meth), @context, meta)
      @context.instance_variable_set(:@recursing, nil)

    end # class_method

  end # Builder

end # Rules