class AddArticleToAuthors < ActiveRecord::Migration[5.0]
  def change
    add_reference :authors, :article, foreign_key: true
  end
end
