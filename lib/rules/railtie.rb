# encoding: utf-8
require 'rules/rails'
require 'rails/railtie'

module Rules

  class Railtie < ::Rails::Railtie #:nodoc:

    initializer 'rules' do |app|

      if ::Rules::MONGOID
        require 'rules/mongoid/base'
      end

    end # initializer

    initializer "preload all application models" do |app|

      config.to_prepare do
        ::Rules::Rails.preload_models(app)
      end # to_prepare

    end # initializer

  end # Railtie

end # Rules