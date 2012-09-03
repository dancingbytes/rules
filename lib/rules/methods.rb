# encoding: utf-8
module Rules

  module Methods

    def can?(meth = @_context_for_method)

      raise ::Rules::ParamsError, "No defined method for check." if meth.nil? || meth.blank?

      # Если правила выключены -- действие разрешено
      return true if ::Rules.off?

      @rule_context ||= ::Rules.class_for(self)

      rule = ::Rules::List.rule(@rule_context, meth)
      # Если правила не существует -- действие разрешено
      return true unless rule

      # Если зависимое правило не выполнено -- действие запрещено.
      return false unless ::Rules::List.dependence_satisfied?(@rule_context)

      block = ::Rules::List.block(@rule_context, meth)

      # Выполняем блок (расширяющий/уточняюшщий правило), если он есть и, если мы уже
      # не в процессе выполнения этого блока.
      if block && @_context_for_method.nil?

        @_context_for_method = meth
        block   = block.bind(self) if self.class == @rule_context
        result  = block.call
        @_context_for_method = nil
        return result

      end # if

      # Выбираем результат из базы
      ::OwnerRule.access_for(@rule_context, rule)

    end # can?

  end # Methods

end # Rules