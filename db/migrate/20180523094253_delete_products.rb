class DeleteProducts < ActiveRecord::Migration[5.0]
  def change
    remove_foreign_key :bookshelves,:products
    remove_index :bookshelves, :product_id
    remove_reference :bookshelves, :product
    drop_table :products
  end
end
