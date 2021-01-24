json.extract! review, :id, :article_id, :kind, :decision, :award, :to_editor, :to_author, :memo, :created_at, :updated_at
json.url review_url(review, format: :json)