module AdminsHelper
    def admin_params
    params.require(:admin).permit(:name, :email, :password, :password_confirmation)
  end
end