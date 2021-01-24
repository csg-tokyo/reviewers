class AddFilePathToSubmissions < ActiveRecord::Migration[5.0]
  def change
    add_column :submissions, :file_path, :string
  end
end
