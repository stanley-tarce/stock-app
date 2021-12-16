class AddPasswordToAdmins < ActiveRecord::Migration[6.1]
  def change
    add_column :admins, :password, :string
    add_column :admins, :password_confirmation, :string
  end
end
