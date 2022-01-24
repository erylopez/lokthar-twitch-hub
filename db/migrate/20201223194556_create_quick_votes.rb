class CreateQuickVotes < ActiveRecord::Migration[6.0]
  def change
    create_table :quick_votes do |t|
      t.references :streamer, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :value, default: 0

      t.timestamps
    end
  end
end
