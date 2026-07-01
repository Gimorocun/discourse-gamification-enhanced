# frozen_string_literal: true

module DiscourseGamificationEnhanced
  class ScoreAdjustmentEventSerializer < ApplicationSerializer
    attributes :id, :user_id, :date, :points, :description, :created_at

    attribute :username do
      options[:username]
    end
  end
end
