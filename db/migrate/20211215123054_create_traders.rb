class CreateTraders < ActiveRecord::Migration[6.1]
  def change
    create_table :traders do |t|
      t.string :name
      t.string :email
      t.string :status
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
