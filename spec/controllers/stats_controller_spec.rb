require 'spec_helper'

describe StatsController do
  describe "display average games per day" do
    let(:me) { Player.create(name: 'me') }
    let(:you) { Player.create(name: 'you') }
    it "GET index" do
      Match.create(winner: me, loser: you)
      get :index
      assigns(:average_games_per_day).should == 1
      assigns(:matches_labels).sort.should == ['Me - 1','You - 1']
      assigns(:matches_values).should == [1,1]
      assigns(:winning_matches_labels).sort.should == ['Me - 1','You - 0']
      assigns(:winning_matches).should == [1,0]
      assigns(:winning_percentage_labels).sort.should == ['Me - 100.000%','You - 0.000%']
      assigns(:winning_percentage).should == [100.000,0.000]
    end
  end
end