import DModal from "discourse/ui-kit/d-modal";
import GamificationScoreAdjustmentForm from "./gamification-score-adjustment-form";

export default <template>
  <DModal
    class="gamification-score-adjustment-modal"
    @title={{i18n (themePrefix "gamification_enhanced.admin.score_adjustment")}}
  >
    <:body>
      <GamificationScoreAdjustmentForm @showPageHeader={{true}} />
    </:body>
  </DModal>
</template>
