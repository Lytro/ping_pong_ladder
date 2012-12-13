class SmiteBobby < Achievement
  class << self
    def title
      "Smite the Bobby"
    end

    def description
      "Beat the one and only: Bobby Isaacson"
    end

    def badge
      "icon-bobby"
    end

    def eligible?(player)
      match = player.most_recent_match
      if bobby = Player.find_by_name("bobby isaacson")
        return true if (match.winner_id == player.id) && (match.loser_id == bobby.id) # bobby isaacson
      end
      false
    end

    def special(match)
      if bobby = Player.find_by_name("bobby isaacson")
        loser_achievements = match.loser.achievements
        if (match.winner == bobby) && loser_achievements.map(&:class).include?(SmiteBobby)
          loser_achievements.where(type: SmiteBobby).first.destroy
        end
      end
    end
  end
end