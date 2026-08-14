class Websites::PagesController < Websites::ApplicationController
  before_action :set_page, only: %i[ show migrate edit update destroy ]

  # GET /websites/1/pages or /websites/1/pages.json
  def index
    @pages = @website.pages.ordered_by_url
    breadcrumb
  end

  # GET /websites/1/pages/1 or /websites/1/pages/1.json
  def show
    breadcrumb
  end

  def migrate
    @migration = @page.migrate!
    breadcrumb
    add_breadcrumb 'Migration'
  end

  # GET /websites/1/pages/new
  def new
    @page = @website.pages.new
    breadcrumb
  end

  # GET /websites/1/pages/1/edit
  def edit
    breadcrumb
    add_breadcrumb "Edit"
  end

  # POST /websites/1/pages or /websites/1/pages.json
  def create
    @page = @website.pages.new(page_params)

    respond_to do |format|
      if @page.save
        format.html { redirect_to @page, notice: "Page was successfully created." }
        format.json { render :show, status: :created, location: @page }
      else
        format.html {
          render :new, status: :unprocessable_content
          breadcrumb
        }
        format.json { render json: @page.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /websites/1/pages/1 or /websites/1/pages/1.json
  def update
    respond_to do |format|
      if @page.update(page_params)
        format.html { redirect_to @page, notice: "Page was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @page }
      else
        format.html {
          render :edit, status: :unprocessable_content
          breadcrumb
          add_breadcrumb "Edit"
        }
        format.json { render json: @page.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /websites/1/pages/1 or /websites/1/pages/1.json
  def destroy
    @page.destroy!

    respond_to do |format|
      format.html { redirect_to website_pages_path, notice: "Page was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_page
    @page = @website.pages.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def page_params
    params.expect(website_page: [ :website_id, :url, :title, :language_id, :body, :crawled_at, :migrated_at, :group_id, :parent_id ])
  end

  def breadcrumb
    super
    add_breadcrumb "Pages", website_pages_path
    if @page
      if @page.persisted?
        add_breadcrumb @page, @page
      else
        add_breadcrumb "Create"
      end
    end
  end
end
