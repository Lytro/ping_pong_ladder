class BigBen < Achievement
  class << self
    def title
      "Big Ben!"
    end

    def description
      "Played more than 100 matches"
    end

    def badge
      "icon-tags"
    end

    def eligible?(player)
      player.matches.limit(100).size > 99
    end
  end
end