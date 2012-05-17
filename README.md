Rules
=====

User rights control system for rails


### Supported environment

Ruby:   1.9.3

Rails:  3.1, 3.2


### DSL example

    # In model
    class User

      include Mongoid::Document

      rule "Просмотр",  :all, :find, :count
      rule "Создание",  :group => :create
      rule "Изменение", :group => :change
      rule "Удаление",  :destroy_all, :group => :destroy

    end


    # You may create file into "/path/to/you_app/config/initializers" with content:
    Rules.groups({

      :create   => [:create, :save],
      :change   => [:update_all, :update_attributes, :update_attribute],
      :destroy  => [:destroy]

    })


### License

Author: Tyralion (piliaiev@gmail.com)

Copyright (c) 2012 DansingBytes.ru, released under the BSD license