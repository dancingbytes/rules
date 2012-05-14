# encoding: utf-8
require 'rails/railtie'

module Rules

  class Railtie < ::Rails::Railtie #:nodoc:

    initializer 'rules' do |app|

      if ::Rules::MONGOID
        require 'rules/mongoid/base'
      end

    end # initializer

  end # Railtie

end # Rules