class TraderSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :status, :user_id
end
