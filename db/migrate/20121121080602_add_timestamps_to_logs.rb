class AddTimestampsToLogs < ActiveRecord::Migration
  def change
    add_column(:logs, :created_at, :datetime)
    add_column(:logs, :updated_at, :datetime)
  end
end
