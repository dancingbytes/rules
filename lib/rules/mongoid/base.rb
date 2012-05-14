# encoding: utf-8
module Rules

  module Mongoid

    module Base

      def rule(name, *args)

        raise ::Rules::ParamsError, "Parameter `name` must be a string" unless name.is_a?(String)
        ::Rules::Builder.new(self, name, args.map(&:to_sym))

      end # rule

    end # Base

  end # Mongoid

end # Rules

Mongoid::Document::ClassMethods.send(:include, ::Rules::Mongoid::Base)
