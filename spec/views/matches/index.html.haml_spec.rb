require 'spec_helper'

describe "matches/index.html.haml" do
  let(:occurred_at) { 2.days.ago }

  before do
    FactoryGirl.create(:match, winner: FactoryGirl.create(:winner, name: "cl"),
                       loser: FactoryGirl.create(:loser, name: "minzy"), occurred_at: occurred_at)

    assign :matches, Match.page(1).order("occurred_at DESC")
    assign :match, Match.new

    render
  end

  subject { rendered }
  it { should be }
  it { should include("Cl") }
  it { should include("Minzy") }
  it { should include(occurred_at.strftime("%Y-%m-%d")) }
  it { should include("https://twitter.com/share?") }
end
