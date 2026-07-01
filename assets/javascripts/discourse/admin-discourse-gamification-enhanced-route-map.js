export default {
  resource: "admin.adminPlugins.show",

  path: "/plugins",

  map() {
    this.route("discourse-gamification-enhanced-score-adjustments", {
      path: "score-adjustments",
    });
  },
};
