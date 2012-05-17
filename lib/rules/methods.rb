# encoding: utf-8
module Rules

  module Methods

    def can?(meth)

      @rule_context ||= ::Rules.class_for(self)
      return true unless ::Rules::List.has_rule_for?(@rule_context, meth)
      ::OwnerRule.access_for(Rules.owner_id, @rule_context, meth)

    end # can?

  end # Methods

end # Methods