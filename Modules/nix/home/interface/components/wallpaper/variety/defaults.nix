# variety.conf keys without a dedicated option, mirroring a stock config.
# Override any of them through programs.variety.extraSettings.
{ home, profileDir }:
{
  favorites_operations = "Downloaded:Copy;Fetched:Move;Others:Copy";

  # Image constraints
  desired_color_enabled = false;
  desired_color = "160 160 160";
  min_size_enabled = false;
  min_size = 100;
  use_landscape_enabled = false;
  lightness_enabled = false;
  lightness_mode = 0;
  min_rating_enabled = false;
  min_rating = 4;
  name_regex_enabled = false;
  name_regex = ".*";

  # First-run wizard flags and smart features
  smart_notice_shown = true;
  smart_register_shown = true;
  stats_notice_shown = true;
  smart_enabled = false;

  # Quotes
  quotes_font = "Serif 30";
  quotes_text_color = "255 255 255";
  quotes_bg_color = "80 80 80";
  quotes_bg_opacity = 55;
  quotes_text_shadow = false;
  quotes_width = 70;
  quotes_hpos = 100;
  quotes_vpos = 40;
  quotes_max_length = 250;
  quotes_disabled_sources = "Urban Dictionary";
  quotes_tags = "";
  quotes_authors = "";
  quotes_change_enabled = false;
  quotes_change_interval = 300;
  quotes_favorites_file = "${profileDir}/favorite_quotes.txt";
  quotes_favorites_format = "fortune";

  # Slideshow
  slideshow_favorites_enabled = true;
  slideshow_sources_enabled = true;
  slideshow_downloads_enabled = false;
  slideshow_custom_enabled = false;
  slideshow_custom_folder = "${home}/Pictures";
  slideshow_sort_order = "Random";
  slideshow_monitor = "All";
  slideshow_mode = "Fullscreen";
  slideshow_seconds = "6.0";
  slideshow_fade = "0.4";
  slideshow_zoom = "0.2";
  slideshow_pan = "0.05";
}
