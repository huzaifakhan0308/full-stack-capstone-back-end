class UsersController < ApplicationController
  def index
    @users = User.all
    render json: @users
  end

  def show
    @user = User.find(params[:id])
    render json: @user
  end

  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: { error: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.authenticate(params[:user][:current_password])
      if @user.update(user_params.except(:current_password))
        render json: @user
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    else
      render json: { error: 'Invalid current password' }, status: :unprocessable_entity
    end
  end

  def destroy
    @user = User.find(params[:id])

    password = params[:password]

    if @user.authenticate(password)
      @user.destroy
      head :no_content
    else
      render json: { error: 'Invalid password' }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation)
  end
end
