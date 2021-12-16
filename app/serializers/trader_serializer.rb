class TraderSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :status
end
