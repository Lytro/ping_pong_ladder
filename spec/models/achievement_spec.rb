require 'spec_helper'

describe Achievement do
  let(:me) { Player.create(name: "me") }

  it "should require a player and a type" do
    Achievement.should_receive(:title).and_return("Title")
    Achievement.should_receive(:description).and_return("Description")
    Achievement.should_receive(:badge).and_return("Badge")
    achievement = me.achievements.new
    achievement.type = "Foo"
    expect { achievement.save }.to change(Achievement, :count).by(1)
  end
end