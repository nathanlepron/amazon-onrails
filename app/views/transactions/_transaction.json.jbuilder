json.extract! transaction, :id, :buyer_id, :product_id, :quantity, :created_on, :created_at, :updated_at
json.url transaction_url(transaction, format: :json)
