module AuthenticationConcern extend ActiveSupport::Concern

  include ActionController::HttpAuthentication::Token

  def authenticate_user
    token, _options = token_and_options(request)
    user_id = AuthenticationTokenService.decode(token)
    User.find(user_id)
  rescue ActiveRecord::RecordNotFound, JWT::DecodeError
    head :unauthorized
  end
end
