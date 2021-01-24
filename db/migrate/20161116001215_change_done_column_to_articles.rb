class ChangeDoneColumnToArticles < ActiveRecord::Migration[5.0]
  def change
    change_column_default :articles, :done, false
  end
end
