# encoding: utf-8
module Rules

  module Rails

    extend self

    def preload_models(app)

      app.config.paths["app/models"].each do |path|

        Dir.glob("#{path}/**/*.rb").sort.each do |file|
          require_dependency(file.gsub("#{path}/" , "").gsub(".rb", ""))
        end

      end # each

      app.config.paths["app/controllers"].each do |path|

        Dir.glob("#{path}/**/*.rb").sort.each do |file|
          require_dependency(file.gsub("#{path}/" , "").gsub(".rb", ""))
        end

      end # each

    end # preload_models

  end # Rails

end # Rules