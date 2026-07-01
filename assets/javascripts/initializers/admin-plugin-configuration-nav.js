import { withPluginApi } from "discourse/lib/plugin-api";

const PLUGIN_ID = "discourse-gamification-enhanced";

export default {
  name: "discourse-gamification-enhanced-admin-plugin-configuration-nav",

  initialize(container) {
    const currentUser = container.lookup("service:current-user");
    if (!currentUser?.admin) {
      return;
    }

    withPluginApi((api) => {
      api.setAdminPluginIcon(PLUGIN_ID, "award");
      api.addAdminPluginConfigurationNav(PLUGIN_ID, [
        {
          label: "gamification_enhanced.admin.score_adjustment",
          route:
            "adminPlugins.show.discourse-gamification-enhanced-score-adjustments",
        },
      ]);
    });
  },
};
