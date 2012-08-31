# encoding: utf-8
module Rules

  module Interceptor

    extend self

    def redefine(method_name, old_method, context, scope = nil)

      scope ||= context

      return unless ::Rules::List.rule(context, method_name)

      scope.send :define_method, method_name do |*args, &block|

        unless self.can?(method_name)

          error = ::Rules::AccessDenideError.new("You have no rights to access method `#{method_name}`. Context: `#{self}`")

          if (rlr = ::Rules::List.rescue(context))

            rlr = rlr.bind(self)
            rlr.call(error)

          else
            raise error
          end

        else

          old_method = old_method.bind(self) if old_method.is_a? ::UnboundMethod
          old_method.call(*args, &block)

        end # unless

      end # send

    end # redefine

    module Base

      def method_added(meth)

        return if @recursing

        @recursing = true
        ::Rules::Interceptor.redefine(meth, instance_method(meth), self)
        @recursing = nil

      end # method_added

      def singleton_method_added(meth)

        return if @recursing

        @meta ||= class << self; self; end

        @recursing = true
        ::Rules::Interceptor.redefine(meth, method(meth), self, @meta)
        @recursing = nil

      end # singleton_method_added

    end # Base

  end # Interceptor

end # Rules