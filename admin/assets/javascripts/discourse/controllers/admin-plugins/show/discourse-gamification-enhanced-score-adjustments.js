import Controller from "@ember/controller";
import { action } from "@ember/object";
import { tracked } from "@glimmer/tracking";
import { service } from "@ember/service";
import { ajax } from "discourse/lib/ajax";
import { popupAjaxError } from "discourse/lib/ajax-error";
import { i18n } from "discourse-i18n";

export default class AdminPluginsShowDiscourseGamificationEnhancedScoreAdjustmentsController extends Controller {
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
    if (this.submitting) {
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
  async submit() {
    if (!this.canSubmit) {
      return;
    }

    this.submitting = true;

    try {
      const result = await ajax(
        "/admin/plugins/discourse-gamification-enhanced/score-adjustments.json",
        {
          type: "POST",
          data: {
            identifier_type: this.identifierType,
            username: this.username,
            user_id: this.userId,
            email: this.email,
            points: parseInt(this.points, 10),
            action_type: this.actionType,
            description: this.description,
          },
        }
      );

      this.lastEvent = result.event;
      this.points = "";
      this.description = "";

      this.toasts.success({
        duration: "short",
        data: {
          message: i18n("gamification_enhanced.form.success"),
        },
      });
    } catch (error) {
      popupAjaxError(error);
    } finally {
      this.submitting = false;
    }
  }
}
