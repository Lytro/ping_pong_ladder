class Match < ActiveRecord::Base
  validates :winner,      presence: true
  validates :loser,       presence: true
  validates :occured_at,  presence: true
  validate :daily_limit

  belongs_to :winner, :class_name => 'Player'
  belongs_to :loser, :class_name => 'Player'

  has_many :achievements

  before_validation :set_default_occured_at_date, on: :create

  scope :occurred_today, where("occured_at >= ? AND occured_at <= ?", Date.today.beginning_of_day, Date.today.end_of_day)
  scope :descending, order("occured_at DESC")

  private

  def set_default_occured_at_date
    self.occured_at ||= Time.now
  end

  def daily_limit
    winner_id = self.winner_id
    loser_id = self.loser_id
    played_today = Match.where(winner_id: winner_id, loser_id: loser_id).occurred_today.present? || Match.where(winner_id: loser_id, loser_id: winner_id).occurred_today.present?
    (errors[:bad_match] << "- Already played today!") if played_today
  end
end
