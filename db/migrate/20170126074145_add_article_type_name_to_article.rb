class AddArticleTypeNameToArticle < ActiveRecord::Migration[5.0]
  def change
    add_column :articles, :article_type_name, :text
  end
end
