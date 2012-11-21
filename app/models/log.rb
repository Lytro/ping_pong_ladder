class Log < ActiveRecord::Base
  belongs_to :player
  belongs_to :match

  validates :rank, presence: true
  validates :player_id, presence: true
  validates :match_id, presence: true
end