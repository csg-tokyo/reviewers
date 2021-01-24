class CreateReviews < ActiveRecord::Migration[5.0]
  def change
    create_table :reviews do |t|
      t.references :article, foreign_key: true
      t.integer :kind
      t.integer :decision
      t.boolean :award
      t.text :to_editor
      t.text :to_author
      t.text :memo

      t.timestamps
    end
  end
end
