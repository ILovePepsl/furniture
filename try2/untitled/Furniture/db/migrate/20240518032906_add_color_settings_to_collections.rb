class AddColorSettingsToCollections < ActiveRecord::Migration[7.1]
  def change
    add_column :collections, :background_color, :string
    add_column :collections, :text_color, :string
    add_column :collections, :title_color, :string
    add_column :collections, :product_card_background_color, :string
    add_column :collections, :product_description_color, :string
    add_column :collections, :product_price_color, :string
  end
end
