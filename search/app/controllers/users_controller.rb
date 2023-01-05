# frozen_string_literal: true

module Admin
  class UsersController < Admin::ApplicationController
    include SearchHelper

    before_action :set_user, only: %i[show update edit destroy undiscard]
    before_action :roles, only: %i[edit new]

    def index
      render :index, locals: {
        search_form: search_form(User),
        users: User.search(filters: search_params.to_h)
      }
    end

    def show; end

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)
      @user.confirm if auto_confirm?
      @user.save!
      redirect_to(users_path)
    rescue ActiveRecord::RecordInvalid => e
      render 'shared/invalid', locals: { message: e }
    end

    def edit; end

    def undiscard
      @user.undiscard if @user.discarded?
      redirect_to(users_path, status: :see_other)
    end

    def update
      @user.update!(user_params)
      redirect_to(users_path)
    rescue ActiveRecord::RecordInvalid => e
      render 'shared/invalid', locals: { message: e }
    end

    def destroy
      raise SelfDeletion if @user.id == current_user.id

      @user.discard
      redirect_to(users_path, status: :see_other)
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def auto_confirm?
      !!params.require(:user)[:auto_confirm]
    end

    def user_params
      params.require(:user).permit(:email, :name, :role_id, :password)
    end

    def roles
      @roles = Role.where(name: [Role::ADMIN_NAME, Role::MODERATOR_NAME]).map { |r| [r.name, r.id] }
    end

    def authorize!
      super(@user, User)
    end

    def search_params
      params.permit(:id, :name, :email, :role_id, :discarded, :order_by, :order_dir)
    end
  end
end
