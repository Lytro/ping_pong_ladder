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

    let(:player_one) { "Dudeman" }
    let(:player_two) { "Dudewoman" }
    let(:announce_match) { post :announce_match, player_one: player_one, player_two: player_two }

    before do
      HipChat::Client.stub(:new).and_return(FakeHipChat::Client.new)
    end

    it "posts to the appropriate channel in HipChat" do
      FakeHipChat::Room.any_instance.should_receive(:send).with('Pong.Lytro.com',
                                      I18n.t('hipchat.announce.match', player_one: player_one, player_two: player_two))

      announce_match
    end

    it "redirects to the home page and sets the flash notice" do
      announce_match
      response.should redirect_to(root_path)
      flash[:notice].should eq I18n.t('hipchat.announce.success')
    end
  end
end
