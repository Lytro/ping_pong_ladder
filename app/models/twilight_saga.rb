class TwilightSaga < Achievement
  class << self
    def title
      "Twilight Saga"
    end

    def description
      "Log a match after 6pm PST"
    end

    def badge
      "icon-time"
    end

    def eligible?(player)
      match = player.most_recent_match
      (match.occurred_at > Date.today.beginning_of_day + 18.hours) && (match.occurred_at < Date.today.end_of_day)
    end
  end
end