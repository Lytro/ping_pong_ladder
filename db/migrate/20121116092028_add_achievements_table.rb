class AddAchievementsTable < ActiveRecord::Migration
  def change
    create_table :achievements do |t|
      t.integer     :player_id
      t.string      :title
      t.text        :description
      t.string      :badge
      t.string      :type
      t.timestamps
    end
  end
end
