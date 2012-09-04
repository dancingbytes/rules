# encoding: utf-8
require 'rails/railtie'

module Rules

  class Railtie < ::Rails::Railtie #:nodoc:

    initializer 'rules' do |app|

      config.to_prepare do

        # preload rails` models
        app.config.paths["app/models"].each do |path|

          Dir.glob("#{path}/**/*.rb").sort.each do |file|
            require_dependency(file.gsub("#{path}/" , "").gsub(".rb", ""))
          end

        end # each

        # preload rails` controllers
        app.config.paths["app/controllers"].each do |path|

          Dir.glob("#{path}/**/*.rb").sort.each do |file|
            require_dependency(file.gsub("#{path}/" , "").gsub(".rb", ""))
          end

        end # each

      end # to_prepare

    end # initializer

  end # Railtie

end # Rules