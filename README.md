# Discourse Gamification Enhanced

为 Discourse 内置 Gamification 插件提供管理员手动加减积分界面。

## 依赖

- Discourse 内置 `discourse-gamification` 插件已启用（`discourse_gamification_enabled`）

## 安装

将本目录放入 Discourse 的 `plugins/` 目录，例如：

```bash
ln -s /path/to/discourse-gamification-enhanced /path/to/discourse/plugins/discourse-gamification-enhanced
```

然后重启 Discourse，在 **管理 → 插件** 中启用 **Gamification Enhanced**。

## 使用

1. 进入 **管理 → 插件 → Gamification Enhanced**
2. 打开 **手动调整积分** 标签页
3. 选择用户标识方式（用户名 / 用户 ID / 邮箱），填写对应字段
4. 输入分值，选择 **加分** 或 **减分**
5. 可选填写描述，点击 **提交调整**

积分会写入 Gamification 的 `gamification_score_events` 表，排行榜按系统默认机制（约每小时）自动刷新，无需手动重算。

## API

管理员可调用：

```http
POST /admin/plugins/discourse-gamification-enhanced/score-adjustments.json
```

参数：

| 参数 | 说明 |
|------|------|
| `identifier_type` | `username` / `user_id` / `email` |
| `username` | 用户名（`identifier_type=username` 时） |
| `user_id` | 用户 ID（`identifier_type=user_id` 时） |
| `email` | 邮箱（`identifier_type=email` 时） |
| `points` | 正整数 |
| `action_type` | `add` 或 `subtract` |
| `description` | 可选描述 |
| `date` | 可选日期（默认今天） |
