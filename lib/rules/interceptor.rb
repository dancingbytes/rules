# encoding: utf-8
module Rules

  module Interceptor

    class << self

      def redefine(method_name, old_method, context, scope = nil)

        scope ||= context

        return unless ::Rules::List.has_rule_for?(context, method_name)

        scope.send :define_method, method_name do |*args, &block|

          unless self.can?(method_name)
            raise ::Rules::AccessDenideError, "You have no rights to access method `#{method_name}`. Context: `#{self}`"
          end

          old_method = old_method.bind(self) if old_method.is_a? ::UnboundMethod
          old_method.call(*args, &block)

        end # send

      end # redefine

    end # class << self

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