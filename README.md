# Gamification Score Adjustment（主题组件）

通过内置 Gamification 插件已有 API，在管理后台提供手动加减积分表单。**无需安装 Ruby 插件，无需单独编译插件 JS。**

## 依赖

- Discourse 内置 `discourse-gamification` 插件已启用

## 安装

1. 若曾以插件方式安装，请先移除 `plugins/discourse-gamification-enhanced` 软链接
2. 在 **管理 → 自定义 → 组件** 中安装本仓库
3. 将组件添加到你正在使用的主题上
4. 刷新页面（主题 JS 会自动随主题更新）

## 使用

1. 进入 **管理 → 插件 → Gamification**
2. 应能看到以下入口之一：
   - 顶部标签页 **手动调整积分**（在「排行榜」旁边）
   - 页面右上角 **手动调整积分** 按钮（打开弹窗表单）
3. 填写用户信息、分值与描述，选择加分或减分后提交

也可直接访问：`/admin/plugins/discourse-gamification/score-adjustments`

> 若标签页未出现，请使用右上角按钮，或确认组件已添加到**当前启用的主题**并刷新页面。

## 调用的 API

组件不自带后端，直接调用 Gamification 已有接口：

| 步骤 | 接口 |
|------|------|
| 按用户名查用户 | `GET /u/{username}.json` |
| 按用户 ID 查用户 | `GET /admin/users/{id}.json` |
| 按邮箱查用户 | `GET /admin/users/list/active.json?email=...&show_emails=true` |
| 写入积分 | `POST /admin/plugins/gamification/score_events.json` |

`POST` 参数示例：

```json
{
  "user_id": 42,
  "date": "2026-06-30",
  "points": 10,
  "description": "活动奖励"
}
```

减分时 `points` 传负数。排行榜按 Gamification 默认机制自动刷新，无需手动重算。

## 组件设置

- `gamification_score_adjustment_enabled`：是否在 Gamification 管理页显示该标签页（默认开启）
