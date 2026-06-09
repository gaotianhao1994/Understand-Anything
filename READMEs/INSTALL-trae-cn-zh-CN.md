# Understand-Anything Trae CN 安装指南

> **适用于：** Windows + Trae CN IDE
> **最后更新：** 2026-06-10

---

## 快速开始（有经验的用户）

```powershell
# 1. 克隆仓库
git clone https://github.com/Lum1104/Understand-Anything.git C:\understand-anything

# 2. 运行安装脚本
cd C:\understand-anything
.\install.ps1 trae-cn

# 3. 重启 Trae CN，然后使用：
# /understand          — 分析当前项目
# /understand-dashboard — 打开可视化仪表板
```

> 完成以上三步即可开始使用。下面的文档包含详细的步骤说明和常见问题解答。

---

## 1. 项目介绍

### 是什么？

**Understand-Anything** 是一个开源工具，结合 LLM 智能和静态分析（Tree-sitter）来生成代码库的交互式知识图谱仪表板。它通过多智能体（multi-agent）架构扫描你的项目，提取文件、函数、类以及依赖关系，构建一个可搜索、可探索、可对话的知识图谱。

### 为什么需要它？

当你刚加入一个新团队，面对数万行代码时，传统的"盲读代码"方式效率极低。Understand-Anything 从全局视角呈现系统结构——每个文件、函数、类都是可点击的节点，选择任意节点即可查看摘要、依赖关系和学习路径。

### 安装后的功能概述（8 个 Skills）

| Skill | 命令 | 功能 |
|-------|------|------|
| **项目分析** | `/understand` | 扫描项目并生成知识图谱（核心功能） |
| **可视化仪表板** | `/understand-dashboard` | 启动 Web 界面查看交互式图谱 |
| **智能问答** | `/understand-chat` | 基于知识图谱询问代码库问题 |
| **变更影响分析** | `/understand-diff` | 分析当前修改对系统的影响 |
| **文件深度解读** | `/understand-explain <path>` | 深入理解某个具体文件 |
| **新人引导指南** | `/understand-onboard` | 为新团队成员生成上手指南 |
| **业务领域提取** | `/understand-domain` | 提取业务领域知识和流程图 |
| **知识库分析** | `/understand-knowledge <path>` | 分析 Karpathy 模式的 LLM Wiki |

---

## 2. 前置条件

### 必需项

| 工具 | 版本要求 | 用途 | 检查命令 |
|------|----------|------|----------|
| **Git** | 任意版本 | 克隆仓库 | `git --version` |
| **PowerShell** | 5.1+（Windows 内置） | 执行安装脚本 | `$PSVersionTable.PSVersion` |
| **Trae CN** | 最新版 | 目标 IDE 平台 | 打开 Trae CN 即可 |

### 可选项（仅 Dashboard 功能需要）

| 工具 | 版本要求 | 用途 |
|------|----------|------|
| **Node.js** | >= 22 | 运行 Vite 开发服务器 |
| **pnpm** | >= 10 | 包管理器（项目锁定此版本） |

> 如果你只需要 `/understand` 分析功能而不需要可视化仪表板，可以不安装 Node.js 和 pnpm。

### 权限要求

