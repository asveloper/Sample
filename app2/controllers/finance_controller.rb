class FinanceController < ApplicationController
  before_filter :set_date_params
  helper_method :sort_column_SR
  authorize_resource :class => false
  
  def balance_sheet
    month = params[:month] || current_month
    year = params[:year] || current_year
    @date = Date.new(year.to_i, month.to_i)
    sort = Transaction.get_sort_name(params[:sort],sort_column)
    @transactions = Transaction.for_year(year).for_month(month).includes(:user,:project).order("#{sort} #{sort_direction}")
    authorize! :manage, @transactions
  end

  def graphs
    month = params[:month] || current_month
    year = params[:year] || current_year
    @date = Date.new(year.to_i, month.to_i)
    @expense = Transaction.select("sum(amount) as total, transaction_type, extract(month from transaction_date) as month,extract(year from transaction_date) as year").group("transaction_type,extract(month from transaction_date),extract(year from transaction_date)").having("transaction_type = 'expense'")
    @income = Transaction.select("sum(amount) as total, transaction_type, extract(month from transaction_date) as month,extract(year from transaction_date) as year, status").group("transaction_type,extract(month from transaction_date),extract(year from transaction_date) , status").having("transaction_type = 'income' and status = 'Complete'")
  end

  def payments
    sort = Transaction.get_sort_name(params[:sort],sort_column)
    @projects = Project.all.includes(:transactions).order("#{sort} #{sort_direction}")
    @sum_table = Transaction.select("sum(amount) as total, source , status").group(:source,:status)
  end

  def salaries
    @month = params[:month] || current_month
    @year = params[:year] || current_year
    @date = Date.new(@year.to_i, @month.to_i)
    @salary_records = SalaryRecord.for(@date).order("#{sort_column_SR} #{sort_direction}")
    @disable = SalaryRecord.for(@date).paid.count == @salary_records.size ? false : true
  end

  def bonuses_and_raises
    sort = Transaction.get_sort_name(params[:sort],sort_column)
    @employees = Employee.includes(:salary_increments,:salary_records).order("#{sort} #{sort_direction}")
  end

  def generate_salaries
    month = params[:month] || current_month
    year = params[:year] || current_year
    @date = Date.new(year.to_i, month.to_i)
    generate_salary_sheet(@date)
    redirect_to '/salaries'
  end

  def send_salary_slips
    @month = params[:month] || current_month
    @year = params[:year] || current_year
    @date = Date.new(@year.to_i, @month.to_i)
    records = SalaryRecord.for(@date).includes(:employee)
    records.each do | record |
    EmployeeMailer.salary_slips(record).deliver  if record.paid == true and !record.employee.official_email.blank?
    end
    redirect_to '/salaries' ,notice: "Salary Slip Emails Delivered"
  end

  def generate_expenses_from_salaries
    SalaryRecord.generate_expenses_for(@date)
    redirect_to '/salaries'
  end

  def change_paid_by
    salary_record = SalaryRecord.find(params[:salary_record])
    salary_record.user_id = params[:paid_by];
    salary_record.paid = params[:paid_by] == '' ? false : true
    respond_to do |format|
      if salary_record.save
        month = params[:month] || current_month
        year = params[:year] || current_year
        @date = Date.new(year.to_i, month.to_i)
        @salary_records = SalaryRecord.for(@date)
        @disable = SalaryRecord.for(@date).paid.count == @salary_records.size ? false : true
        format.js
      else
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_date_params
      month = params[:month] || current_month
      year = params[:year] || current_year
      @date = Date.new(year.to_i, month.to_i)
    end

    def sort_column
      sort  = params[:sort] ? params[:sort].downcase : params[:sort]
      Transaction.column_names.include?(sort) || sort == 'name'|| sort == 'salary' || sort == 'user_name' || sort == 'project_name' ? params[:sort] : "id"
    end

    def sort_column_SR
      sort  = params[:sort] ? params[:sort].downcase : params[:sort]
      SalaryRecord.column_names.include?(sort) ? params[:sort] : "id"
    end
end
