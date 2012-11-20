require 'spec_helper'

describe UpdatesController do
  describe "GET #show" do
    it "should load the page" do
      get :index
      response.should be_success
    end
  end
end
