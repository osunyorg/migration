class Websites::MediasController < Websites::ApplicationController
  # GET /websites/1/medias or /websites/1/medias.json
  def index
    @medias = @website.medias.ordered_by_url
    breadcrumb
  end

  def show
    @media = @website.medias.find(params[:id])
    breadcrumb
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Website::Media.model_name.human(count: 2), website_medias_path
    add_breadcrumb @media, @media if @media
  end
end
