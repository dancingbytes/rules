# encoding: utf-8
module Rules

  module Methods

    def can?(meth = @_context_for_method)

      raise ::Rules::ParamsError, "No defined method for check." if meth.nil? || meth.blank?
      return true if ::Rules.off?

      @rule_context ||= ::Rules.class_for(self)

      rule = ::Rules::List.rule(@rule_context, meth)
      return true unless rule

      block = ::Rules::List.block(@rule_context, meth)

      if block && @_context_for_method.nil?

        @_context_for_method = meth
        block   = block.bind(self) if self.class == @rule_context
        result  = block.call
        @_context_for_method = nil
        return result

      end # if

      ::OwnerRule.access_for(@rule_context, rule)

    end # can?

  end # Methods

end # Rules