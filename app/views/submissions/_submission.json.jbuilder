json.extract! submission, :id, :article_id, :kind, :file, :memo, :created_at, :updated_at
json.url submission_url(submission, format: :json)