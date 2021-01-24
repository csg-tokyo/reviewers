class AddPositionToArticle < ActiveRecord::Migration[5.0]
  def change
    add_column :articles, :position, :integer
  end
end
