class RemoveAuthorFromBooks < ActiveRecord::Migration[7.1]
  def change
    remove_column :books, :author, :string
  end
end
