require 'spec_helper'

describe SmiteBobby do
  let(:me) { Player.create(name: "me") }

  it "should populate achievement specific attributes to achievement on create" do
    achievement = nil
    expect { achievement = SmiteBobby.create(player: me) }.to change(me.achievements, :count).by(1)
    achievement.title.should == "Smite the Bobby"
    achievement.description.should == "Beat the one and only: Bobby Isaacson"
    achievement.badge.should == "icon-bobby"
  end

  describe "#eligible" do
    let(:you) { Player.create(name: "bobby isaacson") }
    it "Player a match during the Social Chorus Summit" do
      Match.create(winner: me, loser: you)
      SmiteBobby.eligible?(me).should be_true
      SmiteBobby.eligible?(you).should be_false
    end
  end
end