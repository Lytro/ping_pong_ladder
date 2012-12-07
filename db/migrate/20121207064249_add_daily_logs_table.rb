class AddDailyLogsTable < ActiveRecord::Migration
  def change
    create_table :daily_logs do |t|
      t.float :average_games_per_player
      t.integer :match_count
      t.date :date

      t.timestamps
    end
  end
end
