class AddMemoToArticle < ActiveRecord::Migration[5.0]
  def change
    add_column :articles, :memo, :text
  end
end
