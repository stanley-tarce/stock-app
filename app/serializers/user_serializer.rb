class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :trader, :admin, :user_type
end
