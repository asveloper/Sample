json.array!(@inventories) do |inventory|
  json.extract! inventory, :id, :name, :serial, :comments, :category, :quantity, :value
  json.url inventory_url(inventory, format: :json)
end
