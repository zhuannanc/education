# ClassRoom Hero - 启动指南

## 快速启动

### 开发模式（默认）
```bash
bash entrypoint.sh
```

### 生产模式
```bash
bash entrypoint.sh production
```

## 服务端口配置

### 开发环境
| 服务 | 端口 | 用途 | URL |
|------|------|------|-----|
| 移动端管理后台 | 3000 | Vite 开发服务器 | http://localhost:3000 |
| 大屏展示 | 5000 | BigScreen 预览 | http://localhost:5000 |

### 生产环境
| 服务 | 端口 | 用途 | URL |
|------|------|------|-----|
| Express 服务器 | 8080 | API 和静态文件 | http://0.0.0.0:8080 |
| 大屏展示 | 5000 | BigScreen 预览 | http://0.0.0.0:5000 |

## entrypoint.sh 说明

### 文件位置
```
/home/devbox/project/entrypoint.sh
```

### 功能

#### 开发模式流程
1. 检查并安装 npm 依赖
2. 启动 Vite 开发服务器（端口 3000）
   - 支持热更新 (HMR)
   - 自动重新加载
3. 启动 BigScreen 预览服务器（端口 5000）
   - 静态构建文件服务
4. 输出访问地址和日志位置

#### 生产模式流程
1. 构建应用（如果未构建）
2. 启动 Express 服务器（端口 8080）
   - 提供 API 端点
   - 提供静态文件
3. 启动 BigScreen 预览服务器（端口 5000）
4. 输出访问地址和日志位置

### 日志文件
```
.logs/dev-3000.log         # 移动端开发服务器日志
.logs/bigscreen-5000.log   # 大屏服务器日志
.logs/server-8080.log      # Express 服务器日志（生产）
```

## 访问应用

### 移动端管理后台
- **功能**：学生管理、积分系统、习惯打卡、班级管理
- **开发**: http://localhost:3000
- **生产**: http://0.0.0.0:8080

### 大屏展示
- **功能**：实时排行榜、成就展示、PK 对战展示
- **开发**: http://localhost:5000
- **生产**: http://0.0.0.0:5000

## 停止服务

按 `Ctrl+C` 自动停止所有后台服务

## 数据库配置

### 连接字符串
位置: `/home/devbox/project/growark/server/.env`

```
DATABASE_URL=mysql://root:hwnhd2l4@dbconn.sealosbja.site:39785/growark
```

### 表结构
- **students**: 学生信息（id, name, points, exp, level, class_name）
- **events**: 事件日志（id, type, payload, created_at）

## API 端点

### GET 请求
- `/health` - 健康检查
- `/students` - 获取所有学生
- `/events` - SSE 事件推送

### POST 请求
- `/score` - 更新积分
- `/habit-checkin` - 习惯打卡
- `/challenge-status` - 挑战状态
- `/pk-winner` - PK 结果
- `/task-complete` - 任务完成
- `/badge-grant` - 授予勋章

## 故障排查

### 端口被占用
```bash
# 查看占用端口的进程
ss -tlnp | grep 3000
ss -tlnp | grep 5000

# 杀死进程
kill -9 <PID>
```

### 查看日志
```bash
# 查看移动端日志
tail -f .logs/dev-3000.log

# 查看大屏日志
tail -f .logs/bigscreen-5000.log
```

### 依赖问题
```bash
# 清理并重新安装
cd /home/devbox/project/growark
rm -rf node_modules
npm install
```

## Sealos 部署

### 端口转发配置
在 Sealos devbox 中添加：
- 8080 → 3000（移动端开发）
- 8081 → 5000（大屏展示）

### 访问 URL
- 移动端: `https://mcmgfetxlrug.sealosbja.site`
- 大屏: `https://mcmgfetxlrug.sealosbja.site:8081`

## 开发技术栈

- **前端**: React 18 + Vite + TypeScript
- **后端**: Express.js + MySQL
- **样式**: Tailwind CSS
- **实时通信**: Server-Sent Events (SSE)

## 文件结构

```
/home/devbox/project/
├── entrypoint.sh              # 启动脚本
├── growark/
│   ├── package.json           # 项目依赖
│   ├── vite.config.ts         # Vite 配置
│   ├── index.html             # 移动端入口
│   ├── index.tsx              # 移动端应用
│   ├── bigscreen/
│   │   ├── index.html         # 大屏入口
│   │   ├── main.tsx           # 大屏应用
│   │   └── preview-server.js  # 大屏服务器
│   ├── server/
│   │   ├── server.js          # Express 服务器
│   │   └── .env               # 环境配置
│   └── dist/                  # 构建输出
└── .logs/                     # 日志目录
```

## 常用命令

```bash
# 开发模式启动
bash entrypoint.sh

# 生产模式启动
bash entrypoint.sh production

# 构建应用
cd growark && npm run build

# 仅启动 Vite 开发服务器
cd growark && npm run dev

# 仅启动大屏服务器
PORT=5000 node growark/bigscreen/preview-server.js

# 查看所有运行的服务
ps aux | grep node | grep -v grep
```

## 更多帮助

有问题？检查：
1. 日志文件 (`.logs/`)
2. 数据库连接状态
3. 防火墙设置
4. 端口是否被占用
