class Inventory < ActiveRecord::Base
  belongs_to :employee
  
  validates :name, :category, presence: true

  CATEGORIES = ["Laptops", "Kitchen", "Electronic Equipment", "Phone", "Furniture", "Misc"]
end
