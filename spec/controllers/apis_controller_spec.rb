require 'spec_helper'

describe ApisController do
  describe "#tweet" do
    let(:me) { Player.create(name: "me") }
    let(:you) { Player.create(name: "you") }
    let!(:match) { Match.create(winner: me, loser: you) }

    it "should award the Bragging Rights badge to the winner" do
      expect { get :tweet, match_id: match.id }.to change(BraggingRights, :count).by(1)
      me.reload.achievements.map(&:class).should include(BraggingRights)
      you.reload.achievements.map(&:class).should_not include(BraggingRights)
    end

    it "should not award the Bragging Rights badge if the winner has it already" do
      BraggingRights.create(player: me, match: match)
      expect { get :tweet, match_id: match.id }.to change(BraggingRights, :count).by(0)
    end
  end

  describe "#announce_match" do
    include FakeHipChat

    it "posts to the appropriate channel in HipChat" do
      player_one = "Dudeman"
      player_two = "Dudewoman"

      HipChat::Client.stub(:new).and_return(FakeHipChat::Client.new)
      FakeHipChat::Room.any_instance.should_receive(:send).with('Pong.Lytro.com',
                                      I18n.t('hipchat.announce_match', player_one: player_one, player_two: player_two))

      post :announce_match, player_one: player_one, player_two: player_two
    end
  end
end
