import DBreadcrumbsItem from "discourse/ui-kit/d-breadcrumbs-item";
import { i18n } from "discourse-i18n";
import GamificationScoreAdjustmentForm from "../../../components/gamification-score-adjustment-form";

export default <template>
  <DBreadcrumbsItem
    @path="/admin/plugins/discourse-gamification/score-adjustments"
    @label={{i18n "gamification_enhanced.admin.score_adjustment"}}
  />

  <GamificationScoreAdjustmentForm />
</template>
