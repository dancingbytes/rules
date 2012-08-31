# encoding: utf-8
module Rules

  module Object

    private

    def rule(name, *args, opts, &block)

      raise ::Rules::ParamsError, "First parameter must be a string" unless name.is_a?(String)

      unless opts.is_a?(Hash)
        args << opts; opts = {}
      end

      ::Rules::Builder.create_rule(self, name, args.map(&:to_sym), opts, &block)

    end # rule

    def rule_rescue(&block)
      ::Rules::Builder.create_rescue(self, &block)
    end # rule_rescue

  end # Object

end # Rules

::Object.send(:extend, ::Rules::Object)