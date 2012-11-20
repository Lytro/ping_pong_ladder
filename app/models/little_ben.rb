class LittleBen < Achievement
  class << self
    def title
      "Little Ben!"
    end

    def description
      "Played more than 50 matches"
    end

    def badge
      "icon-tag"
    end

    def eligible?(player)
      player.matches.limit(50).size > 49
    end
  end
end