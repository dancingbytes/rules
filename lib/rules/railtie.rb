# encoding: utf-8
require 'rules/rails'
require 'rails/railtie'

module Rules

  class Railtie < ::Rails::Railtie #:nodoc:

    initializer 'rules' do |app|

      if ::Rules::MONGOID
        require 'rules/mongoid/base'
        require 'rules/mongoid/user_rules'
      end

      config.to_prepare do

        if ::Rules::MONGOID
          load 'rules/mongoid/setup.rb'
        end

        ::Rules::Rails.preload_models(app)

      end # to_prepare

    end # initializer

  end # Railtie

end # Rules