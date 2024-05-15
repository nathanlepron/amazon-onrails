json.extract! product, :id, :name, :description, :price, :stock, :seller_id, :image_url, :created_on, :created_at, :updated_at
json.url product_url(product, format: :json)
