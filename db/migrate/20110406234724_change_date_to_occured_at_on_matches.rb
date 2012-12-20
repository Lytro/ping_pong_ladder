class ChangeDateTooccurredAtOnMatches < ActiveRecord::Migration
  def self.up
    remove_column :matches, :date
    add_column :matches, :occurred_at, :datetime
  end

  def self.down
    remove_column :matches, :occurred_at
    add_column :matches, :date, :datetime
  end
end
