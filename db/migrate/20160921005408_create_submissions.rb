class CreateSubmissions < ActiveRecord::Migration[5.0]
  def change
    create_table :submissions do |t|
      t.references :article, foreign_key: true
      t.integer :kind
      t.binary :file
      t.text :memo

      t.timestamps
    end
  end
end
