# encoding: utf-8
module Rules

  module Object

    private

    def rules(&block)

      return if self.instance_of?(::Object)

      r = ::Rules::Builder.new(self)
      r.instance_eval &block

    end # rules

  end # Object

end # Rules

::Object.send(:extend, ::Rules::Object)