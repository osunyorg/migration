class WebsitesController < ApplicationController
  before_action :set_website, only: %i[ show edit update crawl destroy ]

  # GET /websites or /websites.json
  def index
    @websites = Website.all
    breadcrumb
  end

  # GET /websites/1 or /websites/1.json
  def show
    @languages = @website.languages.ordered
    @groups = @website.groups.ordered
    @root_pages = @website.pages.root.ordered_by_url
    breadcrumb
  end

  # GET /websites/new
  def new
    @website = Website.new
    breadcrumb
  end

  # GET /websites/1/edit
  def edit
    breadcrumb
    add_breadcrumb t('actions.edit')
  end

  # POST /websites or /websites.json
  def create
    @website = Website.new(website_params)

    respond_to do |format|
      if @website.save
        format.html { redirect_to @website, notice: "Website was successfully created." }
        format.json { render :show, status: :created, location: @website }
      else
        format.html {
          render :new, status: :unprocessable_content
          breadcrumb
        }
        format.json { render json: @website.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /websites/1 or /websites/1.json
  def update
    respond_to do |format|
      if @website.update(website_params)
        format.html { redirect_to @website, notice: "Website was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @website }
      else
        format.html {
          render :edit, status: :unprocessable_content
          breadcrumb
          add_breadcrumb t('actions.edit')
        }
        format.json { render json: @website.errors, status: :unprocessable_content }
      end
    end
  end

  def crawl
    @crawler = Crawler.new(@website)
    @crawler.crawl
    # TODO vue correcte des logs, pas en put, ou mieux, job avec vue des logs
  end

  # DELETE /websites/1 or /websites/1.json
  def destroy
    @website.destroy!

    respond_to do |format|
      format.html { redirect_to websites_path, notice: "Website was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_website
    @website = Website.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def website_params
    params.expect(website: [
      :name, :url,
      :osuny_host,:osuny_api_key, :osuny_website_id,
      :default_language_id
    ])
  end

  def breadcrumb
    super
    add_breadcrumb Website.model_name.human(count: 2), websites_path
    if @website
      if @website.persisted?
        add_breadcrumb @website, @website
      else
        add_breadcrumb t('actions.create')
      end
    end
  end
end
