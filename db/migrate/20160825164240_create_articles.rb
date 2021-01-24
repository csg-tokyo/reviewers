class CreateArticles < ActiveRecord::Migration[5.0]
  def change
    create_table :articles do |t|
      t.string :title
      t.integer :article_type
      t.integer :category
      t.integer :pages
      t.integer :decision
      t.integer :volume
      t.integer :number

      t.timestamps
    end
  end
end
