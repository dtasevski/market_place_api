class ProductSerializer < ActiveModel::Serializer
  attributes :id, :price, :title, :published
  has_one :user
end
