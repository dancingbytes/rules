# encoding: utf-8
module Rules

  class Builder

    def initialize(context, name, methods = [])

      @context  = context
      @methods  = methods

      if ::Rules::List.has?(@context.to_s)

        @context.send :extend,  ::Rules::Interceptor::Base
        @context.send :include, ::Rules::Methods
        @context.send :extend,  ::Rules::Methods

      end # if

      ::Rules::List[context.to_s] = {
        :name    => name,
        :methods => methods
      }

      @methods.each do |meth|

        class_method(meth)    if @context.respond_to?(meth, true)
        instance_method(meth) if @context.method_defined?(meth)

      end # each

    end # new

    private

    def instance_method(meth)

      @context.instance_variable_set(:@recursing, true)
      ::Rules::Interceptor.redefine(meth, @context.instance_method(meth), @context)
      @context.instance_variable_set(:@recursing, nil)

    end # instance_method

    def class_method(meth)

      @meta ||= class << @context; self; end
      @context.instance_variable_set(:@recursing, true)
      ::Rules::Interceptor.redefine(meth, @context.method(meth), @context, @meta)
      @context.instance_variable_set(:@recursing, nil)

    end # class_method

  end # Builder

end # Rules