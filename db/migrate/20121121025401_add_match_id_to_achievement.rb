class AddMatchIdToAchievement < ActiveRecord::Migration
  def change
    add_column :achievements, :match_id, :integer
  end
end
