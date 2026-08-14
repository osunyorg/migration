module ApplicationController::WithAuth
  extend ActiveSupport::Concern

  included do
    before_action :http_basic_authentication
  end

  private

  def http_basic_authentication
    if ENV["BASIC_AUTH_USER"] && ENV["BASIC_AUTH_PASSWORD"]
      authenticate_or_request_with_http_basic do |name, password|
        name == ENV["BASIC_AUTH_USER"] && password == ENV["BASIC_AUTH_PASSWORD"]
      end
    end
  end
end
