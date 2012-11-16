class PlayersController < ApplicationController
  def show
    @player = Player.find(params[:id])
    @match = @player.most_recent_match
  end
end