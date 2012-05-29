# encoding: utf-8
module Rules

  module Methods

    def can?(meth = @_context_for_method)

      raise ::Rules::ParamsError, "No defined method for check." if meth.nil? || meth.blank?

      @rule_context ||= ::Rules.class_for(self)
      return true unless ::Rules::List.has_rule_for?(@rule_context, meth)

      block = ::Rules::List.block(@rule_context, meth)

      if block && @_context_for_method.nil?

        @_context_for_method = meth
        block   = block.bind(self) if self.class == @rule_context
        result  = block.call
        @_context_for_method = nil
        return  result

      end # if

      ::OwnerRule.access_for(@rule_context, meth)

    end # can?

  end # Methods

end # Rules