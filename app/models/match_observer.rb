class MatchObserver < ActiveRecord::Observer
  def after_save(match)
    update_player_ranks(match)
    create_logs(match)
    check_achievements(match)
    check_specials(match)
    mark_inactive_players
  end

  private

  def update_player_ranks(match)
    winner = match.winner
    winner_rank = winner.rank || Player.maximum(:rank) + 1
    loser = match.loser
    loser_rank = loser.rank || Player.maximum(:rank) + 1

    if winner_rank > loser_rank
      new_rank = (winner_rank + loser_rank) / 2
      winner.update_attributes :rank => nil
      Player.where(['rank < ? AND rank >= ?', winner_rank, new_rank]).order('rank desc').each do |player|
        player.update_attributes :rank => player.rank + 1
      end
      winner.update_attributes :rank => new_rank, :active => true
      loser.reload.update_attributes :active => true
    end
  end

  def create_logs(match)
    winner = match.winner
    loser = match.loser
    log1 = winner.logs.create(match: match, rank: winner.rank)
    puts log1.errors.full_messages
    loser.logs.create(match: match, rank: loser.rank)
  end

  def check_achievements(match)
    winner = match.winner
    loser = match.loser
    achievements = Achievement.subclasses
    winner_achievements_needed = achievements - winner.achievements.map(&:class)
    loser_achievements_needed = achievements - loser.achievements.map(&:class)
    winner_achievements_needed.each do |achievement|
      achievement.create(player: winner, match: match) if achievement.eligible?(winner)
    end
    loser_achievements_needed.each do |achievement|
      achievement.create(player: loser, match: match) if achievement.eligible?(loser)
    end
  end

  def check_specials(match)
    achievements = Achievement::SPECIALS
    achievements.each do |achievement|
      achievement.special(match)
    end
  end

  def mark_inactive_players
    cutoff = 30.days.ago
    Player.active.each do |player|
      if player.most_recent_match.nil? || (player.most_recent_match.occurred_at < cutoff)
        player.update_attributes :active => false
        Inactive.create(player: player) if !player.achievements.map(&:class).include?(Inactive)
      end
    end

    Player.compress_ranks
  end
end