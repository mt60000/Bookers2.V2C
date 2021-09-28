class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_owner, only: [:edit, :update, :destroy]
  before_action :ensure_correct_guest, only: [:join, :leave]

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
    @group.users << current_user
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
    if @group.update(group_params)
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

  def join
    @group = Group.find(params[:group_id])
    @group_users = @group.group_users
    if @group.users << current_user
      redirect_to groups_url
    else
      render :show
    end
  end

  def leave
    @group = Group.find(params[:group_id])
    if @group.users.delete(current_user)
      redirect_to groups_url
    else
      render :show
    end
  end

  def new_mail
    @group = Group.find(params[:group_id])
  end

  def send_mail
    @group = Group.find(params[:group_id])
    group_users = @group.users
    @title = params[:title]
    @content = params[:content]
    ContactMailer.send_mail(group_users, @title, @content).deliver
  end


  private

    def group_params
      params.require(:group).permit(:name, :introduction, :image, :owner_id)
    end

    def ensure_correct_owner
      @group = Group.find(params[:group_id])
      unless @group.owner_id == current_user.id
        redirect_to users_url
      end
    end

    def ensure_correct_guest
      @group = Group.find(params[:group_id])
      if @group.owner_id == current_user.id
        redirect_to users_url
      end
    end

end
