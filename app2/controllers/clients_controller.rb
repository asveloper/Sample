class ClientsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_client, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource


  # GET /clients
  # GET /clients.json
  def index
    @client = Client.new
    @clients = Client.all.order("#{sort_column} #{sort_direction}")
  end

  # GET /clients/1
  # GET /clients/1.json
  def show
  end

  # GET /clients/new
  def new
    @client = Client.new
    @rating = 0
  end

  # GET /clients/1/edit
  def edit
    @rating = @client.rating
  end

  # POST /clients
  # POST /clients.json
  def create
    @client = Client.new(client_params)
    @client.rating = params[:score]
    respond_to do |format|
      if @client.save
        format.html { redirect_to clients_path, notice: 'Client was successfully created.' }
        format.json { render action: 'show', status: :created, location: @client }
      else
        format.html { render action: 'new' }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clients/1
  # PATCH/PUT /clients/1.json
  def update
    respond_to do |format|
      params['client']['rating'] = params[:score]
      if @client.update(client_params)
        format.html { redirect_to clients_url, notice: 'Client was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clients/1
  # DELETE /clients/1.json
  def destroy
    @client.destroy
    respond_to do |format|
      format.html { redirect_to clients_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_client
      @client = Client.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def client_params
      params.require(:client).permit(:name, :email, :source, :rating, :website, :company, :location)
    end

    def sort_column
      sort  = params[:sort] ? params[:sort].downcase : params[:sort]
      Client.column_names.include?(sort) ? params[:sort] : "name"
    end
end
