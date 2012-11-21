class AddLogsTable < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.integer :player_id
      t.integer :match_id
      t.integer :rank
      end
  end
end
