class ApisController < ApplicationController
  def tweet
    match = Match.find(params[:match_id])
    winner = match.winner
    award = false
    if !winner.achievements.map(&:class).include? BraggingRights
      BraggingRights.create(player: winner, match: match)
      award = true
    end
    render :text => award, :content_type => "text/javascript"
  end
end