require 'spec_helper'

describe AchievementsController do
  describe "#index" do
    before { get :index }
    it { response.should be_success }
    it { assigns(:achievements).should == Achievement.subclasses }
  end
end
