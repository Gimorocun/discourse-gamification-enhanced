import DModal from "discourse/ui-kit/d-modal";
import { i18n } from "discourse-i18n";
import GamificationScoreAdjustmentForm from "./gamification-score-adjustment-form";

export default <template>
  <DModal
    class="gamification-score-adjustment-modal"
    @title={{i18n "gamification_enhanced.admin.score_adjustment"}}
  >
    <:body>
      <GamificationScoreAdjustmentForm @showPageHeader={{true}} />
    </:body>
  </DModal>
</template>
