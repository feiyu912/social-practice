# 贡献指南 (Contributing Guide)

感谢您有兴趣为学生社会实践管理系统做出贡献！

## 如何贡献

### 报告 Bug
1. 确保该 Bug 尚未被报告
2. 创建一个 Issue，包含详细描述和复现步骤

### 提交代码
1. Fork 本仓库
2. 创建功能分支：`git checkout -b feature/你的功能`
3. 提交更改：`git commit -m "feat: 添加功能"`
4. 推送分支：`git push origin feature/你的功能`
5. 创建 Pull Request

## 代码规范

### Java 命名规范
- 类名：大驼峰 `StudentService`
- 方法名：小驼峰 `findById`
- 常量：全大写 `MAX_SIZE`

### 提交消息格式
- `feat`: 新功能
- `fix`: Bug修复
- `docs`: 文档更新
- `style`: 代码格式
- `refactor`: 重构

## 开发流程

```bash
# 克隆项目
git clone <仓库地址>
cd SocialPractice

# 安装依赖
mvn clean install

# 运行项目
mvn exec:java -Dexec.mainClass=com.ssm.Application
```

## 项目结构

```
src/main/java/com/ssm/
├── controller/    # 控制器层
├── service/       # 服务层
├── dao/           # 数据访问层
├── entity/        # 实体类
├── interceptor/   # 拦截器
└── utils/         # 工具类
```

感谢您的贡献！