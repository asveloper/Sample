class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable
  ROLES = %w[admin manager employee]

  has_many :transactions
  has_many :salary_records

  scope :admins, -> { where(role: 'admin') }

  def is?(role)
    self.role == role
  end

  def balance
    total_expense = self.transactions.expenses.sum('amount')
    total_income = self.transactions.income.sum('amount')
    total_income - total_expense
  end

  def total_income
    self.transactions.income.sum('amount')
  end

  def total_expense
    self.transactions.expenses.sum('amount')
  end

end
