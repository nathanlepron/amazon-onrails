json.extract! user, :id, :email, :password_digest, :address, :postal_code, :created_on, :created_at, :updated_at
json.url user_url(user, format: :json)
