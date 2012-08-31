# encoding: utf-8
module Rules

  module Builder

    extend self

    def create_rule(context, name, methods = [], opts = {}, &block)

      unless ::Rules::List.has?(context)

        context.send :extend,  ::Rules::Interceptor::Base
        context.send :include, ::Rules::Methods
        context.send :extend,  ::Rules::Methods

      end # if

      ::Rules::List[context] = {
        :name    => name,
        :methods => methods,
        :opts    => opts,
        :block   => block
      }

      methods.each do |meth|

        class_method(context, meth)    if context.respond_to?(meth, true)
        instance_method(context, meth) if context.method_defined?(meth)

      end # each

      self

    end # create_rule

    def create_rescue(context, &block)

      ::Rules::List.rescue(context, &block)
      self

    end # create_rescue

    private

    def instance_method(context, meth)

      context.instance_variable_set(:@recursing, true)
      ::Rules::Interceptor.redefine(meth, context.instance_method(meth), context)
      context.instance_variable_set(:@recursing, nil)

    end # instance_method

    def class_method(context, meth)

      meta = class << context; self; end
      context.instance_variable_set(:@recursing, true)
      ::Rules::Interceptor.redefine(meth, context.method(meth), context, meta)
      context.instance_variable_set(:@recursing, nil)

    end # class_method

  end # Builder

end # Rules