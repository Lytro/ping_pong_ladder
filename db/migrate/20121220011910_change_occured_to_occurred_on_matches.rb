class ChangeOccuredToOccurredOnMatches < ActiveRecord::Migration
  def up
    rename_column :matches, :occured_at, :occurred_at
  end

  def down
    rename_column :matches, :occurred_at, :occured_at
  end
end
