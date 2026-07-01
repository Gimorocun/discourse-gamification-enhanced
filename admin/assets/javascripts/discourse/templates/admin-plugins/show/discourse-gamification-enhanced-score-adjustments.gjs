import { on } from "@ember/modifier";
import { fn } from "@ember/helper";
import withEventValue from "discourse/helpers/with-event-value";
import { eq, not } from "discourse/truth-helpers";
import DBreadcrumbsItem from "discourse/ui-kit/d-breadcrumbs-item";
import DButton from "discourse/ui-kit/d-button";
import DPageSubheader from "discourse/ui-kit/d-page-subheader";
import { i18n } from "discourse-i18n";

export default <template>
  <DBreadcrumbsItem
    @path="/admin/plugins/discourse-gamification-enhanced/score-adjustments"
    @label={{i18n "gamification_enhanced.admin.score_adjustment"}}
  />

  <div class="gamification-enhanced-score-adjustment admin-detail">
    <DPageSubheader
      @titleLabel={{i18n "gamification_enhanced.admin.score_adjustment"}}
      @descriptionLabel={{i18n "gamification_enhanced.admin.description"}}
    />

    <div class="gamification-enhanced-score-adjustment__form">
      <section class="gamification-enhanced-score-adjustment__section">
        <h3>{{i18n "gamification_enhanced.form.user_section"}}</h3>
        <p class="gamification-enhanced-score-adjustment__help">
          {{i18n "gamification_enhanced.form.user_section_help"}}
        </p>

        <div class="gamification-enhanced-score-adjustment__radio-group">
          <label>
            <input
              type="radio"
              name="identifier-type"
              value="username"
              checked={{eq @controller.identifierType "username"}}
              {{on "change" (fn @controller.setIdentifierType "username")}}
            />
            {{i18n "gamification_enhanced.form.identifier_username"}}
          </label>

          <label>
            <input
              type="radio"
              name="identifier-type"
              value="user_id"
              checked={{eq @controller.identifierType "user_id"}}
              {{on "change" (fn @controller.setIdentifierType "user_id")}}
            />
            {{i18n "gamification_enhanced.form.identifier_user_id"}}
          </label>

          <label>
            <input
              type="radio"
              name="identifier-type"
              value="email"
              checked={{eq @controller.identifierType "email"}}
              {{on "change" (fn @controller.setIdentifierType "email")}}
            />
            {{i18n "gamification_enhanced.form.identifier_email"}}
          </label>
        </div>

        {{#if (eq @controller.identifierType "username")}}
          <label class="gamification-enhanced-score-adjustment__field">
            <span>{{i18n "gamification_enhanced.form.username"}}</span>
            <input
              type="text"
              value={{@controller.username}}
              placeholder={{i18n "gamification_enhanced.form.username_placeholder"}}
              {{on "input" (withEventValue (fn (mut @controller.username)))}}
            />
          </label>
        {{/if}}

        {{#if (eq @controller.identifierType "user_id")}}
          <label class="gamification-enhanced-score-adjustment__field">
            <span>{{i18n "gamification_enhanced.form.user_id"}}</span>
            <input
              type="number"
              min="1"
              value={{@controller.userId}}
              placeholder={{i18n "gamification_enhanced.form.user_id_placeholder"}}
              {{on "input" (withEventValue (fn (mut @controller.userId)))}}
            />
          </label>
        {{/if}}

        {{#if (eq @controller.identifierType "email")}}
          <label class="gamification-enhanced-score-adjustment__field">
            <span>{{i18n "gamification_enhanced.form.email"}}</span>
            <input
              type="email"
              value={{@controller.email}}
              placeholder={{i18n "gamification_enhanced.form.email_placeholder"}}
              {{on "input" (withEventValue (fn (mut @controller.email)))}}
            />
          </label>
        {{/if}}
      </section>

      <section class="gamification-enhanced-score-adjustment__section">
        <h3>{{i18n "gamification_enhanced.form.points_section"}}</h3>

        <label class="gamification-enhanced-score-adjustment__field">
          <span>{{i18n "gamification_enhanced.form.points"}}</span>
          <input
            type="number"
            min="1"
            value={{@controller.points}}
            placeholder={{i18n "gamification_enhanced.form.points_placeholder"}}
            {{on "input" (withEventValue (fn (mut @controller.points)))}}
          />
        </label>

        <div class="gamification-enhanced-score-adjustment__radio-group">
          <label>
            <input
              type="radio"
              name="action-type"
              value="add"
              checked={{eq @controller.actionType "add"}}
              {{on "change" (fn @controller.setActionType "add")}}
            />
            {{i18n "gamification_enhanced.form.action_add"}}
          </label>

          <label>
            <input
              type="radio"
              name="action-type"
              value="subtract"
              checked={{eq @controller.actionType "subtract"}}
              {{on "change" (fn @controller.setActionType "subtract")}}
            />
            {{i18n "gamification_enhanced.form.action_subtract"}}
          </label>
        </div>
      </section>

      <section class="gamification-enhanced-score-adjustment__section">
        <label class="gamification-enhanced-score-adjustment__field">
          <span>{{i18n "gamification_enhanced.form.description"}}</span>
          <textarea
            rows="3"
            value={{@controller.description}}
            placeholder={{i18n "gamification_enhanced.form.description_placeholder"}}
            {{on "input" (withEventValue (fn (mut @controller.description)))}}
          ></textarea>
        </label>
      </section>

      <div class="gamification-enhanced-score-adjustment__actions">
        <DButton
          @label="gamification_enhanced.form.submit"
          class="btn-primary"
          @disabled={{not @controller.canSubmit}}
          @action={{@controller.submit}}
        />
      </div>
    </div>

    {{#if @controller.lastEvent}}
      <div class="gamification-enhanced-score-adjustment__result">
        <h4>{{i18n "gamification_enhanced.form.last_result"}}</h4>
        <p>
          {{i18n
            "gamification_enhanced.form.last_result_detail"
            username=@controller.lastEvent.username
            points=@controller.lastEvent.points
            date=@controller.lastEvent.date
          }}
        </p>
        {{#if @controller.lastEvent.description}}
          <p class="gamification-enhanced-score-adjustment__result-description">
            {{@controller.lastEvent.description}}
          </p>
        {{/if}}
        <p class="gamification-enhanced-score-adjustment__help">
          {{i18n "gamification_enhanced.form.refresh_notice"}}
        </p>
      </div>
    {{/if}}
  </div>
</template>
