class AddGuestToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :guest_editor, :boolean
  end
end
