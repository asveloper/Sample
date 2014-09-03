class Employee < ActiveRecord::Base
  has_many :salary_records
  has_many :inventories
  has_many :salary_increments
  has_many :e_leaves , :class_name => "Leave"
  has_and_belongs_to_many :projects

  validates :name, :designation, :join_date, :contact, :salary, presence: true
  validates :personal_email, :official_email,
            :presence => true,
            :uniqueness => true,
            :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }

  scope :active, -> { where(active: 1) }

  def total_provident_fund
    self.salary_records.paid.sum('provident_fund')
  end

  def self.search_for_index(search,designation,active,sort_column,sort_direction)
    if search == '' or search == nil
      Employee.search search, :conditions => {:designation => designation}, :with => {:active => active},:order => "#{sort_column} #{sort_direction}", :per_page => 100
    else
      search = search.split(" ").length > 1 ? '"' + search + '"': search
      Employee.search "@name #{search} | @comments #{search} ", :conditions => {:designation => [designation]},:order => "#{sort_column} #{sort_direction}", :with => {:active => active}, :per_page => 100
    end
  end
end
