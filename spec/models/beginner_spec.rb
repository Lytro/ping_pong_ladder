require 'spec_helper'

describe Beginner do
  let(:me) { Player.create(name: "me") }

  it "should populate achievement specific attributes to achievement on create" do
    achievement = nil
    expect { achievement = Beginner.create(player: me) }.to change(me.achievements, :count).by(1)
    achievement.title.should == "Beginner"
    achievement.description.should == "Welcome to the wonderful game of pong"
    achievement.badge.should == "icon-bell"
  end
end