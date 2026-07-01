# frozen_string_literal: true

module DiscourseGamificationEnhanced
  class AdminScoreAdjustmentsController < ::Admin::AdminController
    requires_plugin DiscourseGamification::PLUGIN_NAME

    def create
      raise Discourse::NotFound if !SiteSetting.discourse_gamification_enabled

      user = resolve_user
      raise Discourse::InvalidParameters.new(:user) if user.blank?

      points = params.require(:points).to_i
      raise Discourse::InvalidParameters.new(:points) if points <= 0

      action_type = params.require(:action_type)
      unless %w[add subtract].include?(action_type)
        raise Discourse::InvalidParameters.new(:action_type)
      end

      signed_points = action_type == "subtract" ? -points : points
      date = parse_date(params[:date]) || Date.today

      event =
        DiscourseGamification::GamificationScoreEvent.new(
          user_id: user.id,
          date: date,
          points: signed_points,
          description: params[:description].presence,
        )

      if event.save
        render_json_dump(
          event:
            ScoreAdjustmentEventSerializer.new(
              event,
              scope: guardian,
              root: false,
              username: user.username,
            ).as_json,
        )
      else
        render_json_error(event)
      end
    end

    private

    def resolve_user
      identifier_type = params[:identifier_type]

      case identifier_type
      when "user_id"
        User.find_by(id: params[:user_id].to_i)
      when "username"
        User.find_by_username(params[:username].to_s.strip)
      when "email"
        User.find_by_email(params[:email].to_s.strip)
      else
        raise Discourse::InvalidParameters.new(:identifier_type)
      end
    end

    def parse_date(value)
      return if value.blank?

      Date.parse(value.to_s)
    rescue ArgumentError
      raise Discourse::InvalidParameters.new(:date)
    end
  end
end
