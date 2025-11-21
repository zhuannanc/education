# Classroom Hero - 教室积分管理系统

<div align="center">
<img width="1200" height="475" alt="Classroom Hero" src="https://github.com/user-attachments/assets/0aa67016-6eaf-458a-adb2-6e31a0763ed6" />
</div>

## 项目概述

Classroom Hero 是一个面向教育场景的移动端教室积分管理系统。通过游戏化的积分机制、习惯养成、挑战任务等方式激励学生，帮助教师更轻松地管理班级，提升学生参与度。

### 核心特性

- **积分系统**：6大类奖惩规则，覆盖学习成果、习惯养成、时间管理等多个维度
- **游戏化体验**：等级、经验值、勋章、PK对战、挑战赛等元素
- **习惯追踪**：11种可定制习惯打卡，培养学生良好习惯
- **班级管理**：支持挑战、PK、任务分配、勋章授予等功能
- **大屏展示**：独立的大屏展示系统，实时呈现排名和成就
- **多端适配**：移动端管理后台 + 大屏展示

### 技术栈

- **前端**：React 18 + Vite + TypeScript + Tailwind CSS
- **后端**：Express.js（静态文件服务 + SSE 实时推送）
- **数据库**：MySQL（事件存储）
- **部署**：Sealos + Devbox
- **实时通信**：Server-Sent Events (SSE)

## 快速开始

### 前置要求

- Node.js 18+
- npm 或 yarn

### 安装依赖

```bash
cd growark
npm install
```

### 启动应用

**开发模式（推荐）**:
```bash
bash entrypoint.sh
```

**生产模式**:
```bash
bash entrypoint.sh production
```

### 访问应用

- 移动端管理后台: http://localhost:3000
- 大屏展示: http://localhost:5000

## 项目结构

```
/home/devbox/project/
├── entrypoint.sh              # 启动脚本（自动识别开发/生产环境）
├── README.md                  # 项目说明
├── STARTUP.md                 # 详细启动指南
├── .logs/                     # 日志目录
│   ├── dev-3000.log          # 移动端开发服务器日志
│   ├── bigscreen-5000.log    # 大屏服务器日志
│   └── server-8080.log       # Express 服务器日志（生产）
│
├── growark/                   # 主前端应用
│   ├── package.json           # 项目依赖
│   ├── tsconfig.json          # TypeScript 配置
│   ├── vite.config.ts         # Vite 构建配置
│   ├── index.html             # 移动端入口 HTML
│   ├── index.tsx              # 移动端入口 TSX
│   ├── App.tsx                # 核心应用逻辑（800+ 行）
│   ├── types.ts               # 类型定义（学生、任务、挑战等）
│   ├── constants.ts           # 积分规则配置（6大类50+奖项）
│   │
│   ├── pages/                 # 页面组件
│   │   ├── Home.tsx           # 首页：学生积分管理
│   │   ├── ClassManage.tsx    # 班级管理：挑战/PK/任务/勋章（75KB）
│   │   ├── Habits.tsx         # 习惯追踪
│   │   └── Settings.tsx       # 系统设置
│   │
│   ├── components/            # 公共组件
│   │   ├── BottomNav.tsx      # 底部导航栏
│   │   └── ActionSheet.tsx    # 操作面板
│   │
│   ├── services/              # 服务层
│   │   ├── api.ts             # API 接口封装
│   │   ├── mockData.ts        # Mock 数据生成器
│   │   ├── geminiService.ts   # Google Gemini AI 集成
│   │   └── screenAdapter.ts   # 屏幕适配工具
│   │
│   ├── server/                # 后端服务
│   │   ├── package.json       # 后端依赖
│   │   ├── server.js          # Express 服务器（API + SSE）
│   │   ├── .env               # 环境配置（数据库连接）
│   │   └── .env.example       # 环境配置示例
│   │
│   ├── bigscreen/             # 大屏展示子系统
│   │   ├── package.json       # 大屏依赖
│   │   ├── index.html         # 大屏入口 HTML
│   │   ├── main.tsx           # 大屏入口 TSX
│   │   ├── preview-server.js  # 大屏预览服务器
│   │   ├── types.ts           # 大屏类型定义
│   │   ├── vercel.json        # Vercel 部署配置
│   │   │
│   │   ├── components/        # 大屏组件
│   │   │   ├── Header.tsx                 # 顶部标题
│   │   │   ├── LevelUpNotification.tsx    # 升级通知
│   │   │   ├── TopStudentCard.tsx         # 榜首学生卡片
│   │   │   ├── HonorBadgesCard.tsx        # 荣誉勋章
│   │   │   ├── HonorCard.tsx              # 荣誉榜单
│   │   │   ├── ExperienceLevelCard.tsx    # 经验等级
│   │   │   ├── LeaderboardCard.tsx        # 排行榜
│   │   │   ├── StudentLeaderboard.tsx     # 学生榜单详情
│   │   │   ├── TeamLeaderboard.tsx        # 团队榜单
│   │   │   ├── PKBoardCard.tsx           # PK对战版
│   │   │   ├── ChallengeArenaCard.tsx    # 挑战赛场
│   │   │   └── TeamTicker.tsx            # 团队跑马灯
│   │   │
│   │   ├── services/
│   │   │   └── sealosService.ts          # Sealos 服务集成
│   │   │
│   │   └── components/icons/
│   │       └── CrownIcon.tsx              # 皇冠图标
│   │
│   └── dist/                  # 构建输出目录
│       └── ...               # 生产构建文件
│
│
└── server/                    # 生产环境静态资源
    ├── index.html            # 前端入口
    ├── config.js             # 环境变量配置
    └── assets/               # 构建后的 JS/CSS 资源
```

