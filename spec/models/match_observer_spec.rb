require 'spec_helper'

describe MatchObserver do
  let(:me) { Player.create(name: 'me') }
  let(:you) { Player.create(name: 'you') }
  let(:observer) { MatchObserver.instance }
  let(:match) { mock_model(Match, winner: you, loser: me, occured_at: Time.now) }

  describe "#after_save" do
    it "should make the appropriate method calls" do
      observer.should_receive(:update_player_ranks)
      observer.should_receive(:create_logs)
      observer.should_receive(:check_achievements)
      observer.should_receive(:check_specials)
      observer.should_receive(:mark_inactive_players)
      observer.after_save(match)
    end
  end

  describe "#update_player_ranks" do
    it "updates rank appropriately based on match entered" do
      me.rank.should == 1
      you.rank.should == 2
      observer.send(:update_player_ranks, match)
      you.rank.should == 1
      me.rank.should == 2
    end
  end

  describe "#create_logs" do
    it "should create log from last match" do
      expect { observer.send(:create_logs, match) }.to change(Log, :count).by(2)
    end
  end

  describe "#check_achievements" do
    it "should check and award achievements of both players" do
      Beginner.should_receive(:create).at_least(:once)
      me.achievements.count.should == 0
      you.achievements.count.should == 0
      Match.create(winner: me, loser: you)
      me.achievements.count.should > 0
      you.achievements.count.should > 0
    end
  end

  describe "#check_specials" do
    it "should check and perform specials of both players" do
      bobby = Player.create(name: "bobby isaacson")
      Match.create(winner: me, loser: bobby, occured_at: 1.day.ago)
      me.reload.achievements.map(&:class).should include(SmiteBobby)
      Match.create(winner: bobby, loser: me)
      me.reload.achievements.map(&:class).should_not include(SmiteBobby)
    end
  end

  describe "#mark_inactive_players" do
    it "clears ranks when players become inactive" do
      me.should be_active
      me.rank.should == 1
      observer.send(:mark_inactive_players)
      me.reload.should be_inactive
      me.rank.should be_nil
    end
  end
end