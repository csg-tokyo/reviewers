class AddContentTypeToSubmission < ActiveRecord::Migration[5.0]
  def change
    add_column :submissions, :content_type, :text
  end
end
