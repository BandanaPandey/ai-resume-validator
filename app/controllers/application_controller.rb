class ApplicationController < ActionController::API
  before_action :authenticate_user!

  attr_reader :current_user

  private

  def authenticate_user!
    token = request.headers["Authorization"]&.split(" ")&.last

    decoded = JwtService.decode(token)

    if decoded
      @current_user = User.find_by(id: decoded[:user_id])
    end

    render json: { error: "Unauthorized" }, status: 401 unless @current_user
  end
end