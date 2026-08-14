class ApplicationController < ActionController::Base
  include WithAuth
  include WithErrors

  def breadcrumb
    add_breadcrumb "Osuny Migrator", root_path
  end
end
