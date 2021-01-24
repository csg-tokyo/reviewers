class AddEnglishTitleToArticle < ActiveRecord::Migration[5.0]
  def change
    add_column :articles, :etitle, :text
    add_column :articles, :member, :boolean
    change_column_default :articles, :member, true
  end
end
