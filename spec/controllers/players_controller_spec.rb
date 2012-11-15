require 'spec_helper'

describe PlayersController do
  describe "GET #show" do
    let(:me) { Player.create(name: "me") }

    it "should load the correct player" do
      get :show, :id => me.to_param
      assigns(:player).should == me
      response.should be_success
    end
  end
end
