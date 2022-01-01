module TradersModule 
    def trader_params
    params.require(:trader).permit(:name, :email, :password, :password_confirmation, :wallet)
    end
end