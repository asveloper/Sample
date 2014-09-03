class SalaryRecord < ActiveRecord::Base
  belongs_to :employee
  belongs_to :user

  validates :employee_id, :month, :salary, presence: true

  serialize :distribution, Hash
  before_create :default_values
  before_update :calculate_net_salary

  SALARY_DISTRUBUTION_NAMES = %w[basic rent utilities fuel]
  SALARY_EXTRAS = %w[punctuality_points bonus medical arrears]
  SALARY_DISTRUBUTION = %w[0.6 0.2 0.1 0.1]
  PROVIDENT_DEDUCTION = 0.03

  scope :for, ->(m) { where(month: m)}
  scope :paid, -> { where(paid: true) }

  def default_values
  	self.salary ||= self.employee.salary

    SALARY_DISTRUBUTION_NAMES.each_with_index do |s, index|
      self.distribution[s] = SALARY_DISTRUBUTION[index].to_f*self.salary.to_f
    end

    SALARY_EXTRAS.each_with_index do |s, index|
       self.distribution[s] = 0
    end

    self.provident_fund = self.salary*PROVIDENT_DEDUCTION

    calculate_net_salary
  end

  def calculate_net_salary
    self.net_salary = self.salary
    SALARY_EXTRAS.each do |s|
       self.net_salary += self.distribution[s].to_i
    end
    self.net_salary -= self.salary * PROVIDENT_DEDUCTION
    self.provident_fund = self.salary * PROVIDENT_DEDUCTION
  end

  def self.generate_expenses_for(date)
    salary_records = SalaryRecord.where(month: date)
    salary_records.each do |s|
      s.to_expense
    end
  end

  def to_expense
    if self.user_id.present?
      expense = Transaction.new
      expense.title = self.month.strftime("%B %Y")+" Salary for "+self.employee.name
      expense.transaction_date = Time.now
      expense.transaction_type = 'expense'
      expense.amount = self.net_salary
      expense.user_id = self.user_id
      expense.save
    end
    self.paid = true
    self.save
  end
end
