class StatsController < ApplicationController
  def index
    @played_values = []
    @played_labels = []
    games_hash = Match.group("DATE(occured_at)").count
    @average_games_per_day = games_hash.values.sum.to_f/games_hash.keys.count.to_f
    Player.scoped.each do |p|
      @played_values << p.matches.count
      @played_labels << p.display_name
    end
  end
end