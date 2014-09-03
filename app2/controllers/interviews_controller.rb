class InterviewsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_interview, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  # GET /interviews
  # GET /interviews.json
  def index
    @interviews = Interview.search_for_index(Riddle.escape(params[:search] ? params[:search] : ''),Riddle.escape(params[:institution] ? params[:institution] : ''),Riddle.escape(params[:position] ? params[:position] : ''),Riddle.escape(params[:status] ? params[:status] : ''),sort_column,sort_direction)
    all_interviews = Interview.all
    @positions,@institutions,@status = [],[],[]
    all_interviews.each { |interview|
      @positions << interview.position if interview.position != ''
      @status << interview.status if interview.status != ''
      @institutions << interview.institution if interview.institution != ''
    }
  end

  # GET /interviews/1
  # GET /interviews/1.json
  def show
  end

  # GET /interviews/new
  def new
    @interview = Interview.new
  end

  # GET /interviews/1/edit
  def edit
  end

  # POST /interviews
  # POST /interviews.json
  def create
    @interview = Interview.new(interview_params)

    respond_to do |format|
      if @interview.save
        format.html { redirect_to interviews_url, notice: 'Interview was successfully created.' }
        format.json { render action: 'show', status: :created, location: @interview }
      else
        format.html { render action: 'new' }
        format.json { render json: @interview.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /interviews/1
  # PATCH/PUT /interviews/1.json
  def update
    respond_to do |format|
      if @interview.update(interview_params)
        format.html { redirect_to interviews_url, notice: 'Interview was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @interview.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /interviews/1
  # DELETE /interviews/1.json
  def destroy
    @interview.destroy
    respond_to do |format|
      format.html { redirect_to interviews_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_interview
      @interview = Interview.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def interview_params
      params.require(:interview).permit(:name, :email, :phone, :status, :institution, :position, :experience, :date, :expected_salary, :current_salary, :comments, :referrer)
    end

    def sort_column
      sort  = params[:sort] ? params[:sort].downcase : params[:sort]
      Interview.column_names.include?(sort) ? params[:sort] : "name"
    end
end
