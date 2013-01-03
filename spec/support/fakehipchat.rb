module FakeHipChat
  class Client
    def [](name)
      Room.new(name)
    end
  end

  class Room
    def initialize(name)
      @name = name
    end

    def send(username, message)
    end
  end
end
