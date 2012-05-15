# encoding: utf-8
module Rules

  module UserRule

    extend  ::ActiveSupport::Concern

    # metas
    included do

      include ::Mongoid::Document

      field :user_id,     :type => ::BSON::ObjectId
      field :model_name,  :type => ::String
      field :rule_name,   :type => ::String
      field :access,      :type => ::Boolean

      index(
        [
          [ :user_id,     Mongo::ASCENDING ],
          [ :model_name,  Mongo::ASCENDING ],
          [ :rule_name,   Mongo::ASCENDING ]
        ],
        :name   => "user_rule_indx",
        :unique => true
      )

    end # include

    def self.access_for(user_id, module_name, rule_name)

      where({
        :user_id      => user_id,
        :module_name  => module_name,
        :rule_name    => rule_name
      }).first.try(:access) && true

    end # self.access_for

  end # UserRule

end # Rules