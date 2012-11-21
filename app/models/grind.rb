class Grind < Achievement
  class << self
    def title
      "The Grind"
    end

    def description
      "Play 5 consecutive matches without changing rank"
    end

    def badge
      "icon-cogs"
    end

    def eligible?(player)
      last_5_logs = player.logs.order("created_at DESC").limit(5)
      return false if (last_5_logs.size < 5) || (last_5_logs.map(&:rank).uniq.size != 1)
      true
    end
  end
end