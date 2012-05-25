# encoding: utf-8
module Rules

  module Mongoid

    module Base

      def rule(name, *args, opts, &block)

        raise ::Rules::ParamsError, "First parameter must be a string" unless name.is_a?(String)

        unless opts.is_a?(Hash)
          args << opts; opts = {}
        end

        ::Rules::Builder.new(self, name, args.map(&:to_sym), opts, &block)

      end # rule

    end # Base

  end # Mongoid

end # Rules

Mongoid::Document::ClassMethods.send(:include, ::Rules::Mongoid::Base)
