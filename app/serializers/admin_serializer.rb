class AdminSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :user_id
end
