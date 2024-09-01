class Api::V1::AuthenticationController < ApplicationController

  rescue_from ActionController::ParameterMissing, with: :params_missing

  rescue_from AuthenticationError, with: :handle_unauthenticated

  def create
    password=params.require(:password)
    raise AuthenticationError unless user&.authenticate(password)
    token = AuthenticationTokenService.encode(user.id)

    render json: { token: token }, status: :created
  end

  private
  def user
    @user ||= User.find_by(username: params.require(:username))
  end
  def params_missing(e)
    render json: { error: e.message }, status: :unprocessable_entity
  end
  def handle_unauthenticated()
    head :unauthorized
  end
end
