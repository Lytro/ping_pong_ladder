class Summit < Achievement
  class << self
    def title
      "The Summit"
    end

    def description
      "Played during the Social Chorus Summit"
    end

    def badge
      "icon-briefcase"
    end

    def eligible?(player)
      previous_match_date = player.most_recent_match.occured_at
      return false if (previous_match_date < Date.new(2012,12,17)) || (previous_match_date > Date.new(2012,12,21))
      true
    end
  end
end