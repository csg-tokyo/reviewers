class AddApprovedToArticle < ActiveRecord::Migration[5.0]
  def change
    add_column :articles, :approved, :boolean
    change_column_default :articles, :approved, false
  end
end
