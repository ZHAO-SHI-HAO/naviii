# 基于Node镜像创建一个新的镜像
FROM node:20-slim

# 设置容器内的工作目录
WORKDIR /usr/src/app

# 复制 package.json 和 package-lock.json (如果有)
COPY package*.json ./

# 安装项目依赖
RUN npm install

# 复制项目文件和目录到工作目录
COPY . .

# 构建Vue项目
RUN npm run build

# 使用Nginx镜像作为基础镜像来部署Vue项目
FROM nginx:1.27.0-alpine-slim

# 将Nginx服务器的默认端口映射到Docker容器的80端口
EXPOSE 80

# 复制构建好的Vue项目到Nginx的html目录下
COPY --from=0 ./dist /usr/share/nginx/html

# 启动Nginx，并且Nginx会持续运行
CMD ["nginx", "-g", "daemon off;"]