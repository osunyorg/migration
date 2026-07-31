class LanguagesController < ApplicationController
  before_action :set_language, only: %i[ show edit update destroy ]

  # GET /languages or /languages.json
  def index
    @languages = Language.all
    breadcrumb
  end

  # GET /languages/1 or /languages/1.json
  def show
    breadcrumb
  end

  # GET /languages/new
  def new
    @language = Language.new
    breadcrumb
  end

  # GET /languages/1/edit
  def edit
    breadcrumb
    add_breadcrumb "Edit"
  end

  # POST /languages or /languages.json
  def create
    @language = Language.new(language_params)

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

  # PATCH/PUT /languages/1 or /languages/1.json
  def update
    respond_to do |format|
      if @language.update(language_params)
        format.html { redirect_to @language, notice: "Language was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @language }
      else
        format.html {
          render :edit, status: :unprocessable_content
          breadcrumb
          add_breadcrumb "Edit"
        }
        format.json { render json: @language.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /languages/1 or /languages/1.json
  def destroy
    @language.destroy!

    respond_to do |format|
      format.html { redirect_to languages_path, notice: "Language was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_language
    @language = Language.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def language_params
    params.expect(language: [ :name, :iso_code ])
  end

  def breadcrumb
    super
    add_breadcrumb "Languages", languages_path
    if @language
      if @language.persisted?
        add_breadcrumb @language, @language
      else
        add_breadcrumb "Create"
      end
    end
  end
end
