require 'spec_helper'

describe Summit do
  let(:me) { Player.create(name: "me") }

  it "should populate achievement specific attributes to achievement on create" do
    achievement = nil
    expect { achievement = Summit.create(player: me) }.to change(me.achievements, :count).by(1)
    achievement.title.should == "The Summit"
    achievement.description.should == "Played during the Social Chorus Summit"
    achievement.badge.should == "icon-briefcase"
  end

  describe "#eligible" do
    let(:you) { Player.create(name: "you") }
    it "Player a match during the Social Chorus Summit" do
      Match.create(winner: me, loser: you, occured_at: Date.parse("2012-12-12"))
      Summit.eligible?(me).should be_true
      Summit.eligible?(you).should be_true
    end
  end
end