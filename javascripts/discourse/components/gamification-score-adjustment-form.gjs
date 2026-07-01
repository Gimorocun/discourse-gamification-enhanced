import { on } from "@ember/modifier";
import { fn } from "@ember/helper";
import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import { service } from "@ember/service";
import withEventValue from "discourse/helpers/with-event-value";
import { eq, not } from "discourse/truth-helpers";
import { popupAjaxError } from "discourse/lib/ajax-error";
import DButton from "discourse/ui-kit/d-button";
import DPageSubheader from "discourse/ui-kit/d-page-subheader";
import { i18n } from "discourse-i18n";
import {
  createScoreEvent,
  resolveUser,
} from "../lib/gamification-score-adjustment-api";

export default class GamificationScoreAdjustmentForm extends Component {
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
          message: i18n(themePrefix("gamification_enhanced.form.success")),
        },
      });

      this.args.onSuccess?.();
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

  <template>
    <div class="gamification-enhanced-score-adjustment admin-detail">
      {{#unless @showPageHeader}}
        <DPageSubheader
          @titleLabel={{i18n
            (themePrefix "gamification_enhanced.admin.score_adjustment")
          }}
          @descriptionLabel={{i18n
            (themePrefix "gamification_enhanced.admin.description")
          }}
        />
      {{/unless}}

      {{#unless this.gamificationEnabled}}
        <p class="alert alert-error">
          {{i18n (themePrefix "gamification_enhanced.form.gamification_disabled")}}
        </p>
      {{/unless}}

      <div class="gamification-enhanced-score-adjustment__form">
        <section class="gamification-enhanced-score-adjustment__section">
          <h3>{{i18n (themePrefix "gamification_enhanced.form.user_section")}}</h3>
          <p class="gamification-enhanced-score-adjustment__help">
            {{i18n (themePrefix "gamification_enhanced.form.user_section_help")}}
          </p>

          <div class="gamification-enhanced-score-adjustment__radio-group">
            <label>
              <input
                type="radio"
                name="identifier-type"
                value="username"
                checked={{eq this.identifierType "username"}}
                {{on "change" (fn this.setIdentifierType "username")}}
              />
              {{i18n (themePrefix "gamification_enhanced.form.identifier_username")}}
            </label>

            <label>
              <input
                type="radio"
                name="identifier-type"
                value="user_id"
                checked={{eq this.identifierType "user_id"}}
                {{on "change" (fn this.setIdentifierType "user_id")}}
              />
              {{i18n (themePrefix "gamification_enhanced.form.identifier_user_id")}}
            </label>

            <label>
              <input
                type="radio"
                name="identifier-type"
                value="email"
                checked={{eq this.identifierType "email"}}
                {{on "change" (fn this.setIdentifierType "email")}}
              />
              {{i18n (themePrefix "gamification_enhanced.form.identifier_email")}}
            </label>
          </div>

          {{#if (eq this.identifierType "username")}}
            <label class="gamification-enhanced-score-adjustment__field">
              <span>{{i18n (themePrefix "gamification_enhanced.form.username")}}</span>
              <input
                type="text"
                value={{this.username}}
                placeholder={{i18n
                  (themePrefix "gamification_enhanced.form.username_placeholder")
                }}
                {{on "input" (withEventValue this.updateUsername)}}
              />
            </label>
          {{/if}}

          {{#if (eq this.identifierType "user_id")}}
            <label class="gamification-enhanced-score-adjustment__field">
              <span>{{i18n (themePrefix "gamification_enhanced.form.user_id")}}</span>
              <input
                type="number"
                min="1"
                value={{this.userId}}
                placeholder={{i18n
                  (themePrefix "gamification_enhanced.form.user_id_placeholder")
                }}
                {{on "input" (withEventValue this.updateUserId)}}
              />
            </label>
          {{/if}}

          {{#if (eq this.identifierType "email")}}
            <label class="gamification-enhanced-score-adjustment__field">
              <span>{{i18n (themePrefix "gamification_enhanced.form.email")}}</span>
              <input
                type="email"
                value={{this.email}}
                placeholder={{i18n
                  (themePrefix "gamification_enhanced.form.email_placeholder")
                }}
                {{on "input" (withEventValue this.updateEmail)}}
              />
            </label>
          {{/if}}
        </section>

        <section class="gamification-enhanced-score-adjustment__section">
          <h3>{{i18n (themePrefix "gamification_enhanced.form.points_section")}}</h3>

          <label class="gamification-enhanced-score-adjustment__field">
            <span>{{i18n (themePrefix "gamification_enhanced.form.points")}}</span>
            <input
              type="number"
              min="1"
              value={{this.points}}
              placeholder={{i18n
                (themePrefix "gamification_enhanced.form.points_placeholder")
              }}
              {{on "input" (withEventValue this.updatePoints)}}
            />
          </label>

          <div class="gamification-enhanced-score-adjustment__radio-group">
            <label>
              <input
                type="radio"
                name="action-type"
                value="add"
                checked={{eq this.actionType "add"}}
                {{on "change" (fn this.setActionType "add")}}
              />
              {{i18n (themePrefix "gamification_enhanced.form.action_add")}}
            </label>

            <label>
              <input
                type="radio"
                name="action-type"
                value="subtract"
                checked={{eq this.actionType "subtract"}}
                {{on "change" (fn this.setActionType "subtract")}}
              />
              {{i18n (themePrefix "gamification_enhanced.form.action_subtract")}}
            </label>
          </div>
        </section>

        <section class="gamification-enhanced-score-adjustment__section">
          <label class="gamification-enhanced-score-adjustment__field">
            <span>{{i18n (themePrefix "gamification_enhanced.form.description")}}</span>
            <textarea
              rows="3"
              value={{this.description}}
              placeholder={{i18n
                (themePrefix "gamification_enhanced.form.description_placeholder")
              }}
              {{on "input" (withEventValue this.updateDescription)}}
            ></textarea>
          </label>
        </section>

        <div class="gamification-enhanced-score-adjustment__actions">
          <DButton
            @translatedLabel={{i18n (themePrefix "gamification_enhanced.form.submit")}}
            class="btn-primary"
            @disabled={{not this.canSubmit}}
            @action={{this.submit}}
          />
        </div>
      </div>

      {{#if this.lastEvent}}
        <div class="gamification-enhanced-score-adjustment__result">
          <h4>{{i18n (themePrefix "gamification_enhanced.form.last_result")}}</h4>
          <p>
            {{i18n
              (themePrefix "gamification_enhanced.form.last_result_detail")
              username=this.lastEvent.username
              points=this.lastEvent.points
              date=this.lastEvent.date
            }}
          </p>
          {{#if this.lastEvent.description}}
            <p class="gamification-enhanced-score-adjustment__result-description">
              {{this.lastEvent.description}}
            </p>
          {{/if}}
          <p class="gamification-enhanced-score-adjustment__help">
            {{i18n (themePrefix "gamification_enhanced.form.refresh_notice")}}
          </p>
        </div>
      {{/if}}
    </div>
  </template>
}
