json.extract! actionlog, :id, :article_id, :kind, :memo, :created_at, :updated_at
json.url actionlog_url(actionlog, format: :json)