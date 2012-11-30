class PlayersController < ApplicationController
  def show
    @player = Player.find(params[:id])
    @match = @player.most_recent_match
    @achievement = Achievement.find_by_id(params[:a]) if params[:a]
  end

  def update
    @player = Player.find(params[:id])
    if @player.update_attributes(params[:player])
      flash.notice = "Lookin' good, good lookin'"
      if !@player.achievements.map(&:class).include?(PicturePerfect) && @player.avatar?
        achievement = PicturePerfect.create(player: @player)
      end
    else
      flash.error = "No bueno"
    end
    redirect_to player_path(@player, a: achievement.id)
  end
end