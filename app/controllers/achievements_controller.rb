class AchievementsController < ApplicationController
  skip_before_filter :authenticate

  def index
    @achievements = Achievement.subclasses
  end
end