# frozen_string_literal: true

Discourse::Application.routes.draw do
  post "/admin/plugins/discourse-gamification-enhanced/score-adjustments" =>
         "discourse_gamification_enhanced/admin_score_adjustments#create",
       constraints: StaffConstraint.new
end
