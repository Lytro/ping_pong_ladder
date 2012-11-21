class MatchesController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :create
  skip_before_filter :authenticate, only: :show

  include MatchesHelper

  def create
    winner, loser = params.values_at(:winner_name, :loser_name).map { |name|
      Player.find_or_create_by_name name.strip.downcase
    }

    match = Match.new winner: winner, loser: loser

    unless [winner, loser].all?(&:valid?) && match.save
      if match.errors.present?
        flash.alert = match.errors.full_messages.join('\n')
      else
        flash.alert = "Must specify a winner and a loser to post a match."
      end
    end

    redirect_to matches_path(d: true)
  end

  def destroy
    Match.find(params[:id]).destroy
    redirect_to matches_path
  end

  def index
    @match = Match.new
    @matches = Match.order("occured_at desc")
    @most_recent_match = @matches.first if params[:d]
  end

  def show
    @match = Match.find(params[:id])
    @winner = @match.winner
    @loser = @match.loser
  end

  def rankings
    @rankings = Player.active.ranked
  end

  def players
    if params[:q]
      query = params[:q].downcase + '%'
      names = Player.where(["LOWER(name) LIKE ?", query]).collect(&:name)
    else
      names = Player.all.collect(&:name)
    end

    render text: names.collect(&:downcase).sort.uniq.collect(&:titleize).join("\n")
  end
end
