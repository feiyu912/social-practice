# API 接口文档

本文档详细描述学生社会实践管理系统的所有 API 接口。

## 基础信息

- Base URL: `http://localhost:8080`
- Content-Type: `application/x-www-form-urlencoded` 或 `application/json`
- 响应格式: JSON

---

## 1. 用户模块 `/user`

 1.1 用户登录
```
POST /user/login
```

请求参数：

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| username | String | 是 | 用户名 |
| password | String | 是 | 密码 |

响应示例：
```json
{
  "success": true,
  "message": "登录成功"
}
```

 1.2 用户注册
```
POST /user/register
```

请求参数：

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| username | String | 是 | 用户名 |
| password | String | 是 | 密码 |
| role | String | 是 | 角色(student/teacher) |
| name | String | 是 | 真实姓名 |

响应示例：
```json
{
  "success": true,
  "message": "注册成功"
}
```

 1.3 用户登出
```
GET /user/logout
```

响应：重定向到登录页面

---

## 2. 活动模块 `/activity`

 2.1 活动列表
```
GET /activity/list
```

请求参数：

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| searchKey | String | 否 | 搜索关键词 |

响应：返回活动列表页面

 2.2 添加活动
```
POST /activity/add
```

请求参数：

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| title | String | 是 | 活动标题 |
| description | String | 否 | 活动描述 |
| startTime | DateTime | 是 | 开始时间 |
| endTime | DateTime | 是 | 结束时间 |
| location | String | 否 | 活动地点 |
| quota | Integer | 是 | 名额限制 |

响应示例：
```json
{
  "success": true,
  "message": "添加成功"
}
```

 2.3 编辑活动
```
POST /activity/edit
```

请求参数：同添加活动，额外增加 `id` 参数

 2.4 删除活动
```
POST /activity/delete
```

请求参数：

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| id | Integer | 是 | 活动ID |

响应示例：
```json
{
  "success": true,
  "message": "删除成功"
}
```

---

## 3. 学生活动模块 `/studentActivity`

 3.1 学生报名
```
POST /studentActivity/register
```

请求参数：

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| activityId | Integer | 是 | 活动ID |

响应示例：
```json
{
  "success": true,
  "message": "报名成功，请等待教师审核"
}
```

业务规则：
- 只有"招募中"状态的活动可以报名
- 报名后状态为"待审核"

 3.2 取消报名
```
POST /studentActivity/cancel
```

请求参数：

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| activityId | Integer | 是 | 活动ID |

响应示例：
```json
{
  "success": true,
  "message": "退选成功"
}
```

业务规则：只有"待审核"状态才能退选

 3.3 审核通过（教师）
```
POST /studentActivity/approve
```

请求参数：

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| id | Integer | 是 | 报名记录ID |

响应示例：
```json
{
  "success": true,
  "message": "审核通过"
}
```

 3.4 审核拒绝（教师）
```
POST /studentActivity/reject
```

请求参数：

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| id | Integer | 是 | 报名记录ID |

响应示例：
```json
{
  "success": true,
  "message": "已拒绝"
}
```

 3.5 我的活动
```
GET /studentActivity/myActivities
```

响应：返回学生参与的活动列表页面

 3.6 报名管理（教师）
```
GET /studentActivity/list
```

请求参数：

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| activityId | Integer | 否 | 活动ID |

响应：返回报名管理页面

---

## 4. 小组模块 `/group`

 4.1 小组管理页面
```
GET /group/manage
```

响应：返回小组管理页面

业务规则：只显示学生已通过审核的活动

 4.2 创建小组
```
POST /group/create
```

请求参数：

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| activityId | Integer | 是 | 活动ID |
| groupName | String | 是 | 小组名称 |

响应示例：
```json
{
  "success": true,
  "message": "创建成功",
  "groupId": 1
}
```

业务规则：只有报名审核通过的学生才能创建小组

 4.3 加入小组
```
POST /group/join
```

请求参数：

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| activityId | Integer | 是 | 活动ID |
| groupId | Integer | 是 | 小组ID |

响应示例：
```json
{
  "success": true,
  "message": "加入成功"
}
```

 4.4 退出小组
```
POST /group/leave
```

请求参数：

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| groupId | Integer | 是 | 小组ID |

响应示例：
```json
{
  "success": true,
  "message": "退出成功"
}
```

业务规则：组长不能退出小组

 4.5 解散小组
```
POST /group/delete
```

请求参数：

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| groupId | Integer | 是 | 小组ID |

响应示例：
```json
{
  "success": true,
  "message": "删除成功"
}
```

业务规则：只有组长或管理员可以解散小组

 4.6 小组列表（JSON）
```
GET /group/listJson
```

请求参数：

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| activityId | Integer | 是 | 活动ID |

响应示例：
```json
{
  "groups": [
    {
      "groupId": 1,
      "groupName": "第一小组",
      "memberCount": 3
    }
  ]
}
```

---

## 5. 日常任务模块 `/dailyTask`

 5.1 任务列表
```
GET /dailyTask/list
```

请求参数：

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| activityId | Integer | 是 | 活动ID |

 5.2 提交任务
```
POST /dailyTask/submit
```

请求参数：

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| activityId | Integer | 是 | 活动ID |
| taskDate | Date | 是 | 任务日期 |
| content | String | 是 | 任务内容 |

---

## 6. 实践报告模块 `/practiceReport`

 6.1 报告列表
```
GET /practiceReport/list
```

 6.2 提交报告
```
POST /practiceReport/submit
```

请求参数：

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| activityId | Integer | 是 | 活动ID |
| title | String | 是 | 报告标题 |
| content | String | 是 | 报告内容 |

 6.3 审核报告（教师）
```
POST /practiceReport/review
```

请求参数：

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| reportId | Integer | 是 | 报告ID |
| feedback | String | 是 | 反馈内容 |

---

## 7. 成绩模块 `/grade`

 7.1 成绩列表
```
GET /grade/list
```

 7.2 评定成绩（教师）
```
POST /grade/save
```

请求参数：

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| studentId | Integer | 是 | 学生ID |
| activityId | Integer | 是 | 活动ID |
| performanceScore | Decimal | 是 | 表现分 |
| reportScore | Decimal | 是 | 报告分 |
| comments | String | 否 | 评语 |

---

## 8. 公告模块 `/notice`

 8.1 公告列表
```
GET /notice/list
```

 8.2 发布公告
```
POST /notice/add
```

请求参数：

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| title | String | 是 | 公告标题 |
| content | String | 是 | 公告内容 |

---

## 状态码说明

 报名状态 (student_activity.status)

| 值 | 说明 |
|----|------|
| 0 | 待审核 |
| 1 | 已通过 |
| 2 | 已拒绝 |

 活动状态 (practice_activity.status)

| 值 | 说明 |
|----|------|
| recruiting | 招募中 |
| ongoing | 进行中 |
| finished | 已结束 |

 报告状态 (practice_report.status)

| 值 | 说明 |
|----|------|
| pending | 待审核 |
| reviewed | 已审核 |

---

## 错误响应

所有接口的错误响应格式：

```json
{
  "success": false,
  "message": "错误信息描述"
}
```
