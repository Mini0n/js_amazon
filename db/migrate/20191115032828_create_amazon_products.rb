class CreateAmazonProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :amazon_products do |t|
      t.string :asin
      t.string :name
      t.string :category
      t.string :rank
      t.string :weight
      t.string :dimensions

      t.timestamps
    end
  end
end
