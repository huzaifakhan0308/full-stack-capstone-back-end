class RoomsController < ApplicationController
  def index
    @rooms = Room.all
    render json: @rooms
  end

  def show
    @room = Room.find(params[:id])
    render json: @room
  end

  def create
    @user = User.find(params[:user_id])
    if @user.rooms_count >= 5
      render json: { error: 'User cannot create more then 5 rooms' }, status: :unprocessable_entity
      return
    end

    @room = Room.new(room_params)

    if @room.save
      render json: @room, status: :created, location: user_room_url(@room.user, @room)
    else
      puts @room.errors.full_messages
      render json: @room.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @room = Room.find(params[:id])

    @user = User.find(@room.users_id)

    if params[:password].blank? || !@user.authenticate(params[:password])
      render json: { error: 'Incorrect password' }, status: :unauthorized
      return
    end

    if @room.destroy
      render json: { message: 'Room successfully deleted' }
    else
      render json: { error: 'Failed to delete room' }, status: :unprocessable_entity
    end
  end

  private

  def room_params
    params.require(:room).permit(:room_name, :description, :wifi, :tv, :room_service, :beds, :image_url, :users_id)
  end
end
