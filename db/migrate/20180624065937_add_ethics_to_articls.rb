class AddEthicsToArticls < ActiveRecord::Migration[5.0]
  def change
    add_column :articles, :ethics, :text
  end
end
