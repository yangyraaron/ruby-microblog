class FansController < ApplicationController
  layout "content"

  # GET /fans?user_id=?
  # GET /fans.json
  def index
    user_id = params[:user_id]
    user_id=current_user.user_id unless user_id.present?

    @fans = User.get_fans(user_id)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @fans }
    end
  end


  # POST /fans
  # POST /fans.json
  def create
    @fan = Fan.new(params[:fan])

    respond_to do |format|
      if @fan.save
        #update fans count of current user
        current_user.fans_count+=1

        format.html { redirect_to @fan, notice: 'Fan was successfully created.' }
        format.json { render json: @fan, status: :created, location: @fan }
      else
        format.html { render action: "new" }
        format.json { render json: @fan.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /fans/1
  # DELETE /fans/1.json
  def destroy
    @fan = Fan.find(params[:id])
    @fan.destroy

    respond_to do |format|
      format.html { redirect_to fans_url }
      format.json { head :no_content }
    end
  end
end