- 安装脚本会创建 **Junction（目录联接）**，不需要管理员权限
- Junction 是 Windows NTFS 的原生功能，在用户目录下操作无需提权
- 如果你的 PowerShell 执行策略限制了脚本运行，请参考 [FAQ #2](#q-powershell-执行策略错误)

---

## 3. 安装步骤

### 方法一：在线安装（推荐）

这是最简单的方式，适合大多数用户：

```powershell
# Step 1: 克隆仓库到本地
git clone https://github.com/Lum1104/Understand-Anything.git C:\understand-anything

# Step 2: 进入目录
cd C:\understand-anything

# Step 3: 运行安装脚本，指定平台为 trae-cn
.\install.ps1 trae-cn
```

**预期输出：**

```
→ Cloning https://github.com/Lum1104/Understand-Anything.git → C:\understand-anything
# （git clone 的输出...）

→ Linking skills for trae-cn (per-skill → C:\Users\你的用户名\.trae-cn\skills)
  ✓ C:\Users\你的用户名\.trae-cn\skills\understand → C:\understand-anything\understand-anything-plugin\skills\understand
  ✓ C:\Users\你的用户名\.trae-cn\skills\understand-chat → C:\understand-anything\understand-anything-plugin\skills\understand-chat
  ✓ C:\Users\你的用户名\.trae-cn\skills\understand-dashboard → C:\understand-anything\understand-anything-plugin\skills\understand-dashboard
  ✓ C:\Users\你的用户名\.trae-cn\skills\understand-diff → C:\understand-anything\understand-anything-plugin\skills\understand-diff
  ✓ C:\Users\你的用户名\.trae-cn\skills\understand-domain → C:\understand-anything\understand-anything-plugin\skills\understand-domain
  ✓ C:\Users\你的用户名\.trae-cn\skills\understand-explain → C:\understand-anything\understand-anything-plugin\skills\understand-explain
  ✓ C:\Users\你的用户名\.trae-cn\skills\understand-knowledge → C:\understand-anything\understand-anything-plugin\skills\understand-knowledge
  ✓ C:\Users\你的用户名\.trae-cn\skills\understand-onboard → C:\understand-anything\understand-anything-plugin\skills\understand-onboard
→ Linking universal plugin root
  ✓ C:\Users\你的用户名\.understand-anything-plugin → C:\understand-anything\understand-anything-plugin

✓ Installed Understand-Anything for trae-cn
  Restart your CLI or IDE to pick up the skills.
```

### 方法二：本地仓库安装（适合已有仓库或网络问题）

如果你已经克隆了仓库，或者 `git clone` 因网络问题失败：

```powershell
# 设置环境变量指向你已有的仓库路径
$env:UA_DIR = 'E:\projects\202606\Understand-Anything'

# 然后运行安装脚本（它会跳过 git clone，直接使用已有仓库）
cd E:\projects\202606\Understand-Anything
.\install.ps1 trae-cn
```

**适用场景：**
- 你已经从其他方式获取了仓库（如下载 ZIP）
- 公司内网无法访问 GitHub
- `git clone` 速度太慢或超时

### 方法三：手动安装（完全离线）

如果上述方法都不可用，可以手动创建 Junction 链接：

```powershell
# ===== 配置区域（请根据实际情况修改）=====
$RepoDir   = "C:\understand-anything"                              # 仓库根目录
$SkillsSrc = Join-Path $RepoDir "understand-anything-plugin\skills" # skills 源目录
$TargetDir = Join-Path $HOME ".trae-cn\skills"                      # Trae CN skills 目录
$PluginLink = Join-Path $HOME ".understand-anything-plugin"         # 全局插件链接
# ===========================================

# 1. 创建目标目录（如果不存在）
if (-not (Test-Path $TargetDir)) {
    New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
    Write-Host "✓ 创建目录: $TargetDir"
}

# 2. 为每个 skill 创建 Junction
$skillNames = @(
    "understand",
    "understand-chat",
    "understand-dashboard",
    "understand-diff",
    "understand-domain",
    "understand-explain",
    "understand-knowledge",
    "understand-onboard"
)

foreach ($skill in $skillNames) {
    $linkPath = Join-Path $TargetDir $skill
    $srcPath  = Join-Path $SkillsSrc $skill

    if (Test-Path $linkPath) {
        $item = Get-Item -LiteralPath $linkPath -Force
        if ($item.LinkType -eq 'Junction') { $item.Delete() }
    }

    New-Item -ItemType Junction -Path $linkPath -Target $srcPath | Out-Null
    Write-Host "✓ $linkPath → $srcPath"
}

# 3. 创建全局插件 Junction
if (-not (Test-Path $PluginLink)) {
    $pluginSrc = Join-Path $RepoDir "understand-anything-plugin"
    New-Item -ItemType Junction -Path $PluginLink -Target $pluginSrc | Out-Null
    Write-Host "✓ $PluginLink → $pluginSrc"
}

Write-Host "`n✓ 手动安装完成！请重启 Trae CN。"
```

将上面的代码保存为 `.ps1` 文件后运行，或直接在 PowerShell 中逐段执行。

---

## 4. 验证安装

### 检查 Skills 链接是否正确创建

```powershell
Get-ChildItem "$HOME\.trae-cn\skills" | Where-Object { $_.Name -like 'understand*' } | Select-Object Name, LinkType, Target
```

**预期输出：**

```
Name                  LinkType Target
----                  -------- ------
understand            Junction C:\understand-anything\understand-anything-plugin\skills\understand
understand-chat       Junction C:\understand-anything\understand-anything-plugin\skills\understand-chat
understand-dashboard  Junction C:\understand-anything\understand-anything-plugin\skills\understand-dashboard
understand-diff       Junction C:\understand-anything\understand-anything-plugin\skills\understand-diff
understand-domain     Junction C:\understand-anything\understand-anything-plugin\skills\understand-domain
understand-explain    Junction C:\understand-anything\understand-anything-plugin\skills\understand-explain
understand-knowledge  Junction C:\understand-anything\understand-anything-plugin\skills\understand-knowledge
understand-onboard    Junction C:\understand-anything\understand-anything-plugin\skills\understand-onboard
```

### 检查全局插件链接

```powershell
Get-Item "$HOME\.understand-anything-plugin" | Select-Object Name, LinkType, Target, FullName
```

**预期输出：**

```
Name                        LinkType Target                                                        FullName
----                        -------- ------                                                        --------
.understand-anything-plugin Junction C:\understand-anything\understand-anything-plugin             C:\Users\你的用户名\.understand-anything-plugin
```

### 在 Trae CN 中验证

1. **重启 Trae CN**（必须重启才能加载新的 skills）
2. 打开任意项目
3. 在聊天框中输入 `/understand`
4. 如果看到自动补全提示弹出 understand 相关的 skills，说明安装成功

---

## 5. 使用指南

### 5.1 分析你的项目

在 Trae CN 中打开你要分析的项目，然后在聊天框中输入：

```
/understand
```

**工作流程：**

1. **Phase 0** — 准备检查（确定全量/增量模式）
2. **Phase 1** — 扫描项目文件（检测语言、框架）
3. **Phase 2** — 分析文件结构（多 agent 并行处理）
4. **Phase 3** — 组装与审查图谱
5. **Phase 4** — 识别架构层级
6. **Phase 5** — 构建引导式学习路径
7. **Phase 6** — 验证知识图谱完整性
8. **Phase 7** — 保存结果到 `.understand-anything/knowledge-graph.json`

**常用参数：**

```bash
# 生成中文内容
/understand --language zh

# 强制全量重建（忽略已有的图谱）
/understand --full

# 只分析某个子目录（适合大型 monorepo）
/understand src/frontend

# 启用每次提交后自动增量更新
/understand --auto-update
```

### 5.2 查看可视化仪表板

**前提条件：** 必须先运行过 `/understand` 并成功生成知识图谱。

```
/understand-dashboard
```

这会启动一个 Vite 开发服务器，并在浏览器中打开交互式仪表板：

- **深色奢华主题**：黑色背景 + 金色/琥珀色强调
- **75% 图谱 + 360px 右侧边栏**布局
- 支持缩放、平移、搜索节点
- 点击节点查看代码摘要和依赖关系

**仪表板启动后会输出类似：**

```
🔑  Dashboard URL: http://127.0.0.1:5173?token=abc123xyz
```

> ⚠️ **注意：** URL 中的 `?token=` 参数是必需的，没有它仪表板会显示"Access Token Required"。SKILL.md 已修复了通过 Junction 路径启动 Vite 时可能出现的模块找不到问题。

### 5.3 其他常用 Skill

```bash
# 询问代码库问题
/understand-chat How does the payment flow work?

# 分析当前未提交的修改影响
/understand-diff

# 深入理解某个文件
/understand-explain src/auth/login.ts

# 为新人生成上手指南
/understand-onboard

# 提取业务领域知识
/understand-domain

# 分析 Wiki 知识库
/understand-knowledge ~/my-wiki
```

### 注意事项

- **必须先分析才能查看 Dashboard**：`/understand-dashboard` 依赖 `.understand-anything/knowledge-graph.json` 文件
- **增量更新**：再次运行 `/understand` 默认只分析变更的文件，速度更快
- **大型项目建议限定范围**：超过 100 个文件时会提示确认，可以用子目录参数缩小范围

---

## 6. 常见问题解答 (FAQ)

### Q1: git clone 失败怎么办？

**现象：** `git clone` 超时、连接被重置或 SSL 错误。

**解决方案：**

```powershell
# 方案 A: 使用代理（如果有）
git config --global http.proxy http://127.0.0.1:7890
git config --global https.proxy http://127.0.0.1:7890
git clone https://github.com/Lum1104/Understand-Anything.git C:\understand-anything

# 方案 B: 使用镜像站（国内用户推荐）
git clone https://ghproxy.net/https://github.com/Lum1104/Understand-Anything.git C:\understand-anything

# 方案 C: 手动下载 ZIP 后解压，然后用【方法二】本地安装
```

### Q2: PowerShell 执行策略错误？

**现象：** 运行 `.\install.ps1` 时报错：
```
无法加载文件 ... 因为在此系统上禁止运行脚本。
```

**解决方案：**

```powershell
# 方案 A: 临时允许当前会话执行脚本（推荐，不影响系统安全策略）
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\install.ps1 trae-cn

# 方案 B: 使用 bypass 方式直接调用
powershell -ExecutionPolicy Bypass -File .\install.ps1 trae-cn

# 方案 C: 仅对该脚本绕过限制
powershell -ExecutionPolicy Bypass -Command "& .\install.ps1 trae-cn"
```

### Q3: Vite 启动报错找不到模块？

**现象：** 运行 `/understand-dashboard` 时 Vite 报错找不到依赖模块。

**原因：** Windows Junction 路径在某些情况下可能导致 Node.js 模块解析异常。此问题已在 SKILL.md 中修复——dashboard 启动逻辑会先解析真实路径再执行。

**解决方案：**

```powershell
# 1. 确保 Node.js >= 22
node --version  # 应显示 v22.x.x 或更高

# 2. 确保 pnpm >= 10
pnpm --version  # 应显示 10.x.x 或更高

# 3. 手动预构建 core 包
cd C:\understand-anything\understand-anything-plugin
pnpm install
pnpm --filter @understand-anything/core build

# 4. 然后重新尝试 /understand-dashboard
```

如果仍然报错，尝试直接在 dashboard 目录下启动：

```powershell
cd C:\understand-anything\understand-anything-plugin\packages\dashboard
pnpm install
GRAPH_DIR="你的项目路径" npx vite --host 127.0.0.1
```

### Q4: 如何确认安装成功？

按以下顺序检查：

1. **检查 Junction 是否存在**（见[第 4 节](#4-验证安装)）
2. **重启 Trae CN**
3. **在聊天框输入 `/`**，看是否有 `understand` 开头的 skill 出现在补全列表中
4. **输入 `/understand`**，看 AI 是否识别该命令并开始分析

### Q5: Junction 和 Symlink 有什么区别？

| 特性 | Junction（目录联接） | SymbolicLink（符号链接） |
|------|---------------------|------------------------|
| **权限要求** | 不需要管理员权限 | 通常需要管理员权限 |
| **适用范围** | 仅限目录 | 文件和目录均可 |
| **跨文件系统** | 不支持 | 支持 |
| **本方案选择** | ✅ 使用 Junction | — |
| **删除安全性** | 删除 Junction 只删链接，不影响源目录 | 同上 |

本项目选择 Junction 是因为它不需要管理员权限，且我们只需链接目录（不需要链接单个文件）。

### Q6: 可以同时安装多个平台吗？

**可以！** 安装脚本支持多平台共存。例如你可以同时安装 Trae CN 和 VS Code Copilot：

```powershell
.\install.ps1 trae-cn
.\install.ps1 vscode
```

所有平台共享同一个仓库副本（默认位于 `%USERPROFILE%\.understand-anything\repo`），只是在不同平台的 skills 目录中创建了不同的 Junction 链接。

**已支持的平台列表：** `gemini`、`codex`、`opencode`、`pi`、`openclaw`、`antigravity`、`vscode`、`hermes`、`cline`、`kimi`、`trae`、`trae-cn`

### Q7: Trae CN 和 Trae（国际版）有什么区别？

- **Trae CN**：skills 目录位于 `~/.trae-cn/skills`，平台标识为 `trae-cn`
- **Trae（国际版）**：skills 目录位于 `~/.trae/skills`，平台标识为 `trae`

两者安装方式相同，只是平台参数不同：

```powershell
# Trae CN 用户
.\install.ps1 trae-cn

# Trae 国际版用户
.\install.ps1 trae
```

---

## 7. 卸载和更新

### 卸载

```powershell
cd C:\understand-anything
.\install.ps1 -Uninstall trae-cn
```

**这会做以下事情：**
- 移除 `~/.trae-cn/skills/` 下所有 `understand*` 的 Junction 链接
- 移除全局插件链接 `~/.understand-anything-plugin`
- **保留仓库副本**（其他平台可能还在使用）

如果要完全删除包括仓库：

```powershell
# 先卸载链接
.\install.ps1 -Uninstall trae-cn

# 再删除仓库（谨慎操作！）
Remove-Item -Recurse -Force "$HOME\.understand-anything"
```

### 更新

```powershell
# 方式一：使用内置更新命令
cd C:\understand-anything
.\install.ps1 -Update

# 方式二：手动 git pull（效果相同）
cd C:\understand-anything
git pull
```

更新完成后同样需要**重启 Trae CN** 才能生效。

---

## 下一步

安装完成后，你可以：

1. 🚀 **立即开始分析** — 在 Trae CN 中打开任意项目，输入 `/understand`
2. 📖 **阅读完整 README** — 查看 [README.zh-CN.md](./README.zh-CN.md) 了解全部功能和高级用法
3. 💬 **加入社区** — 在 [Discord](https://discord.gg/pydat66RY) 中提问和分享经验
4. 🌐 **在线体验** — 访问 [understand-anything.com/demo](https://understand-anything.com/demo/) 查看演示效果
5. 🤝 **参与贡献** — 发现 Bug 或有新想法？欢迎提交 Issue 或 PR

---

## 技术细节参考

### 目录结构说明

安装完成后，你的系统中会有以下关键路径：

```
C:\understand-anything\                          # 仓库根目录（clone 位置）
└── understand-anything-plugin\                   # 插件主目录
    ├── packages\
    │   ├── core\                                 # 核心分析引擎
    │   └── dashboard\                            # React 可视化仪表板
    ├── skills\                                   # 8 个 skill 定义
    │   ├── understand\                           # /understand
    │   ├── understand-chat\                      # /understand-chat
    │   ├── understand-dashboard\                 # /understand-dashboard
    │   ├── understand-diff\                      # /understand-diff
    │   ├── understand-domain\                    # /understand-domain
    │   ├── understand-explain\                   # /understand-explain
    │   ├── understand-knowledge\                 # /understand-knowledge
    │   └── understand-onboard\                   # /understand-onboard
    └── agents\                                   # Agent 定义

%USERPROFILE%\.trae-cn\skills\                    # Trae CN skills 目录
├── understand → (Junction) → ...\skills\understand
├── understand-chat → (Junction) → ...\skills\understand-chat
├── ... (共 8 个 Junction)

%USERPROFILE%\.understand-anything-plugin\        # 全局插件链接 (Junction)
→ (Junction) → C:\understand-anything\understand-anything-plugin
```

### 环境变量

| 变量名 | 用途 | 示例 |
|--------|------|------|
| `UA_REPO_URL` | 覆盖 Git 仓库地址 | `https://mirror.example.com/repo.git` |
| `UA_DIR` | 覆盖仓库本地路径 | `E:\dev\Understand-Anything` |

### 输出文件

分析完成后，在你的项目目录下会产生：

```
<你的项目>\
└── .understand-anything\
    ├── knowledge-graph.json      # 知识图谱（核心输出）
    ├── meta.json                # 元数据（分析时间、commit hash 等）
    ├── config.json              # 配置（语言偏好、自动更新等）
    └── .understandignore        # 排除规则（类似 .gitignore）
```

---

<p align="center">
  <strong>不再盲读代码，而是理解整个系统</strong>
</p>

<p align="center">
  MIT 许可证 &copy; <a href="https://github.com/Lum1104">Lum1104</a>
</p>
