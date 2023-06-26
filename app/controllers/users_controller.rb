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
        render json: { message: 'User updated successfully',
                       user_id: @user.id,
                       username: @user.username,
                       password: params[:user][:password] }
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    else
      render json: { error: 'Invalid current password' }, status: :unprocessable_entity
    end
  end

  def destroy
    @user = User.find_by(username: params[:username])

    if @user.authenticate(params[:password])
      @user.destroy
      head :no_content
    else
      render json: { error: 'Invalid password' }, status: :unprocessable_entity
    end
  end

  def login
    @user = User.find_by(username: params[:username])
    if @user.authenticate(params[:password])
      @user.update(login: true)
      render json: { message: 'User login successfully',
                     user_id: @user.id,
                     username: @user.username,
                     password: params[:password] }
    else
      render json: { error: 'Invalid username or password' }, status: :unauthorized
    end
  end

  def logout
    @user = User.find_by(username: params[:username])
    if @user.authenticate(params[:password])
      @user.update(login: false)
      @user.save
      render json: { message: 'User logged out successfully' }
    else
      render json: { message: 'Invalid username or password' }
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation)
  end
end
