class CreateQuickVoteTopics < ActiveRecord::Migration[6.0]
  def change
    create_table :quick_vote_topics do |t|
      t.references :streamer, null: false, foreign_key: true
      t.string :topic
      t.boolean :active, default: false
      t.integer :last_counter, default: 0

      t.timestamps
    end
  end
end
