Rules
=====

User rights control system for rails


### Supported environment

Ruby:   1.9.3

Rails:  3.0, 3.1, 3.2


### DSL example

    # In rails model (for Mongoid)
    class User

      include Mongoid::Document

      rules do

        rule "Просмотр",  :all, :find, :count
        rule "Создание",  :group => :create
        rule "Изменение", :group => :change
        rule "Удаление",  :destroy_all, :group => :destroy

      end

    end


    # or in rails controller
    class ItemsController < ApplicationController

      rules do

        rule "Просмотр", :show

      end

    end


    ### To handle access errors

    # 1. Use rails method `rescue_from`:
    class ItemsController < ApplicationController

      rules do
        rule "Просмотр", :show
      end

      rescue_from ::Rules::AccessDenideError do |exception|
        render :file => "#{Rails.root}/public/422.html", :status => 422, :layout => false
      end

    end

    # 2. Use gem method `reject`:
    class ItemsController < ApplicationController

      rules do

        rule "Просмотр", :show

        reject do
          render :file => "#{Rails.root}/public/422.html", :status => 422, :layout => false
        end

      end

    end

    # Method `reject` is useful into model:
    class User

      include Mongoid::Document

      rules do

        rule "Просмотр",  :all, :find, :count
        rule "Создание",  :group => :create
        rule "Изменение", :group => :change
        rule "Удаление",  :destroy_all, :group => :destroy

        reject do
          # do thometing...
        end

      end

    end

    # When you use method `reject`, gem doesn`t raise exception, just call block from `reject`.


    # You may create file into "/path/to/you_app/config/initializers" with content:
    Rules.groups({

      :create   => [:create, :save],
      :change   => [:update_all, :update_attributes, :update_attribute],
      :destroy  => [:destroy]

    })


    # Customize rules.
    # Edit banner only by owner or user has rights.
    rules do

      title "Баннеры"

      rule "Редактирование",  :save do
        self.user_id == User.current.id || self.can?
      end

    end

    # If one rule depends on other rule. you can use method `before` like

    # Master
    class AdminController < ApplicationController

      rules do

        title "Администрирование"

        rule "Вход",  :index

      end

    end

    # Slave
    class ItemsController < ApplicationController

      rules do

        title "Товары"

        before :AdminController, :index

        rule "Просмотр",  :index, :show
        rule "Создание",  :new, :create
        rule "Редактирование",  :edit, :update
        rule "Удаление",  :destroy

      end

    end


### License

Authors: redfield (up.redfield@gmail.com), Tyralion (piliaiev@gmail.com)

Copyright (c) 2012 DansingBytes.ru, released under the BSD license