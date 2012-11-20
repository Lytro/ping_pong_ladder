require 'spec_helper'

describe Bigben do
  let(:me) { Player.create(name: "me") }

  it "should populate achievement specific attributes to achievement on create" do
    achievement = nil
    expect { achievement = Bigben.create(player: me) }.to change(me.achievements, :count).by(1)
    achievement.title.should == "Big Ben!"
    achievement.description.should == "Played more than 100 matches"
    achievement.badge.should == "icon-tags"
  end

  describe "#eligible" do
    let(:you) { Player.create(name: "you") }
    it "should be eligible if you log more than 100 matches" do
      me.stub_chain(:matches, :limit, :size).and_return(100)
      Bigben.eligible?(me).should be_true
    end
  end
end