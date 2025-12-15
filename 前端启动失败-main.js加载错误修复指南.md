# 前端启动失败 - main.js 加载错误修复指南

## 🐛 错误信息

```
10:41:04 [vite] Pre-transform error: Failed to load url /src/main.js (resolved id: /src/main.js). Does the file exist?
```

## 📋 问题分析

这个错误表明 Vite 无法加载 `main.js` 文件，但文件实际上是存在的。这通常是由以下原因导致：

1. **Vite 缓存问题** - 最常见
2. **node_modules 损坏**
3. **文件权限问题**
4. **路径解析问题**

---

## ✅ 解决方案（按优先级排序）

### 方案 1：清除 Vite 缓存（推荐）⭐

这是最常见的解决方案，成功率 90%+

```bash
# 进入前端目录
cd frontend

# 删除 Vite 缓存目录
rm -rf node_modules/.vite
# Windows 用户使用：
# rmdir /s /q node_modules\.vite

# 重新启动开发服务器
npm run dev
```

### 方案 2：完全清理并重新安装

如果方案 1 无效，尝试完全清理：

```bash
# 进入前端目录
cd frontend

# 1. 停止开发服务器（Ctrl+C）

# 2. 删除所有缓存和依赖
rm -rf node_modules
rm -rf .vite
rm -rf dist
rm package-lock.json

# Windows 用户使用：
# rmdir /s /q node_modules
# rmdir /s /q .vite
# rmdir /s /q dist
# del package-lock.json

# 3. 重新安装依赖
npm install

# 4. 启动开发服务器
npm run dev
```

### 方案 3：检查文件权限（Linux/Mac）

```bash
# 确保文件有读取权限
chmod -R 755 frontend/src
```

### 方案 4：使用 --force 标志

```bash
cd frontend
npm run dev -- --force
```

### 方案 5：检查 Node.js 版本

```bash
# 检查 Node.js 版本
node -v

# 推荐版本：Node.js 16.x 或更高
# 如果版本过低，请升级 Node.js
```

---

## 🔍 验证文件完整性

在清理缓存之前，先验证关键文件是否存在：

```bash
cd frontend

# 检查关键文件
ls -la src/main.js
ls -la src/app.vue
ls -la index.html
ls -la vite.config.js

# Windows 用户使用：
# dir src\main.js
# dir src\app.vue
# dir index.html
# dir vite.config.js
```

所有文件都应该存在且可读。

---

## 📝 详细步骤（推荐流程）

### 第一步：停止服务器
```bash
# 在运行 npm run dev 的终端按 Ctrl+C
```

### 第二步：清除缓存
```bash
cd frontend

# 删除 Vite 缓存
rm -rf node_modules/.vite

# 或者 Windows：
# rmdir /s /q node_modules\.vite
```

### 第三步：重新启动
```bash
npm run dev
```

### 第四步：验证
打开浏览器访问 `http://localhost:5173`，应该能正常看到登录页面。

---

## 🚨 如果问题仍然存在

### 检查 1：确认工作目录
```bash
# 确保在正确的目录
pwd
# 应该显示：.../Graduation Project test-1/frontend
```

### 检查 2：查看详细错误
```bash
# 使用 --debug 模式启动
npm run dev -- --debug
```

### 检查 3：检查端口占用
```bash
# 检查 5173 端口是否被占用
# Windows:
netstat -ano | findstr :5173

# Linux/Mac:
lsof -i :5173

# 如果被占用，杀死进程或更改端口
```

### 检查 4：验证 package.json
```bash
# 查看 package.json 中的 scripts
cat package.json | grep "dev"

# 应该显示：
# "dev": "vite"
```

---

## 💡 预防措施

### 1. 定期清理缓存
```bash
# 每周或遇到奇怪问题时
cd frontend
rm -rf node_modules/.vite
```

### 2. 使用 Git 忽略缓存
确保 `.gitignore` 包含：
```
node_modules/
.vite/
dist/
*.local
```

### 3. 保持依赖更新
```bash
# 定期更新依赖
npm update
```

---

## 🎯 快速命令参考

```bash
# 快速修复（一键执行）
cd frontend && rm -rf node_modules/.vite && npm run dev

# Windows 快速修复
cd frontend && rmdir /s /q node_modules\.vite && npm run dev

# 完全重置（如果快速修复无效）
cd frontend && rm -rf node_modules .vite dist package-lock.json && npm install && npm run dev
```

---

## 📊 常见错误对照表

| 错误信息 | 可能原因 | 解决方案 |
|---------|---------|---------|
| Failed to load url /src/main.js | Vite 缓存问题 | 删除 `.vite` 目录 |
| Does the file exist? | 缓存或权限问题 | 清除缓存 + 检查权限 |
| ENOENT: no such file | 文件真的不存在 | 检查文件是否存在 |
| Permission denied | 权限问题 | `chmod -R 755 src` |
| Port 5173 already in use | 端口占用 | 杀死进程或更改端口 |

---

## ✅ 验证修复成功

修复后，你应该看到：

```
  VITE v5.4.21  ready in 807 ms

  ➜  Local:   http://localhost:5173/
  ➜  Network: use --host to expose
  ➜  press h + enter to show help
```

**没有任何错误信息**，浏览器可以正常访问。

---

## 🆘 仍然无法解决？

如果以上所有方案都无效，请提供以下信息：

1. **操作系统**：Windows/Mac/Linux
2. **Node.js 版本**：`node -v`
3. **npm 版本**：`npm -v`
4. **完整错误日志**：复制所有错误信息
5. **文件是否存在**：`ls -la frontend/src/main.js` 的输出

---

## 📅 更新记录

- **2025-12-15**：创建文档，提供完整的故障排查流程