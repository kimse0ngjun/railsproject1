class MainsController < ApplicationController
  before_action :set_main, only: [:show, :edit, :update, :destroy]

  # GET /mains
  # GET /mains.json
  def index
    @mains = Main.all
  end

  # GET /mains/1
  # GET /mains/1.json
  def show
  end

  # GET /mains/new
  def new
    @main = Main.new
  end

  # GET /mains/1/edit
  def edit
  end

  # POST /mains
  # POST /mains.json
  def create
    @main = Main.new(main_params)

    respond_to do |format|
      if @main.save
        format.html { redirect_to @main, notice: 'Main was successfully created.' }
        format.json { render :show, status: :created, location: @main }
      else
        format.html { render :new }
        format.json { render json: @main.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /mains/1
  # PATCH/PUT /mains/1.json
  def update
    respond_to do |format|
      if @main.update(main_params)
        format.html { redirect_to @main, notice: 'Main was successfully updated.' }
        format.json { render :show, status: :ok, location: @main }
      else
        format.html { render :edit }
        format.json { render json: @main.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mains/1
  # DELETE /mains/1.json
  def destroy
    @main.destroy
    respond_to do |format|
      format.html { redirect_to mains_url, notice: 'Main was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_main
      @main = Main.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def main_params
      params.require(:main).permit(:name, :age)
    end
end
