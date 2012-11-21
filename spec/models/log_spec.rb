require 'spec_helper'

describe Log do
  let(:me){ Player.create(name: 'me') }
  let(:you){ Player.create(name: 'you') }

  it "should be created after a match" do
    match = Match.create(winner: me, loser: you)
    me_log = me.reload.logs.first
    you_log = you.reload.logs.first
    me_log.match.should == match
    me_log.rank.should == me.rank
    you_log.match.should == match
    you_log.rank.should == you.rank
  end
end