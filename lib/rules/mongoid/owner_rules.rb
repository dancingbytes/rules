# encoding: utf-8
module Rules

  module OwnerRule

    extend  ::ActiveSupport::Concern

    # metas
    included do

      include ::Mongoid::Document

      field :owner_id,    :type => ::BSON::ObjectId
      field :model_name,  :type => ::String
      field :rule_name,   :type => ::String
      field :access,      :type => ::Boolean

      index(
        [
          [ :owner_id,    Mongo::ASCENDING ],
          [ :model_name,  Mongo::ASCENDING ],
          [ :rule_name,   Mongo::ASCENDING ]
        ],
        :name   => "owner_rule_indx",
        :unique => true
      )

    end # include

    module ClassMethods

      def access_for(owner_id, module_name, rule_name)

        where({
          :owner_id     => owner_id,
          :module_name  => module_name.to_s,
          :rule_name    => rule_name
        }).first.try(:access) && true

      end # access_for

    end # ClassMethods

  end # OwnerRule

end # Rules