## 积分规则详情

系统包含6大类50+积分奖项（详见 `growark/constants.ts`）：

### I. 学习成果与高价值奖励 (ScoreCategory.ONE)
- 正式测试高分奖 (95分+)：+1000积分
- 正式测试满分奖 (100分)：+5000积分
- 重大检测全对 (听写/默写)：+100积分
- 基础过关检测：+10积分/项
- 连续成就挑战 (连续5天全对)：+550积分
- 课外拓展完成：+5积分

### II. 自主管理与习惯养成 - 午托篇 (ScoreCategory.TWO)
- 按时安静回校 (12:15前)：+5积分
- 午餐管理 (有序/不挑食/光盘)：+5积分
- 午间阅读 (安静/完成计划)：+5积分
- 安静午休 (自助午休)：+5积分
- 离校准备 (叠被/卫生/排队)：+5积分

### III. 自主管理与学习过程 - 晚辅篇 (ScoreCategory.THREE)
- 自主登记与计划：+10积分
- 自主检查核对 (按标准)：+10积分
- 主动改错问询 (无需催促)：+10积分
- 复盘整理 (分析原因)：+10积分

### IV. 学习效率与时间管理 (ScoreCategory.FOUR)
- 在学校完成作业：+10积分
- 晚托30分钟内完成作业：+10积分
- 19:30前结束所有学习任务：+20积分

### V. 质量、进步与整理 (ScoreCategory.FIVE)
- 卷面加分 (整洁规范)：+10积分
- 进步加分 (任一方面)：+10积分
- 纪律良好 (正式上课)：+10积分
- 离校卫生整理：+10积分

### VI. 纪律与惩罚细则 (ScoreCategory.SIX)
- 一般违纪 (经提醒后仍不遵守)：-50积分
- 严重违纪 (擅自离教室)：-100积分
- 恶意严重违纪 (清零当日)：-9999积分

## 游戏化元素

### 等级系统
- 经验值驱动升级
- 升级公式：`expForLevel = 100 * 1.25^(level-1)`
- 经验来源：积分奖励、挑战成功、PK胜利等

### 勋章体系
11种勋章：`⭐ 🏆 🚀 🎨 📚 💡 🏃 🌞 🦁 🐯 🦊`
- 获得勋章奖励 +50积分 和 +200经验
- 勋章历史记录追踪

