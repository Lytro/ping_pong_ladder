require 'spec_helper'

describe DailyLog do
  describe ".create" do
    let(:me) { Player.create(name: 'me') }
    let(:you) { Player.create(name: 'you') }

    it "should aggregate" do
      Match.create(winner: me, loser: you)
      daily_log = DailyLog.create
      daily_log.should be_valid
      daily_log.average_games_per_player.should == 0.5
      daily_log.match_count.should == 1
      daily_log.date.should == Date.today
    end
  end
end