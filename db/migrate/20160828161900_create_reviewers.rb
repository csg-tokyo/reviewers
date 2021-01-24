class CreateReviewers < ActiveRecord::Migration[5.0]
  def change
    create_table :reviewers do |t|
      t.references :article, foreign_key: true
      t.string :name
      t.string :affiliation
      t.string :email

      t.timestamps
    end
  end
end
