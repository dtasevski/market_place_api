class ProductSerializer < ActiveModel::Serializer
  attributes :id, :price, :title, :published
end
