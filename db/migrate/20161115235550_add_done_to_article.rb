class AddDoneToArticle < ActiveRecord::Migration[5.0]
  def change
    add_column :articles, :done, :boolean
  end
end
