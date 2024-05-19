class CollectionProduct < ApplicationRecord
  belongs_to :collection
  belongs_to :product
end

