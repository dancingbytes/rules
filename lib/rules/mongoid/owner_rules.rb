# encoding: utf-8
module Rules

  module OwnerRule

    extend  ::ActiveSupport::Concern

    # metas
    included do

      include ::Mongoid::Document

      field :owner_id,  :type => ::BSON::ObjectId
      field :model,     :type => ::String
      field :rule,      :type => ::String
      field :access,    :type => ::Boolean

      index(
        [
          [ :owner_id,  Mongo::ASCENDING ],
          [ :model,     Mongo::ASCENDING ],
          [ :rule,      Mongo::ASCENDING ]
        ],
        :name   => "owner_rule_indx",
        :unique => true
      )

      scope :by_owner, ->(owner_id) { where(:owner_id => owner_id) }

    end # include

    module ClassMethods

      def access_for(model, rule)

        return false if model.blank? || rule.blank?

        where({
          :owner_id => ::Rules.owner_id,
          :model    => model.to_s,
          :rule     => rule,
          :access   => true
        }).exists?

      end # access_for

    end # ClassMethods

  end # OwnerRule

end # Rules