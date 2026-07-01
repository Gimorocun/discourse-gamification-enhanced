import { withPluginApi } from "discourse/lib/plugin-api";
import { i18n } from "discourse-i18n";

const GAMIFICATION_PLUGIN_ID = "discourse-gamification";

export default {
  name: "gamification-score-adjustment-admin-nav",

  initialize(container) {
    const currentUser = container.lookup("service:current-user");
    const siteSettings = container.lookup("service:site-settings");

    if (!currentUser?.admin) {
      return;
    }

    if (!siteSettings.discourse_gamification_enabled) {
      return;
    }

    withPluginApi((api) => {
      api.addAdminPluginConfigurationNav(GAMIFICATION_PLUGIN_ID, [
        {
          label: "gamification_enhanced.admin.score_adjustment",
          route: "adminPlugins.show.discourse-gamification-score-adjustments",
        },
      ]);
    });
  },
};
