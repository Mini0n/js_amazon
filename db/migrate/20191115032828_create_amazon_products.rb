class CreateAmazonProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :amazon_products do |t|
      t.string :asin
      t.string :category
      t.decimal :rank
      t.decimal :weight
      t.string :dimensions

      t.timestamps
    end
  end
end
