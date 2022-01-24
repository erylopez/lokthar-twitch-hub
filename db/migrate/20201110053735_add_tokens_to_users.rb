class AddTokensToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :token, :string
    add_column :users, :refresh_token, :string
    add_column :users, :token_date, :integer
  end
end
