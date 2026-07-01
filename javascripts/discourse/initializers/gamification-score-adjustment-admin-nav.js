import { configNavForPlugin } from "discourse/lib/admin-plugin-config-nav";
import { withPluginApi } from "discourse/lib/plugin-api";
import GamificationScoreAdjustmentHeaderButton from "../components/gamification-score-adjustment-header-button";
import { t } from "../lib/gamification-score-adjustment-i18n";

const GAMIFICATION_PLUGIN_ID = "discourse-gamification";
const SCORE_ROUTE = "adminPlugins.show.discourse-gamification-score-adjustments";

function registerGamificationScoreAdjustmentNav() {
  const existing = configNavForPlugin(GAMIFICATION_PLUGIN_ID);
  const links = [...(existing?.links || [])];

  if (!links.some((link) => link.route === SCORE_ROUTE)) {
    links.push({
      text: t("gamification_enhanced.admin.score_adjustment"),
      route: SCORE_ROUTE,
    });
  }

  withPluginApi((api) => {
    api.addAdminPluginConfigurationNav(GAMIFICATION_PLUGIN_ID, links);
    api.registerPluginHeaderActionComponent(
      GAMIFICATION_PLUGIN_ID,
      GamificationScoreAdjustmentHeaderButton
    );
  });
}

export default {
  name: "gamification-score-adjustment-admin-nav",
  after: "discourse-gamification-admin-plugin-configuration-nav",

  initialize(container) {
    const currentUser = container.lookup("service:current-user");
    const siteSettings = container.lookup("service:site-settings");

    if (!currentUser?.admin) {
      return;
    }

    if (!siteSettings.discourse_gamification_enabled) {
      return;
    }

    registerGamificationScoreAdjustmentNav();
  },
};
