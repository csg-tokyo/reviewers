class AddAbstractToArticle < ActiveRecord::Migration[5.0]
  def change
    add_column :articles, :is_letter, :boolean
    add_column :articles, :abstract, :text
    add_column :articles, :contact, :text
  end
end
