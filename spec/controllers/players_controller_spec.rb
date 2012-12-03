require 'spec_helper'

describe PlayersController do
  let(:me) { Player.create(name: "me") }
  let(:you) { Player.create(name: "you") }
  let(:him) { Player.create(name: "him") }

  describe "GET #show" do
    before do
      Match.create(winner: me, loser: you)
    end

    it "should load the correct player" do
      get :show, id: me.to_param
      assigns(:player).should == me
      assigns(:matches).should == me.matches.descending
      assigns(:average_games_per_day).should == 1
      response.should be_success
    end

    it "should load the achievement if set" do
      achievement = me.achievements.first
      get :show, id: me.to_param, a: achievement.to_param
      assigns(:achievement).should == achievement
    end
  end

  describe "#odds" do
    it "should render probability base off of existing matches if they exist" do
      Match.create(winner: me, loser: you, occured_at: 1.day.ago)
      Match.create(winner: you, loser: me)
      matches = me.matches.where("winner_id = ? OR loser_id = ?", you.id, you.id)
      matches.count.should == 2
      get :odds, player_id: me.id, opponent_id: you.id
      response.body.should == '50.0'
    end

    it "should render 50 if winner rank and loser rank is nil" do
      me.update_attribute(:rank, nil)
      you.update_attribute(:rank, nil)
      get :odds, player_id: me.id, opponent_id: you.id
      response.body.should == '50'
    end

    it "should render 0 if winner rank is nil and lose rank is not" do
      me.update_attribute(:rank, nil)
      get :odds, player_id: me.id, opponent_id: you.id
      response.body.should == '0'
    end

    it "should render 100 if winner rank is not nil and loser rank is" do
      you.update_attribute(:rank, nil)
      get :odds, player_id: me.id, opponent_id: you.id
      response.body.should == '100'
    end
  end
end
