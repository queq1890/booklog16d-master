class DeleteBookshelves < ActiveRecord::Migration[5.0]
  def change
    drop_table :bookshelves
  end
end
