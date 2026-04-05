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
    limiter = RateLimiter.new(rate_limit_key)

    unless limiter.allowed?
      return render json: {
        error: "Too many login attempts. Try again later."
      }, status: 429
    end

    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      token = JwtService.encode(user_id: user.id)

      render json: { token: token, user: user }
    else
      limiter.increment! # 🔥 count failed attempts

      render json: {
        error: "Invalid credentials",
        attempts_left: limiter.remaining
      }, status: 401
    end
  end

  private

  #########################################
  # Unique key per IP + email
  #########################################
  def rate_limit_key
    ip = request.remote_ip
    email = params[:email].to_s.downcase

    "#{ip}:#{email}"
  end

  def user_params
    params.permit(:email, :password, :name)
  end
end