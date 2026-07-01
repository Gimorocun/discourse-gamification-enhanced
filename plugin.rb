# frozen_string_literal: true

# name: discourse-gamification-enhanced
# about: Manual gamification score adjustment for administrators.
# version: 1.0.0
# authors: Iryuu

enabled_site_setting :gamification_enhanced_enabled

register_asset "stylesheets/common/score-adjustment.scss", :admin

module ::DiscourseGamificationEnhanced
  PLUGIN_NAME = "discourse-gamification-enhanced"
end

require_relative "lib/discourse_gamification_enhanced/engine"

after_initialize do
  add_admin_route(
    "gamification_enhanced.admin.title",
    "discourse-gamification-enhanced",
    { use_new_show_route: true },
  )
end
