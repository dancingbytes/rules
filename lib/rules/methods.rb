# encoding: utf-8
module Rules

  module Methods

    def can?(meth = @_context_for_method)

      raise ::Rules::ParamsError, "Not defined method for check." if meth.nil? || meth.blank?

      @rule_context ||= ::Rules.class_for(self)

      return true unless ::Rules::List.has_rule_for?(@rule_context, meth)
      r = ::OwnerRule.access_for(::Rules.owner_id, @rule_context, meth)

      if (block = ::Rules::List.block(@rule_context, meth))

        unless @_context_for_method

          block = block.bind(self) if self.class == @rule_context
          @_context_for_method = meth
          r = block.call
          @_context_for_method = nil

        end

      end # if

      r

    end # can?

  end # Methods

end # Methods