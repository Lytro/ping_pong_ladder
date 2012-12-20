module ApplicationHelper
  def link_to_with_current(name, url)
    options = (current_page? url) ? { class: "current" } : {}
    link_to name, url, options
  end

  def location
    ENV["SC_PONG_LOCATION"] || "SF"
  end

  def player_avatar(player, options = {})
    img_src =  player.avatar.blank? ? "placeholder#{options unless options.empty?}.png" : player.avatar.url(options)
    image_tag img_src
  end

  def twitter_share_url(match)
    "https://twitter.com/share?#{{text: "#{match.winner.display_name} just beat #{match.loser.display_name} in a vigorous game of Lytro Pong!", url: match_url(match)}.to_param}"
  end
end
