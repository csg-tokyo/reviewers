class CreateEditors < ActiveRecord::Migration[5.0]
  def change
    create_table :editors do |t|
      t.references :article, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
