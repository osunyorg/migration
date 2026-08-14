class Websites::LanguagesController < Websites::ApplicationController
  before_action :set_language, only: %i[ show edit update destroy ]

  # GET /websites/1/languages or /websites/1/languages.json
  def index
    @languages = @website.languages.all
    breadcrumb
  end

  # GET /websites/1/languages/1 or /websites/1/languages/1.json
  def show
    @pages = @language.pages.ordered
    breadcrumb
  end

  # GET /websites/1/languages/new
  def new
    @language = @website.languages.new
    breadcrumb
  end

  # GET /websites/1/languages/1/edit
  def edit
    breadcrumb
    add_breadcrumb t('actions.edit')
  end

  # POST /websites/1/languages or /websites/1/languages.json
  def create
    @language = @website.languages.new(language_params)

    respond_to do |format|
      if @language.save
        format.html { redirect_to @language, notice: "Language was successfully created." }
        format.json { render :show, status: :created, location: @language }
      else
        format.html {
          render :new, status: :unprocessable_content
          breadcrumb
        }
        format.json { render json: @language.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /websites/1/languages/1 or /websites/1/languages/1.json
  def update
    respond_to do |format|
      if @language.update(language_params)
        format.html { redirect_to @language, notice: "Language was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @language }
      else
        format.html {
          render :edit, status: :unprocessable_content
          breadcrumb
          add_breadcrumb t('actions.edit')
        }
        format.json { render json: @language.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /websites/1/languages/1 or /websites/1/languages/1.json
  def destroy
    @language.destroy!

    respond_to do |format|
      format.html { redirect_to website_languages_path, notice: "Language was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_language
    @language = @website.languages.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def language_params
    params.expect(website_language: [ :name, :iso_code, :osuny_iso_code ])
  end

  def breadcrumb
    super
    add_breadcrumb Website::Language.model_name.human(count: 2), website_languages_path
    if @language
      if @language.persisted?
        add_breadcrumb @language, @language
      else
        add_breadcrumb t('actions.create')
      end
    end
  end
end
