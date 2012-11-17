class Beginner < Achievement
  class << self
    def title
      "Beginner"
    end

    def description
      "Welcome to the wonderful game of pong"
    end

    def badge
      "icon-bell"
    end

    def eligible?(player)
      true
    end
  end
end