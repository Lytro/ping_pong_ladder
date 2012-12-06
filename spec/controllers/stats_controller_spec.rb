require 'spec_helper'

describe StatsController do
  describe "display average games per day" do
    let(:me) { Player.create(name: 'me') }
    let(:you) { Player.create(name: 'you') }
    it "GET index" do
      Match.create(winner: me, loser: you)
      get :index
      assigns(:average_games_per_day).should == 1
      assigns(:played_labels).sort.should == ['Me','You']
      assigns(:played_values).should == [1,1]
    end
  end
end