### 习惯追踪
11种习惯：`📋 📖 🧹 🥛 🏃‍♂️ 🎹 🧠 🗣️ 🤝 🍽️ 🛌`
- 每日打卡 +5积分
- 习惯统计追踪

### 挑战与PK
- **挑战赛**：多人主题挑战，成功奖励积分和经验
- **PK对战**：1v1对战，胜者+20积分，参与者+5积分

### 任务系统
- 任务分配和完成追踪
- 完成任务获得经验值
- 任务历史记录

## API 端点

### GET 请求
- `/health` - 健康检查
- `/students` - 获取所有学生
- `/events` - SSE 事件推送（实时更新）

### POST 请求
- `/score` - 更新学生积分
- `/habit-checkin` - 习惯打卡
- `/challenge-status` - 更新挑战状态（成功/失败）
- `/pk-winner` - PK获胜
- `/task-complete` - 任务完成
- `/badge-grant` - 授予勋章

## 开发指南

### 添加新页面

在 `growark/pages/` 目录创建新页面组件，在 `App.tsx` 中注册路由：

```tsx
// App.tsx
import NewPage from './pages/NewPage';

<Routes>
  <Route path="/new-page" element={<NewPage />} />
</Routes>

// BottomNav.tsx 添加导航项
```

### 修改积分规则

编辑 `growark/constants.ts` 中的 `POINT_PRESETS` 数组：

```typescript
export const POINT_PRESETS: PointPreset[] = [
  { label: '新规则名称', value: 100, category: ScoreCategory.ONE },
  // ...
];
```

### 添加新习惯

编辑 `growark/constants.ts` 中的 `HABIT_ICONS` 数组：

```typescript
export const HABIT_ICONS = [
  '📝', '📖', '🧹', '🥛', '🏃‍♂️', '🎹', '🧠', '🗣️', '🤝', '🍽️', '🛌', '新图标'
];
```

### 自定义大屏组件

在 `growark/bigscreen/components/` 目录创建新组件，在 `bigscreen/main.tsx` 中导入并使用。

### 集成 Gemini AI

在 `.env.local` 中配置 API Key：

```
GEMINI_API_KEY=your_api_key_here
```

使用 `geminiService.ts` 中的封装函数：

```typescript
import { generateContent } from './services/geminiService';

const response = await generateContent(prompt);
```

## 部署

### Sealos 部署

访问地址：
- 移动端: `https://mcmgfetxlrug.sealosbja.site`
- 大屏: `https://mcmgfetxlrug.sealosbja.site:8081`

端口转发配置：
- 8080 → 3000（移动端）
- 8081 → 5000（大屏）

### Vercel 部署

大屏展示支持 Vercel 部署（见 `bigscreen/vercel.json`）。

## 故障排查

### 端口被占用

```bash
# 查看进程
ss -tlnp | grep 3000  # 移动端
ss -tlnp | grep 5000  # 大屏
ss -tlnp | grep 8080  # Express

# 杀死进程
kill -9 <PID>
```

### 查看日志

```bash
# 开发服务器
tail -f .logs/dev-3000.log

# 大屏服务
tail -f .logs/bigscreen-5000.log

# 生产服务器（如有）
tail -f .logs/server-8080.log
```

### 重新安装依赖

```bash
cd growark
rm -rf node_modules
npm install

cd growark/server
rm -rf node_modules
npm install
```

### 构建失败

```bash
cd growark
npm run build

# 查看详细错误
vite build --debug
```

## 环境配置

### 数据库

位置: `growark/server/.env`

```
DATABASE_URL=mysql://username:password@host:port/database
```

### API 配置

位置: `server/config.js`

```javascript
window.__ENV__ = {
  API_BASE_URL: 'http://localhost:8080',
  WS_URL: 'http://localhost:8080'
}
```

## 相关文档

- [项目启动指南](./STARTUP.md) - 详细启动说明
- [大屏展示 README](./growark/bigscreen/README.md) - 大屏模块说明
- [移动端 README](./growark/README.md) - 移动端模块说明

## License

MIT License - 详见项目根目录 