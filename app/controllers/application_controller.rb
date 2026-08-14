class ApplicationController < ActionController::Base
  include WithAuth
  include WithErrors

  def breadcrumb
    add_breadcrumb t('home.breadcrumb'), root_path
  end
end
