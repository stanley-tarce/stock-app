class AddPasswordToTraders < ActiveRecord::Migration[6.1]
  def change
    add_column :traders, :password, :string
    add_column :traders, :password_confirmation, :string
  end
end
