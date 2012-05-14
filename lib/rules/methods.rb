# encoding: utf-8
module Rules

  module Methods

    def can?(meth)

      retutn false if meth.nil?
      meth = meth.to_sym

      return true unless ::Rules::List.has_rule_for?(::Rules.class_for(self), meth)
      puts "[can?] #{self} -> #{meth}"

    end # can?

  end # Methods

end # Methods