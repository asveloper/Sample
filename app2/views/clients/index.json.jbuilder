json.array!(@clients) do |client|
  json.extract! client, :id, :name, :email, :source, :rating, :website, :company, :location
  json.url client_url(client, format: :json)
end
