# encoding: utf-8
module Rules

  module ClassMethods

    private

    def rules(&block)

      return if self.instance_of?(::Object)

      r = ::Rules::Builder.new(self)
      r.instance_eval &block

    end # rules

  end # ClassMethods

  module InstanceMethods

    def can?(*args)

      if args.length == 2
        object  = ::Object.const_get(args[0].to_sym)
        meth    = args[1] || @_context_for_method
      else
        object  = self
        meth    = args[0] || @_context_for_method
      end

      raise ::Rules::ParamsError, "No defined method for check." if meth.nil? || meth.blank?

      # Если правила выключены -- действие разрешено
      return true if ::Rules.off?

      # Выбираем класс, если это экземпляр класса
      unless @rule_context

        klass = object.class
        @rule_context = (klass === klass.class) ? object : klass

      end # unless

      rule = ::Rules::Config.get_by(@rule_context, meth)

      # Если правила не существует -- действие разрешено
      return true unless rule

      # Если зависимое правило не выполнено -- действие запрещено.
      return false unless ::Rules::Config.dependence_satisfied?(@rule_context)

      block = rule[:block]
      key   = rule[:key]

      # Выполняем блок (расширяющий/уточняюшщий правило), если он есть и, если мы уже
      # не в процессе выполнения этого блока.
      if block && @_context_for_method.nil?

        @_context_for_method = meth
        block   = block.bind(self) if self.class == @rule_context
        result  = block.call
        @_context_for_method = nil
        return result

      end # if

      # Проверяем разрешение
      ::Rules.allow?(key)

    end # can?

  end # InstanceMethods

end # Rules

::Object.send(:include, ::Rules::InstanceMethods)
::Object.send(:extend,  ::Rules::InstanceMethods)
::Object.send(:extend,  ::Rules::ClassMethods)
