class Websites::GroupsController < Websites::ApplicationController
  before_action :set_group, only: %i[ show migrate edit update select_pages do_select_pages destroy ]

  # GET /websites/1/groups or /websites/1/groups.json
  def index
    @groups = @website.groups
    breadcrumb
  end

  # GET /websites/1/groups/1 or /websites/1/groups/1.json
  def show
    @pages = @group.pages.ordered_by_url
    @root_pages = @group.pages.root.ordered_by_url
    breadcrumb
  end

  def migrate
    @strategy = @group.strategy
    @dry_run = params[:dry_run] == "true"
    @strategy.migrate_group!(@group, dry_run: @dry_run)
    breadcrumb
    add_breadcrumb t('actions.migrate')
  end

  # GET /websites/1/groups/new
  def new
    @group = @website.groups.new
    breadcrumb
  end

  # GET /websites/1/groups/1/edit
  def edit
    breadcrumb
    add_breadcrumb t('actions.edit')
  end

  # POST /websites/1/groups or /websites/1/groups.json
  def create
    @group = @website.groups.new(group_params)

    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: "Group was successfully created." }
        format.json { render :show, status: :created, location: @group }
      else
        format.html {
          render :new, status: :unprocessable_content
          breadcrumb
        }
        format.json { render json: @group.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /websites/1/groups/1 or /websites/1/groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: "Group was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html {
          render :edit, status: :unprocessable_content
          breadcrumb
          add_breadcrumb t('actions.edit')
        }
        format.json { render json: @group.errors, status: :unprocessable_content }
      end
    end
  end

  # GET /websites/1/groups/1/select_pages
  def select_pages
    load_select_pages_variables
    breadcrumb
    add_breadcrumb t('actions.select_pages')
  end

  # POST /websites/1/groups/1/select_pages
  def do_select_pages
    select_pages_params = params.expect(website_group: [ page_ids: [] ])
    respond_to do |format|
      if @group.update(select_pages_params)
        format.html { redirect_to [:select_pages, @group, { page: params[:page], query: params[:query] }], notice: "Group was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html {
          load_select_pages_variables
          render :select_pages, status: :unprocessable_content
          breadcrumb
          add_breadcrumb t('actions.select_pages')
        }
        format.json { render json: @group.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /websites/1/groups/1 or /websites/1/groups/1.json
  def destroy
    @group.destroy!

    respond_to do |format|
      format.html { redirect_to @website, notice: "Group was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_group
    @group = @website.groups.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def group_params
    params.expect(website_group: [ :name, :strategy_klass, :settings, :osuny_target_id ])
  end

  def load_select_pages_variables
    @pages = @website.pages.root.where(group_id: [nil, @group.id]).order(:url, :group_id)
    @pages = @pages.search(params[:query]) if params[:query].present?
    @hidden_group_page_ids = @group.page_ids - @pages.pluck(:id)
  end

  def breadcrumb
    super
    add_breadcrumb Website::Group.model_name.human(count: 2), website_groups_path
    if @group
      if @group.persisted?
        add_breadcrumb @group, @group
      else
        add_breadcrumb t('actions.create')
      end
    end
  end
end
