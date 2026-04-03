class Api::AuthController < ApplicationController
  skip_before_action :authenticate_user!, only: [:signup, :login]

  #########################################
  # SIGNUP
  #########################################
  def signup
    user = User.new(user_params)

    if user.save
      token = JwtService.encode(user_id: user.id)

      render json: { token: token, user: user }
    else
      render json: { errors: user.errors.full_messages }, status: 422
    end
  end

  #########################################
  # LOGIN
  #########################################
  def login
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      token = JwtService.encode(user_id: user.id)

      render json: { token: token, user: user }
    else
      render json: { error: "Invalid credentials" }, status: 401
    end
  end

  private

  def user_params
    params.permit(:email, :password, :name)
  end
end