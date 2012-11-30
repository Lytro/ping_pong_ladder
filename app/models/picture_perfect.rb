class PicturePerfect < Achievement
  class << self
    def title
      "Picture Perfect"
    end

    def description
      "Upload an avatar in your user profile"
    end

    def badge
      "icon-camera"
    end

    def eligible?(player)
      false
    end
  end
end