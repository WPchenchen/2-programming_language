# 启动一个 Vue 项目主要分两种情况：

------

### 🟢 情况 1：你已经有现成的 Vue 项目

比如别人给了你一个项目文件夹，里面有 `package.json`。

1. **进入项目目录**

   ```
   cd your-vue-project
   ```

2. **安装依赖**

   ```
   npm install
   ```

   （第一次运行必须执行，安装 `package.json` 里定义的依赖）

3. **启动开发服务器**

   - Vue 2（Vue CLI 搭建的）：

     ```
     npm run serve
     ```

   - Vue 3（Vite 搭建的）：

     ```
     npm run dev
     ```

4. **打开浏览器**
    默认会在 `http://localhost:8080`（Vue CLI） 或 `http://localhost:5173`（Vite） 启动。

------

### 🟢 情况 2：你要新建一个 Vue 项目

### Vue CLI（适合 Vue 2 / Vue 3）

1. 安装 Vue CLI

   ```
   npm install -g @vue/cli
   ```

2. 创建项目

   ```
   vue create my-project
   ```

   然后按提示选择配置。

3. 启动项目

   ```
   cd my-project
   npm run serve
   ```

### Vite（推荐，轻量、快速，默认支持 Vue 3）

1. 使用 Vite 创建

   ```
   npm create vite@latest my-project
   ```

   选择框架：`Vue` 或 `Vue + TypeScript`。

2. 进入并安装依赖

   ```
   cd my-project
   npm install
   ```

3. 启动项目

   ```
   npm run dev
   ```

------

### 🛠️ 常见问题

- **端口被占用**：启动时报端口冲突，可以换端口：

  ```
  npm run dev -- --port=3000
  ```

- **依赖缺失**：如果报错 `xxx module not found`，可以手动安装：

  ```
  npm install xxx
  ```

- **Node 版本问题**：建议 Node.js ≥ 16。可用 `node -v` 查看。







