class Achievement < ActiveRecord::Base
  belongs_to :player

  validates :player_id, presence: true
  validates :type, presence: true

  scope :from_player, ->(player){ where(player_id: player.id) }

  before_create :set_defaults

  class << self
    def title
      raise "Must be implemented in subclasses"
    end

    def description
      raise "Must be implemented in subclasses"
    end

    def badge
      raise "Must be implemented in subclasses"
    end

    def eligible?(player)
      raise "Must be implemented in subclasses"
    end
  end


  private

  def set_defaults
    self.title = self.class.title
    self.description = self.class.description
    self.badge = self.class.badge
  end
end
