import Controller from "@ember/controller";
import { action } from "@ember/object";
import { tracked } from "@glimmer/tracking";
import { service } from "@ember/service";
import { popupAjaxError } from "discourse/lib/ajax-error";
import { i18n } from "discourse-i18n";
import {
  createScoreEvent,
  resolveUser,
} from "../../../lib/gamification-score-adjustment-api";

export default class AdminPluginsShowDiscourseGamificationScoreAdjustmentsController extends Controller {
  @service siteSettings;
  @service toasts;

  @tracked identifierType = "username";
  @tracked username = "";
  @tracked userId = "";
  @tracked email = "";
  @tracked points = "";
  @tracked actionType = "add";
  @tracked description = "";
  @tracked submitting = false;
  @tracked lastEvent = null;

  get gamificationEnabled() {
    return this.siteSettings.discourse_gamification_enabled;
  }

  get identifierValue() {
    switch (this.identifierType) {
      case "user_id":
        return this.userId;
      case "email":
        return this.email;
      default:
        return this.username;
    }
  }

  get canSubmit() {
    if (!this.gamificationEnabled || this.submitting) {
      return false;
    }

    const points = parseInt(this.points, 10);
    if (!points || points <= 0) {
      return false;
    }

    return this.identifierValue.trim().length > 0;
  }

  @action
  setIdentifierType(type) {
    this.identifierType = type;
  }

  @action
  setActionType(type) {
    this.actionType = type;
  }

  @action
  updateUsername(value) {
    this.username = value;
  }

  @action
  updateUserId(value) {
    this.userId = value;
  }

  @action
  updateEmail(value) {
    this.email = value;
  }

  @action
  updatePoints(value) {
    this.points = value;
  }

  @action
  updateDescription(value) {
    this.description = value;
  }

  @action
  async submit() {
    if (!this.canSubmit) {
      return;
    }

    this.submitting = true;

    try {
      const user = await resolveUser(this.identifierType, {
        username: this.username,
        userId: this.userId,
        email: this.email,
      });

      const points = parseInt(this.points, 10);
      const signedPoints = this.actionType === "subtract" ? -points : points;

      const result = await createScoreEvent({
        userId: user.id,
        points: signedPoints,
        description: this.description,
      });

      this.lastEvent = {
        username: user.username,
        points: result.points,
        date: result.date,
        description: result.description,
      };
      this.points = "";
      this.description = "";

      this.toasts.success({
        duration: "short",
        data: {
          message: i18n("gamification_enhanced.form.success"),
        },
      });
    } catch (error) {
      if (error?.message) {
        this.toasts.error({
          duration: "short",
          data: { message: error.message },
        });
      } else {
        popupAjaxError(error);
      }
    } finally {
      this.submitting = false;
    }
  }
}
