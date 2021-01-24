class AddActiveToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :admin, :boolean
    add_column :users, :active, :boolean
    add_column :users, :affiliation, :string
  end
end
