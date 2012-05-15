# encoding: utf-8
module Rules

  module Methods

    def can?(meth)

      @rule_context ||= ::Rules.class_for(self)
      return true unless ::Rules::List.has_rule_for?(@rule_context, meth)
      ::UserRule.access_for(Rules.user, @rule_context, meth)

    end # can?

  end # Methods

end # Methods