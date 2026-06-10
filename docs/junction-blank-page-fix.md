# Windows Junction 导致 Dashboard 启动白屏

## 问题描述

当插件通过 Windows **Junction**（目录联接）安装后，启动 Dashboard 时 Vite 报 `Pre-transform error`，浏览器页面空白，React 未渲染。

### 复现条件

| 条件 | 值 |
|------|-----|
| 操作系统 | Windows |
| 安装方式 | `~/.understand-anything-plugin` 是 Junction，指向实际项目目录 |
| 触发操作 | 从符号链接路径启动 Vite：`cd ~/.understand-anything-plugin/packages/dashboard && npx vite` |

### 错误日志

```
VITE v6.4.3  ready in 486 ms
➜  Local:   http://127.0.0.1:5173/

[vite] Pre-transform error: Unable to load "C:/Users/Administrator/.understand-anything-plugin/packages/dashboard/src/main.tsx"
The file is referenced at "E:/projects/202606/Understand-anything-plugin/packages/dashboard/index.html"
```

## 根因分析

### 三层路径分裂

```
process.cwd()     = C:\Users\Administrator\.understand-anything-plugin\packages\dashboard
                     （符号链接路径 — 用户 cd 到这里）

Node.js __dirname = E:\projects\202606\Understand-Anything\understand-anything-plugin\packages\dashboard
                     （真实路径 — Node.js 自动解引用 Junction）

esbuild 预构建时   = 用 cwd 路径找到 index.html，从中提取 src/main.tsx 的引用路径
                     但用 __dirname 路径去查找该文件 → 两个路径不一致 → 找不到
```

### 为什么是 Junction 而非 Symlink？

Windows 上 `mklink /J` 创建的是 Reparse Point（Junction），行为与 Unix symlink 不同：

- `Get-Item` 返回**符号链接路径**
- `Get-Item -LiteralPath` 或 Node.js `__dirname` 返回**真实目标路径**
- 两者在 esbuild 预构建阶段产生冲突

## 已尝试但失败的方案

### 方案 A：`preserveSymlinks: true`（vite.config.ts）

```typescript
// vite.config.ts
resolve: {
  preserveSymlinks: true,
}
```

**失败。** pnpm 的 node_modules 大量使用符号链接组织依赖。开启此选项后 esbuild 无法解析子路径导出（如 `graphology-utils/defaults`、`clsx`、`d3-quadtree` 等），导致 33 个模块解析错误。这是 pnpm + `preserveSymlinks` 的已知不兼容问题。

### 方案 B：SKILL.md 中添加 `realpath` 指令

SKILL.md 中已有 `realpath` 归一化代码，但它是"指令/说明书"，不是可执行脚本。AI agent 执行时可能跳过或简化，不可靠。

## 最终解决方案

新增平台专属的 Dashboard 启动脚本，在启动 Vite **之前**将符号链接解析为真实文件系统路径：

### 新增文件

1. **[start.cmd](../understand-anything-plugin/packages/dashboard/start.cmd)** — Windows 启动脚本
   - 使用 PowerShell `(Get-Item).Target` 解析 Junction 到真实路径
   - `cd /d <真实路径>` 后再启动 `npx vite`

2. **[start.sh](../understand-anything-plugin/packages/dashboard/start.sh)** — Linux/macOS 启动脚本
   - 使用 `readlink -f` 解析 symlink 到真实路径
   - `cd <真实路径>` 后再启动 `npx vite`

3. **[SKILL.md](../understand-anything-plugin/skills/understand-dashboard/SKILL.md)** 第 5 步修改
   - 从手动 `cd + npx vite` 改为强制调用启动脚本
   - 添加警告文字说明为什么不能跳过

### 使用方式

```batch
# Windows
<dashboard-dir>\start.cmd <project-dir>

# Linux/macOS
<dashboard-dir>/start.sh <project-dir>
```

## 防御层次总结

| 层级 | 机制 | 解决的问题 | 可靠性 |
|------|------|-----------|--------|
| 第 1 道 | 启动脚本 (`start.cmd` / `start.sh`) | 启动时自动解析符号链接 | 高 — 单条命令，无法拆解跳过 |
| 第 2 道 | SKILL.md 中的 `realpath` 代码 | 如果有人手动执行，提供正确路径参考 | 中 — 依赖执行者遵守 |
| 第 3 道 | SKILL.md 中的强烈警告文字 | 明确告知"不要手动 cd + npx vite" | 低 — 仅作为提示 |

## 背景：为什么需要 Junction

项目支持 13 个 IDE/CLI 平台（Claude Code、Trae CN、VS Code Copilot 等），每个平台的 skill 安装路径不同。安装脚本通过创建全局 Junction `~/.understand-anything-plugin` 统一入口，让所有 SKILL 文件都能定位到插件根目录。

主平台 Claude Code 不受此影响——它使用**复制**（cp -R）而非 symlink 安装插件，所以不存在路径分裂问题。此问题仅在通过 Junction/Symlink 安装的平台上出现。
