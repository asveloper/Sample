class InventoriesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_inventory, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  # GET /inventories
  # GET /inventories.json
  def index
    @inventories = Inventory.all.order("#{sort_column} #{sort_direction}")
  end

  # GET /inventories/1
  # GET /inventories/1.json
  def show
  end

  # GET /inventories/new
  def new
    @inventory = Inventory.new
  end

  # GET /inventories/1/edit
  def edit
  end

  # POST /inventories
  # POST /inventories.json
  def create
    @inventory = Inventory.new(inventory_params)

    respond_to do |format|
      if @inventory.save
        format.html { redirect_to inventories_url, notice: 'Inventory was successfully created.' }
        format.json { render action: 'show', status: :created, location: @inventory }
      else
        format.html { render action: 'new' }
        format.json { render json: @inventory.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /inventories/1
  # PATCH/PUT /inventories/1.json
  def update
    respond_to do |format|
      if @inventory.update(inventory_params)
        format.html { redirect_to inventories_url, notice: 'Inventory was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @inventory.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /inventories/1
  # DELETE /inventories/1.json
  def destroy
    @inventory.destroy
    respond_to do |format|
      format.html { redirect_to inventories_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_inventory
      @inventory = Inventory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def inventory_params
      params.require(:inventory).permit(:name, :employee_id, :serial, :comments, :category, :quantity, :value)
    end
    def sort_column
      sort  = params[:sort] ? params[:sort].downcase : params[:sort]
      Inventory.column_names.include?(sort) ? params[:sort] : "id"
    end
end
