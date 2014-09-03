class EmployeesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_employee, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource


  # GET /employees
  # GET /employees.json
  def index
    if params[:active].blank? && params[:commit] == 'Search'
      @active = false
    else
      @active = true
    end
    @employees = Employee.search_for_index(Riddle.escape(params[:search] ? params[:search] : ''),Riddle.escape(params[:designation] ? params[:designation] : ''),@active,sort_column,sort_direction)
    @designations = Employee.all.pluck(:designation).uniq.sort
  end

  # GET /employees/1
  # GET /employees/1.json
  def show
    @salaries = @employee.salary_records.paid
    @salary_increment = @employee.salary_increments.new
    @leafe = @employee.e_leaves.new
  end

  # GET /employees/new
  def new
    @employee = Employee.new
  end

  # GET /employees/1/edit
  def edit
  end

  # POST /employees
  # POST /employees.json
  def create
    @employee = Employee.new(employee_params)
    #@employee.join_date = Date.strptime(params[:employee][:join_date], "%m/%d/%Y").strftime("%d/%m/%y")
    respond_to do |format|
      if @employee.save
        format.html { redirect_to employees_path, notice: 'Employee was successfully created.' }
        format.json { render action: 'show', status: :created, location: @employee }
      else
        format.html { render action: 'new' }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /employees/1
  # PATCH/PUT /employees/1.json
  def update
    respond_to do |format|
      if @employee.update(employee_params)
        path = params[:from] == 'employee' ? @employee : employees_path
        format.html { redirect_to path, notice: 'Employee was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /employees/1
  # DELETE /employees/1.json
  def destroy
    @employee.destroy
    respond_to do |format|
      format.html { redirect_to employees_url }
      format.json { head :no_content }
    end
  end

  def data
    @employees = Employee.all.order("#{sort_column} #{sort_direction}")
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_employee
      @employee = Employee.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def employee_params
      params.require(:employee).permit(:name,:personal_email,:official_email,:comments, :designation, :leaves, :join_date, :contact, :secondary_contact, :address, :id_number, :salary, :bank_account, :referrer, :last_leaves_reset, :blood_group, :active)
    end

    def sort_column
      sort  = params[:sort] ? params[:sort].downcase : params[:sort]
      Employee.column_names.include?(sort) ? params[:sort] : "name"
    end
end
