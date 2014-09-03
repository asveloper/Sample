class Transaction < ActiveRecord::Base
	belongs_to :project
	belongs_to :user
	TYPES = %w[income expense]
	STATUSES = %w[Pending Confirmed Complete Expected]
	SOURCES = %w[Elance oDesk Direct Other]

	scope :total, -> {sum('amount')}
	scope :income, -> {where(transaction_type: 'income')}
	scope :expenses, -> {where(transaction_type: 'expense')}
	scope :for_year, ->(y) { where("extract(year from transaction_date) = ?", y)}
	scope :for_month, ->(m) { where("extract(month from transaction_date) = ?", m)}
	scope :upto_date, ->(m,y) { where("transaction_date < ?", Date.new(y,m)+1.month)}
        scope :complete, -> {where(:status => 'complete')}
        scope :admin, ->(xid) {where("user_id = ?", xid)}

	def self.get_sort_name(params_sort,sort_column)
		if params_sort == 'user_name'
      "users.name"
    elsif params_sort == 'project_name'
      'projects.title'
    elsif params_sort == 'amount'
      'transactions.amount'
    elsif params_sort == "name"
      'employees.name'
    elsif params_sort == "salary"
      'employees.salary'
    elsif params_sort == "expected_date"
      'transactions.expected_date'
    elsif params_sort == "transaction_date"
      'transactions.transaction_date'
    elsif params_sort == "source"
      'transactions.source'
    elsif params_sort == "status"
      'transactions.status'
    elsif params_sort == "comments"
      'transactions.comments'
    else
    	sort_column
    end
  end
end
