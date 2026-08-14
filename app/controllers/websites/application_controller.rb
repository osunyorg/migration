class Websites::ApplicationController < ApplicationController
  before_action :set_website

  protected

  def set_website
    @website = Website.find(params.expect(:website_id))
  end

  def breadcrumb
    super
    add_breadcrumb Website.model_name.human(count: 2), websites_path
    add_breadcrumb @website, @website
  end

  def default_url_options
    { path_params: { website_id: @website.id } }
  end
end
