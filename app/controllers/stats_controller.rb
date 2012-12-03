class StatsController < ApplicationController
  def index
    games_hash = Match.group("DATE(occured_at)").count
    @average_games_per_day = games_hash.values.sum.to_f/games_hash.keys.count.to_f
  end
end