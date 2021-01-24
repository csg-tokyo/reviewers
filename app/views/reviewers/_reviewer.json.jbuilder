json.extract! reviewer, :id, :article_id, :name, :affiliation, :email, :created_at, :updated_at
json.url reviewer_url(reviewer, format: :json)