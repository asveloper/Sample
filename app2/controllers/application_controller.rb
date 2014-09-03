class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :balance_for, :income_for, :expenses_for, :current_month, :current_year
  helper_method :sort_column, :sort_direction
  before_filter do
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end

	rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  def balance_for(month=current_month, year=current_year, admin=nil)
    if admin
      Transaction.upto_date(month,year).admin(admin).income.complete.total - Transaction.upto_date(month,year).admin(admin).expenses.total
    else
      Transaction.upto_date(month,year).income.complete.total - Transaction.upto_date(month,year).expenses.total
    end
  end

  def income_for(month=current_month, year=current_year, admin=nil)
    if admin
      Transaction.for_month(month).for_year(year).admin(admin).income.complete.total
    else
      Transaction.for_month(month).for_year(year).income.complete.total
    end
  end

  def expenses_for(month=current_month, year=current_year, admin=nil)
    if admin
      Transaction.for_month(month).for_year(year).admin(admin).expenses.total
    else
      Transaction.for_month(month).for_year(year).expenses.total
    end
  end

  def current_month(offset=0)
    Date.today.month-offset
  end

  def current_year(offset=0)
    Date.today.year-offset
  end

  def generate_salary_sheet(month)
    employees = Employee.active
    employees.each do |e|
      salary_record = e.salary_records.new(:month => month, :salary => e.salary)
      salary_record.save
    end
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end
