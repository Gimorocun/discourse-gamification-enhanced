export default {
  resource: "admin.adminPlugins.show",
  path: "/plugins",
  map() {
    this.route("discourse-gamification-score-adjustments", {
      path: "score-adjustments",
    });
  },
};
