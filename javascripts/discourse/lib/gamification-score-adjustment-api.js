import { ajax } from "discourse/lib/ajax";
import { i18n } from "discourse-i18n";

export async function resolveUser(identifierType, { username, userId, email }) {
  switch (identifierType) {
    case "username": {
      const data = await ajax(`/u/${encodeURIComponent(username.trim())}.json`);
      return data.user;
    }
    case "user_id": {
      const id = parseInt(userId, 10);
      if (!id) {
        throw { message: i18n("gamification_enhanced.form.user_not_found") };
      }
      return await ajax(`/admin/users/${id}.json`);
    }
    case "email": {
      const data = await ajax("/admin/users/list/active.json", {
        data: {
          email: email.trim(),
          show_emails: true,
        },
      });
      const users = data.users || [];

      if (users.length === 0) {
        throw { message: i18n("gamification_enhanced.form.user_not_found") };
      }

      if (users.length > 1) {
        throw {
          message: i18n("gamification_enhanced.form.multiple_users_found"),
        };
      }

      return users[0];
    }
    default:
      throw { message: i18n("gamification_enhanced.form.user_not_found") };
  }
}

export async function createScoreEvent({
  userId,
  points,
  description,
  date,
}) {
  return await ajax("/admin/plugins/gamification/score_events.json", {
    type: "POST",
    data: {
      user_id: userId,
      date: date || new Date().toISOString().slice(0, 10),
      points,
      description: description || undefined,
    },
  });
}
