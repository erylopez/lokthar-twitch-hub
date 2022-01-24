class AddBirthDatesToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :birth_day, :integer
    add_column :users, :birth_month, :integer
  end
end
