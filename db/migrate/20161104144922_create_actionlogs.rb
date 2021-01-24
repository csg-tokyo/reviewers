class CreateActionlogs < ActiveRecord::Migration[5.0]
  def change
    create_table :actionlogs do |t|
      t.references :article, foreign_key: true
      t.integer :kind

      t.timestamps
    end
  end
end
