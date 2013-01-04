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

  def announce_match
    client = HipChat::Client.new(ENV['HIPCHAT_TOKEN'])
    client[App.hipchat[:room]].send(App.hipchat[:username], t('hipchat.announce.match', player_one: params[:player_one], player_two: params[:player_two]))

    redirect_to root_path, notice: t('hipchat.announce.success')
  end
end
