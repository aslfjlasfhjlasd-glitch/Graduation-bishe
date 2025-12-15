/// <reference types="vite/client" />

/**
 * Vite 环境变量类型声明文件
 *
 * 作用：
 * 1. 为 TypeScript 提供 Vite 相关的类型定义
 * 2. 让 import.meta.env 在 TypeScript 中可用（否则会报错）
 * 3. 支持 .env 文件中的环境变量类型提示
 *
 * 说明：
 * - 这是 Vite 项目的标准配置文件，由 Vite 脚手架自动生成
 * - 即使项目使用 JavaScript（非 TypeScript），这个文件也有助于 IDE 提供更好的代码提示
 * - 不需要修改此文件，保持原样即可
 *
 * 示例：
 * 在代码中可以使用：
 * - import.meta.env.MODE (开发模式: 'development' 或 'production')
 * - import.meta.env.VITE_API_BASE_URL (自定义环境变量，需在 .env 文件中定义)
 */

// 如果需要自定义环境变量的类型提示，可以在这里扩展：
interface ImportMetaEnv {
  readonly VITE_API_BASE_URL: string
  // 可以添加更多自定义环境变量...
}

interface ImportMeta {
  readonly env: ImportMetaEnv
}

