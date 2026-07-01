import Component from "@glimmer/component";
import { action } from "@ember/object";
import { service } from "@ember/service";
import DButton from "discourse/ui-kit/d-button";
import GamificationScoreAdjustmentModal from "./gamification-score-adjustment-modal";

export default class GamificationScoreAdjustmentHeaderButton extends Component {
  @service modal;

  @action
  openScoreAdjustment() {
    this.modal.show(GamificationScoreAdjustmentModal);
  }

  <template>
    <DButton
      @translatedLabel={{i18n
        (themePrefix "gamification_enhanced.admin.score_adjustment")
      }}
      @icon="award"
      class="btn-default"
      @action={{this.openScoreAdjustment}}
    />
  </template>
}
