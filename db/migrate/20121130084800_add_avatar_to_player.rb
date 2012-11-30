class AddAvatarToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :avatar, :string
  end
end
