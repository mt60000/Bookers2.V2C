class GroupsController < ApplicationController
  def index
    @groups = Group.all
  end

  def show
    @group = Group.find(params[:id])
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    if @group.save
      redirect_to group_url(@group)
    else
      render "users/index"
    end
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])
    if @group.update
      redirect_to groups_url
    else
      render :edit
    end
  end

  def destroy
    @group = Group.find(params[:id])
    if @group.destroy
      redirect_to users_url
    else
      render :show
    end
  end


  private

    def group_params
      params.require(:group).permit(:name, :introduction, :image)
    end

    def ensure_correct_owner
      @group = Group.find(params[:id])
      unless @group.owner_id == current_user.id
        redirect_to users_url
      end
    end

end
