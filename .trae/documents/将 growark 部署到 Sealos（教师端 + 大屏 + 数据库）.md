## 总体架构
- 三端分层：`教师端(H5/移动网页)` → `后端 API` → `Sealos 数据库` → `大屏网页实时订阅`
- 部署目标：在 Sealos 上分别部署 `后端 API`、`教师端前端`、`大屏前端`，均提供公网 URL；数据库使用 Sealos 提供的托管实例，后端通过 `DATABASE_URL` 连接。
- 实时显示：后端通过 `WebSocket/SSE` 推送数据，`大屏网页`订阅更新，实现秒级实时刷新。

## 需要您提供的资料
- Git 仓库结构：教师端、后端、大屏端各自的根目录路径；主要启动命令（例如 `npm run dev`/`npm run start`/`pnpm build`）。
- 技术栈与运行端口：Node 版本/框架（React/Vue/Uni-App/Flutter Web 等），各服务默认监听端口（如 `3000/5173/8080`）。
- 数据库类型与驱动：代码目前使用 `PostgreSQL/MySQL/MongoDB` 其中哪一个；ORM/驱动（Prisma/Sequelize/TypeORM/Mongoose 等）。
- 环境变量与密钥：`.env(.example)` 中的必要变量（`DATABASE_URL`、`JWT_SECRET`、`API_BASE_URL` 等）。如无 `.env.example`，请提供变量名列表与示例值。
- 镜像仓库：用于推送容器镜像的 Registry（Docker Hub/GHCR/Sealos Registry），以及登录凭据。
- 域名需求：是否使用 Sealos 默认子域名，或绑定自有域名（需提供域名与可配置 DNS 权限）。

## 预检与环境准备（devbox 终端）
- 配置 SSH：用您提供的 `ssh:git@github.com:rf2025up/growark.git` 拉取代码到 devbox。
- 安装与校验：`docker`/`buildx`、`node` 与包管理器（npm/pnpm/yarn），保证可本地构建与产出。
- 登录镜像仓库：`docker login <registry>`，准备好命名空间与目标镜像名。

## 容器化与镜像构建
- 为三端分别准备 `Dockerfile`：
  - 教师端/大屏端（前端）：`node` 阶段打包 → `nginx` 提供静态文件；通过 `API_BASE_URL` 指向后端。
  - 后端 API：使用对应运行时（`node:XX-alpine`），暴露 `PORT`，读取 `DATABASE_URL` 环境变量。
- 本地构建与打标签：
  - `teacher`：`<registry>/<ns>/growark-teacher:<tag>`
  - `display`：`<registry>/<ns>/growark-display:<tag>`
  - `api`：`<registry>/<ns>/growark-api:<tag>`
- 推送镜像到仓库，供 Sealos 拉取部署。

## 在 Sealos 创建数据库
- 选择目标类型（建议 PostgreSQL，如代码已确定其他类型则按现有选择）。
- 创建实例并生成公网/内网连接串，拿到：`DATABASE_URL`、`DB_USER`、`DB_PASS`、`DB_HOST`、`DB_NAME`。
- 将连接串配置为 Sealos `App` 的环境变量与密钥（使用 Secret 管理）。
- 如项目使用 ORM 迁移：在 `api` 容器中运行迁移命令（如 `npx prisma migrate deploy`）。

## 部署后端 API
- 在 Sealos 创建 `growark-api` 应用：
  - 镜像：`<registry>/<ns>/growark-api:<tag>`；副本数 1–2；资源请求与限额按需配置。
  - 环境：`DATABASE_URL`、`PORT`、`NODE_ENV`、`JWT_SECRET`（如需要）。
  - 入口：`TCP 端口` 暴露为 HTTP 服务；健康检查 `/health`。
  - 域名：分配默认子域名（例如 `api-<random>.<sealos-domain>`）或绑定自定义域。

## 部署前端（教师端与大屏端）
- 教师端 H5：
  - 镜像：`<registry>/<ns>/growark-teacher:<tag>`，由 `nginx` 提供静态文件。
  - 环境：在构建或运行时注入 `API_BASE_URL` 指向后端域名。
  - 域名：分配公网链接（如 `teacher-<random>.<sealos-domain>`）。
- 大屏端：
  - 镜像：`<registry>/<ns>/growark-display:<tag>`，同样 `nginx` 静态站点。
  - 环境：`API_BASE_URL`（REST）与 `WS_URL`（WebSocket/SSE）指向后端。
  - 域名：分配公网链接（如 `display-<random>.<sealos-domain>`）。

## 域名与公网访问
- 若无自定义域名，使用 Sealos 默认子域即可满足公网访问。
- 如绑定自定义域名：在域名 DNS 添加 `CNAME` 到 Sealos 提供的入口域；申请与自动签发 `TLS`。

## 数据交互与实时显示
- 移动端操作：通过后端 API 写入/更新数据库。
- 大屏端订阅：通过 `WebSocket/SSE` 从后端订阅事件，增量刷新显示。
- 若后端当前仅有 REST：将新增事件通道（`/ws` 或 `/events`），并在数据变更时广播。

## 验证与交付
- 打通全链路：
  - 打开教师端链接 → 登录/操作 → 后端入库 → 大屏端实时显示。
  - 数据库可见性：在 Sealos 数据库控制台中查看表与最新记录。
- 自动化检查：
  - 健康探针返回 200。
  - 前端环境变量正确指向后端域名。
  - WebSocket/SSE 连接成功并有事件流。

## 备选与注意事项
- 镜像仓库：如无第三方仓库，可使用 GHCR 或 Sealos 自带 Registry。
- 资源与伸缩：根据访问规模设置 HPA 与资源限额；开启日志与监控。
- 安全：密钥使用 Sealos Secret 管理；禁用在日志打印数据库凭据。
- 构建缓存：`buildx` 与多平台镜像，如需 ARM/AMD 共同支持。

——
确认以上计划后，我将：在 devbox 终端完成镜像构建与推送 → 在 Sealos 创建数据库与三套应用 → 配置并发放三条公网链接（教师端、大屏端、后端 API）并完成全链路验证。