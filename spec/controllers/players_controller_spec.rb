require 'spec_helper'

describe PlayersController do
  subject { response }

  describe "GET #show" do
    let(:me) { Player.create(name: "me") }
    it "should load the correct player" do
      get :show, :id => me.to_param
      assigns(:player).should == me
    end
  end
end
