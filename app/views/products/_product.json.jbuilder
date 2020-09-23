json.extract! product, :id, :product_code, :name, :price, :created_at, :updated_at
json.url product_url(product, format: :json)
