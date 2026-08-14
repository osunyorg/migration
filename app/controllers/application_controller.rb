class ApplicationController < ActionController::Base
  include WithErrors

  def breadcrumb
    add_breadcrumb "Home", root_path
  end
end
