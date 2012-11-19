class Streak < Achievement
  class << self
    def title
      "You're on a Streak!"
    end

    def description
      "Win 5 matches in a row"
    end

    def badge
      "icon-fire"
    end

    def eligible?(player)
      last_matches = Match.where("winner_id = ? OR loser_id = ?", player.id, player.id).order("occured_at DESC").limit(5)
      return false if last_matches.count < 5
      last_matches.each{|match| return false if match.winner != player }
      true
    end
  end
end