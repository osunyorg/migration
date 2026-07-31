class Websites::GroupsController < Websites::ApplicationController
  before_action :set_group, only: %i[ show edit update destroy ]

  # GET /website/groups or /website/groups.json
  def index
    @groups = @website.groups
    breadcrumb
  end

  # GET /website/groups/1 or /website/groups/1.json
  def show
    breadcrumb
  end

  # GET /website/groups/new
  def new
    @group = @website.groups.new
    breadcrumb
  end

  # GET /website/groups/1/edit
  def edit
    breadcrumb
    add_breadcrumb "Edit"
  end

  # POST /website/groups or /website/groups.json
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

  # PATCH/PUT /website/groups/1 or /website/groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: "Group was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html {
          render :edit, status: :unprocessable_content
          breadcrumb
          add_breadcrumb "Edit"
        }
        format.json { render json: @group.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /website/groups/1 or /website/groups/1.json
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
    params.expect(website_group: [ :name, :strategy_klass ])
  end

  def breadcrumb
    super
    add_breadcrumb "Groups", website_groups_path
    if @group
      if @group.persisted?
        add_breadcrumb @group, @group
      else
        add_breadcrumb "Create"
      end
    end
  end
end
