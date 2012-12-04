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
end
